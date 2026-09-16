from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.models.match import Match
from app.db import get_db
from app.schemas.match import MatchOut
from sqlalchemy import asc, and_, or_
from datetime import datetime, time

router = APIRouter()


# get all match coming
@router.get("/matchcoming", response_model=list[MatchOut])
def readMatch(db: Session = Depends(get_db)):
    today_midnight = datetime.combine(datetime.today(), time.min)
    map_list = (
        db.query(Match)
        .filter(
            or_(
                and_(Match.status == "finished", Match.begin_at >= today_midnight),
                Match.status == "upcoming",
                Match.status == "live",
            )
        )
        .order_by(asc(Match.begin_at))
        .all()
    )

    # if map_list is None:
    #     raise HTTPException(status_code=404, detail="Match not found")

    return map_list