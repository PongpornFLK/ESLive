import uuid
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy import and_
from sqlalchemy.orm import Session
from app.core.auth import getCurrentUser
from app.schemas.user import (
    FollowTeamIn,
    FollowTeamOut,
    DeviceTokenIn,
    ProfileOut,
    ProfileUpdate,
)
from app.models.game import Team
from app.models.user import DeviceToken, FollowTeam, Profile
from app.db import get_db

router = APIRouter()


@router.get("/user", response_model=ProfileOut)
def readUser(user_id=Depends(getCurrentUser), db: Session = Depends(get_db)):
    # getCurrentUser สร้างแถวให้แล้วถ้ายังไม่มี ตรงนี้จึงเจอเสมอ
    return db.query(Profile).filter(Profile.id == user_id).first()


@router.patch("/user", response_model=ProfileOut)
def updateUser(
    payload: ProfileUpdate,
    user_id=Depends(getCurrentUser),
    db: Session = Depends(get_db),
):
    profile = db.query(Profile).filter(Profile.id == user_id).first()

    if profile is None:
        raise HTTPException(status_code=404, detail="Profile not found")

    # exclude_unset=True คืนเฉพาะ field ที่ client ส่งมาจริง
    # ที่ไม่ได้ส่งมาจะไม่อยู่ใน dict เลย ค่าเดิมจึงไม่ถูกเขียนทับ
    for field, value in payload.model_dump(exclude_unset=True).items():
        setattr(profile, field, value)

    db.commit()
    db.refresh(profile)

    return profile


# FOLLOWER ---------------------------------------
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


# DEVICE TOKEN ---------------------------------------
@router.post("/user/device")
def createToken(
    payload: DeviceTokenIn,
    user_id=Depends(getCurrentUser),
    db: Session = Depends(get_db),
):

    data = db.query(DeviceToken).filter(DeviceToken.token == payload.token).first()

    if data is None:
        db.add(DeviceToken(token=payload.token, profile_id=user_id))
        db.commit()
    elif data.profile_id != user_id:
        data.profile_id = user_id
        db.commit()

    return {"ok": True}


@router.delete("/user/device/{token}")
def deleteToken(
    token: str, user_id=Depends(getCurrentUser), db: Session = Depends(get_db)
):

    db.query(DeviceToken).filter(
        and_(DeviceToken.token == token, DeviceToken.profile_id == user_id)
    ).delete()
    db.commit()

    return {"ok": True}
