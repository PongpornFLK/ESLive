from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session, joinedload
from app.models.match import Match
from app.db import get_db
from app.schemas.match import MatchOut
from sqlalchemy import asc, and_, or_
from datetime import datetime, time, timedelta, timezone

router = APIRouter()


# get all match coming
@router.get("/matchcoming", response_model=list[MatchOut])
def readMatch(db: Session = Depends(get_db)):
    today_midnight = datetime.combine(datetime.today(), time.min)
    cut_time = datetime.now(timezone.utc) - timedelta(hours=12)

    map_list = (
        db.query(Match)
        .options(
            joinedload(Match.game),
            joinedload(Match.tournament),
            joinedload(Match.team_a),
            joinedload(Match.team_b),
            joinedload(Match.analysis),
        )
        .filter(
            or_(
                and_(Match.status == "finished", Match.begin_at >= today_midnight),
                and_(Match.status == "upcoming", Match.begin_at >= cut_time),
                and_(Match.status == "live", Match.begin_at >= cut_time),
                and_(Match.status == "canceled", Match.begin_at >= today_midnight),
            )
        )
        .order_by(asc(Match.begin_at))
        .all()
    )

    # if map_list is None:
    #     raise HTTPException(status_code=404, detail="Match not found")

    return map_list
