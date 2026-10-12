from collections import defaultdict
from typing import List
import uuid
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy import asc, desc
from sqlalchemy.orm import Session
from app.db import get_db
from app.schemas.game import BracketOut, StandingOut, TournamentOut, SerieOut
from app.models.game import Game, Tournament
from app.services.tour.pandascore import getBracket, getStanding
from app.services.tour.map import mapBracket, mapGroupStanding

router = APIRouter()

playoff_list = {
    "playoff",
    "play-in",
    "play-ins",
    "knockout",
    "final four",
    "gauntlet",
    "last chance",
    "seed decider",
}

def isPlayoff(name: str) -> bool:
    word_low = name.lower()  # Playoffs= True / Group A = False

    for t in playoff_list:
        if t in word_low:
            return True

    return False


@router.get("/tournament", response_model=List[SerieOut])
def readTour(game_slug: str | None = None, db: Session = Depends(get_db)):

    if game_slug is not None:
        game = db.query(Game).filter(Game.slug == game_slug).first()
        if game is None:
            raise HTTPException(status_code=404, detail="Not Found")

        tour = (
            db.query(Tournament)
            .filter(Tournament.serie_id.isnot(None))
            .order_by(asc(Tournament.begin_at))
            .filter(Tournament.game_id == game.id)
            .all()
        )
    else:
        tour = (
            db.query(Tournament)
            .filter(Tournament.serie_id.isnot(None))
            .order_by(asc(Tournament.begin_at))
            .all()
        )

    bracket = defaultdict(list)
    result = []

    # ลงตาม serie_id
    for t in tour:
        bracket[t.serie_id].append(t)

    for stage in bracket.values():  # stage[list]
        playoff = []
        group = []

        for t in stage:  # แยก stages play กับ group
            if isPlayoff(t.name):
                playoff.append(t)
            else:
                group.append(t)

        # เรียง playoff , group ตามชื่อ
        playoff.sort(key=lambda t: (t.begin_at is None, t.begin_at, t.name))
        group.sort(key=lambda t: t.name)

        # date max/min ของทุก stage
        begins = []
        ends = []

        for t in stage:
            if t.begin_at:
                begins.append(t.begin_at)
            if t.end_at:
                ends.append(t.end_at)

        if begins:
            start = min(begins)
        else:
            start = None

        if ends:
            end = max(ends)
        else:
            end = None

        # เงินรางวัล
        prize = None
        for s in stage:
            if s.prizepool:
                prize = s.prizepool
                break

        # จำนวนทีม
        counts = [s.team_count for s in stage if s.team_count]
        group_sum = sum(s.team_count for s in group if s.team_count)
        teams = max(max(counts), group_sum) if counts else None

        result.append(
            SerieOut(
                serie_id=stage[0].serie_id,
                serie_name=stage[0].serie_name,
                league_name=stage[0].league_name,
                league_logo_url=stage[0].league_logo_url,
                region=stage[0].region,
                type=stage[0].type,
                begin_at=start,
                end_at=end,
                prizepool=prize,
                team_count=teams,
                playoff_stages=playoff,
                group_stages=group,
            )
        )

    # เรียงนอกลูป
    result.sort(key=lambda t: (t.begin_at is not None, t.begin_at), reverse=True)

    return result


@router.get("/tournament/bracket/{tournament_id}", response_model=List[BracketOut])
def readBracket(tournament_id: uuid.UUID, db: Session = Depends(get_db)):

    tour = db.query(Tournament).filter(Tournament.id == tournament_id).first()

    if tour is None:
        raise HTTPException(status_code=404, detail="Data source unavailable")

    bracket_list = getBracket(tour.pandascore_id)

    if not isinstance(bracket_list, list):
        raise HTTPException(status_code=502, detail="Error")

    result = []
    for r in bracket_list:
        result.append(mapBracket(r))

    return result


@router.get("/tournament/standing/{tournament_id}", response_model=List[StandingOut])
def readStanding(tournament_id: uuid.UUID, db: Session = Depends(get_db)):

    tour = db.query(Tournament).filter(Tournament.id == tournament_id).first()

    if tour is None:
        raise HTTPException(status_code=404, detail="Data source unavailable")

    group_list = getStanding(tour.pandascore_id)

    if not isinstance(group_list, list):
        raise HTTPException(status_code=502, detail="Error")

    result = []
    for r in group_list:
        result.append(mapGroupStanding(r))

    return result
