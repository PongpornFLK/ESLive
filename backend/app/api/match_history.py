import uuid
from typing import List
from sqlalchemy.orm import Session
from fastapi import APIRouter, Depends, HTTPException
from app.db import get_db
from app.schemas.match import MatchHistoryOut
from app.models.match import Match
from app.services.ai.match_analyze import getFormHistory

router = APIRouter()


@router.get("/match/history/{match_id}", response_model=MatchHistoryOut)
def readMatchHistory(match_id: uuid.UUID, db: Session = Depends(get_db)):

    match = db.query(Match).filter(Match.id == match_id).first()

    if match is None:
        raise HTTPException(status_code=404, detail="Match Not Found")

    form_team_a = getFormHistory(db,match.team_a_id)
    form_team_b = getFormHistory(db,match.team_b_id)
    
    return {
        "form_a": form_team_a,
        "form_b": form_team_b,
    }

