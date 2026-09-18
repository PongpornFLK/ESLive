from typing import List
import uuid
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy import desc
from sqlalchemy.orm import Session
from app.db import get_db
from app.schemas.game import BracketOut, StandingOut, TournamentOut
from app.models.game import Tournament
from app.services.tour.pandascore import getBracket, getStanding
from app.services.tour.map import mapBracket, mapGroupStanding

router = APIRouter()


@router.get("/tournament", response_model=List[TournamentOut])
def readTour(db: Session = Depends(get_db)):

    tour_list = db.query(Tournament).order_by(desc(Tournament.begin_at)).all()

    return tour_list


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