import uuid
from datetime import datetime

from pydantic import BaseModel, ConfigDict

from app.models.user import ThemePref, LanguagePref


class ProfileOut(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: uuid.UUID
    display_name: str | None
    theme: ThemePref
    language: LanguagePref
    notify_all_matches: bool
    notify_before_minutes: int


class ProfileUpdate(BaseModel):
    display_name: str | None = None
    theme: ThemePref | None = None
    language: LanguagePref | None = None
    notify_all_matches: bool | None = None
    notify_before_minutes: int | None = None


class FollowTeamOut(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    team_id: uuid.UUID
    created_at: datetime


class FollowPlayerOut(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    player_id: uuid.UUID
    created_at: datetime
