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


class FollowTeamIn(BaseModel):
    # ตอน POST client ส่งมาแค่ว่าจะตามทีมไหน profile_id มาจาก token ไม่ใช่จาก body
    team_id: uuid.UUID


class FollowTeamOut(BaseModel):
    # ไม่ใช้ from_attributes เพราะประกอบเป็น dict เองจาก join follow_team + team
    # ชื่อคีย์ตรงกับที่ FollowData.fromjson ฝั่ง Flutter อ่านอยู่แล้ว
    team_id: uuid.UUID
    team_name: str
    logo_url: str | None



