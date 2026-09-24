import uuid
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy import and_
from sqlalchemy.orm import Session
from app.core.auth import getCurrentUser
from app.schemas.user import FollowTeamIn, FollowTeamOut
from app.models.game import Team
from app.models.user import FollowTeam
from app.db import get_db

router = APIRouter()


@router.get("/user")
def readUser(user_id=Depends(getCurrentUser)):

    return {"user_id": str(user_id)}


@router.get("/user/follow", response_model=list[FollowTeamOut])
def readUserFollow(user_id=Depends(getCurrentUser), db: Session = Depends(get_db)):

    # ตอน fol จะมี team_name , logo
    follow_team = (
        db.query(FollowTeam, Team)
        .join(Team, Team.id == FollowTeam.team_id)
        .filter(FollowTeam.profile_id == user_id)
        .all()
    )

    raw = []
    for f, t in follow_team:
        raw.append({"team_id": f.team_id, "team_name": t.name, "logo_url": t.logo_url})

    return raw


@router.post("/user/follow", response_model=FollowTeamOut)
def createFollow(
    payload: FollowTeamIn,
    user_id=Depends(getCurrentUser),
    db: Session = Depends(get_db),
):

    team = db.query(Team).filter(Team.id == payload.team_id).first()

    if team is None:
        raise HTTPException(status_code=404, detail="Team not found")

    follow = (
        db.query(FollowTeam)
        .filter(and_(FollowTeam.team_id == team.id, FollowTeam.profile_id == user_id))
        .first()
    )

    if follow is None:
        db.add(FollowTeam(profile_id=user_id, team_id=team.id))
        db.commit()

    return {"team_id": team.id, "team_name": team.name, "logo_url": team.logo_url}


@router.delete("/user/follow/{team_id}")
def deleteFollow(
    team_id: uuid.UUID,
    user_id=Depends(getCurrentUser),
    db: Session = Depends(get_db),
):
    db.query(FollowTeam).filter(
        FollowTeam.profile_id == user_id,
        FollowTeam.team_id == team_id,
    ).delete()
    db.commit()

    return {"ok": True}
