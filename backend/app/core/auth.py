import uuid
from fastapi import Depends, Header, HTTPException
import httpx
from sqlalchemy.orm import Session
from app.db import get_db
from app.core.config import settings
from app.models.user import Profile


def getCurrentUser(
    authorization: str | None = Header(None), db: Session = Depends(get_db)
) -> uuid.UUID:

    if authorization is None or not authorization.startswith("Bearer "):
        raise HTTPException(status_code=401, detail="Unauthorized")

    token = authorization.removeprefix("Bearer ")

    res = httpx.get(
        f"{settings.supabase_url}/auth/v1/user",
        headers={"Authorization": f"Bearer {token}", "apikey": settings.supabase_key},
    )

    if res.status_code != 200:
        raise HTTPException(status_code=401, detail="Unauthorized")

    user = res.json()
    # print(user)
    user_id = uuid.UUID(user["id"])
    user = db.query(Profile).filter(Profile.id == user_id).first()
    
    if user is None:
        db.add(Profile(id=user_id))
        db.commit()
    
    return user_id
