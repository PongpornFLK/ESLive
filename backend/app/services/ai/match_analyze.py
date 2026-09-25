from datetime import datetime, timezone
import json
import uuid
from sqlalchemy import and_, desc, or_
from sqlalchemy.orm import Session
from app.models.match import Match, MatchAnalysis
from app.services.ai.prompt_match import prompt_list_match
from app.models.game import Game, Team
from app.services.ai.gemini import getGemini


# เลือกที่จบไปแล้ว 5 match ล่าสุดไปของแต่ละ team ไปแสดง
def getFormHistory(db: Session, team_id: uuid.UUID, limit=5):

    match = (
        db.query(Match)
        .filter(
            Match.status == "finished",
            or_(Match.team_a_id == team_id, Match.team_b_id == team_id),
        )
        .order_by(desc(Match.begin_at))
        .limit(limit)
        .all()
    )

    if not match:
        return []

    raw = []
    for m in match:
        is_a = m.team_a_id == team_id
        opponent = m.team_b if is_a else m.team_a
        result = "W" if m.winner_team_id == team_id else "L"

        raw.append(
            {
                "result": result,
                "opponent_name": opponent.name,
                "opponent_logo": opponent.logo_url,
                "score_team": m.score_a if is_a else m.score_b,
                "score_opponent": m.score_b if is_a else m.score_a,
                "begin_at": m.begin_at,
            }
        )

    return raw


# เลือกที่จบไปแล้ว 5 match ล่าสุดไป Analyze
def getForm(db: Session, team_id: uuid.UUID, limit=5):

    match = (
        db.query(Match)
        .filter(
            Match.status == "finished",
            or_(Match.team_a_id == team_id, Match.team_b_id == team_id),
        )
        .order_by(desc(Match.begin_at))
        .limit(limit)
        .all()
    )

    if not match:
        return "ไม่มีข้อมูลในระบบ"

    count_w = 0
    count_l = 0
    result = []  # เก็บ W/L ล่าสุด

    for m in match:
        if m.winner_team_id == team_id:
            count_w += 1
            result.append("W")
        else:
            count_l += 1
            result.append("L")

    text = f"ชนะ {count_w} แพ้ {count_l} จาก {len(match)} นัดหลัง ({' '.join(result)})"

    return text


# ดู H2H ที่เจอกันเอง
def getH2H(db: Session, team_a_id: uuid.UUID, team_b_id: uuid.UUID):
    match_h2h = (
        db.query(Match)
        .filter(
            Match.status == "finished",
            or_(
                and_(Match.team_a_id == team_a_id, Match.team_b_id == team_b_id),
                and_(Match.team_a_id == team_b_id, Match.team_b_id == team_a_id),
            ),
        )
        .all()
    )

    if not match_h2h:
        return "ไม่เคยเจอกัน"

    team = db.query(Team).filter(Team.id == team_a_id).first()
    team_name = team.name

    count_w = 0
    count_l = 0

    for m in match_h2h:
        if m.winner_team_id == team_a_id:
            count_w += 1
        else:
            count_l += 1

    text = f"การเจอกันมาทั้งหมด {len(match_h2h)} นัด โดยทีม {team_name} ชนะไป {count_w} นัด , แพ้ {count_l} นัด"

    return text


def checkStatus(db: Session, match_id: uuid.UUID):

    match = db.query(Match).filter(Match.id == match_id).first()

    if match is None:
        return None
    match_ai = (
        db.query(MatchAnalysis).filter(MatchAnalysis.match_id == match.id).first()
    )

    if match_ai is None:
        return

    try:
        if match_ai.status != "ready":
            reason = prompt_list_match[match.game.slug].format(
                game_name=match.game.name,
                tour_name=match.tournament.league_name,
                region=match.tournament.region,
                team_a=match.team_a.name,
                team_b=match.team_b.name,
                form_a=getForm(db, match.team_a_id),
                form_b=getForm(db, match.team_b_id),
                h2h=getH2H(db, match.team_a_id, match.team_b_id),
            )

            answer = getGemini(reason)

            # แก้ json """
            raw = json.loads(answer[answer.find("{") : answer.rfind("}") + 1])

            match_ai.win_pct_a = raw["win_pct_a"]
            match_ai.win_pct_b = raw["win_pct_b"]
            match_ai.status = "ready"
            match_ai.reasoning_eng = raw["reasoning_eng"]
            match_ai.reasoning_th = raw["reasoning_th"]
            match_ai.generated_at = datetime.now(timezone.utc)

    except Exception as e:
        match_ai.status = "failed"
        print(e)

    db.commit()

    return match_ai
