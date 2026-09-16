from typing import List
import uuid
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy import desc
from sqlalchemy.orm import Session
from app.db import get_db
from app.schemas.game import BracketOut, TournamentOut
from app.models.game import Tournament
from app.services.tour.pandascore import getBracket
from app.services.tour.map import mapBracket

router = APIRouter()


@router.get("/tournament", response_model=List[TournamentOut])
def readTour(db: Session = Depends(get_db)):

    tour_list = db.query(Tournament).order_by(desc(Tournament.begin_at)).all()

    return tour_list


@router.get("/tournament/bracket/{tournament_id}", response_model=List[BracketOut])
def readBracket(tournament_id: uuid.UUID, db: Session = Depends(get_db)):

    tour = db.query(Tournament).filter(Tournament.id == tournament_id).first()

    if tour is None:
        raise HTTPException(status_code=404, detail="tournament type bracket not found")

    bracket_list = getBracket(tour.pandascore_id)

    result = []
    for r in bracket_list:
        result.append(mapBracket(r))

    return result
