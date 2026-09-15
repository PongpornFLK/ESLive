from typing import List
from fastapi import APIRouter, Depends
from sqlalchemy import desc
from sqlalchemy.orm import Session
from app.db import get_db
from app.schemas.game import TournamentOut
from app.models.game import Tournament

router = APIRouter()


@router.get("/tournament", response_model=List[TournamentOut])
def readTour(db: Session = Depends(get_db)):

    tour_list = db.query(Tournament).order_by(desc(Tournament.begin_at)).all()

    return tour_list
