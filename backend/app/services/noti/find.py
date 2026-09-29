from datetime import datetime, timedelta, timezone

from sqlalchemy import or_
from sqlalchemy.orm import Session

from app.models.match import Match
from app.models.user import DeviceToken, FollowTeam, MatchNotified, Profile

# มองไปข้างหน้าไกลสุดเท่านี้ ต้องกว้างกว่า notify_before_minutes ที่ผู้ใช้ตั้งได้มากที่สุด
# ดึงมาเผื่อไว้ก่อน แล้วค่อยคัดทีละคนด้วยเวลาของเขาเองในภาษา Python
MAX_LOOKAHEAD_MINUTES = 180


def _text(lang: str, team_a: str, team_b: str, minutes: int) -> tuple[str, str]:
    # ข้อความนบนหน้าจอ
    if lang == "th":
        return (f"{team_a} พบ {team_b}", f"อีก {minutes} นาทีจะเริ่มแข่ง")

    return (f"{team_a} vs {team_b}", f"Starts in {minutes} minutes")


def findDue(db: Session) -> list[dict]:
    now = datetime.now(timezone.utc)
    limit = now + timedelta(minutes=MAX_LOOKAHEAD_MINUTES)

    # แมตช์ที่ยังไม่แข่ง กำลังจะเริ่ม และมีคนตามทีมใดทีมหนึ่งอยู่
    # or_ เพราะคนที่ตามทีม A หรือทีม B ก็ควรได้รับเหมือนกัน
    rows = (
        db.query(Match, Profile)
        .join(
            FollowTeam,
            or_(
                FollowTeam.team_id == Match.team_a_id,
                FollowTeam.team_id == Match.team_b_id,
            ),
        )
        .join(Profile, Profile.id == FollowTeam.profile_id)
        .filter(
            Match.status == "upcoming",
            Match.begin_at > now,
            Match.begin_at <= limit,
        )
        .all()
    )

    # คนที่ตามทั้งสองทีมในแมตช์เดียวกันจะได้ 2 แถว ยุบเหลือคู่ละครั้ง
    pairs: dict[tuple, tuple] = {}
    for match, profile in rows:
        pairs[(profile.id, match.id)] = (match, profile)

    if not pairs:
        return []

    # เคยเตือนคู่ไหนไปแล้วบ้าง ดึงมาทีเดียว ไม่ query ทีละคู่
    already = {
        (r.profile_id, r.match_id)
        for r in db.query(MatchNotified)
        .filter(MatchNotified.profile_id.in_({p for p, _ in pairs}))
        .all()
    }

    # token ทุกเครื่องของทุกคนที่เกี่ยวข้อง จัดกลุ่มไว้ล่วงหน้า
    tokens: dict = {}
    for row in (
        db.query(DeviceToken)
        .filter(DeviceToken.profile_id.in_({p for p, _ in pairs}))
        .all()
    ):
        tokens.setdefault(row.profile_id, []).append(row.token)

    due = []
    for (profile_id, match_id), (match, profile) in pairs.items():
        if (profile_id, match_id) in already:
            continue

        # ยังไม่ถึงเวลาของคนนี้ รอบหน้าค่อยว่ากัน
        minutes_left = int((match.begin_at - now).total_seconds() // 60)
        if minutes_left > profile.notify_before_minutes:
            continue

        # ล็อกอินไว้แต่ไม่มีเครื่องลงทะเบียน ส่งไปก็ไม่ถึง
        my_tokens = tokens.get(profile_id, [])
        if not my_tokens:
            continue

        title, body = _text(
            profile.language.value, match.team_a.name, match.team_b.name, minutes_left
        )

        due.append(
            {
                "profile_id": profile_id,
                "match_id": match_id,
                "tokens": my_tokens,
                "title": title,
                "body": body,
            }
        )

    return due
