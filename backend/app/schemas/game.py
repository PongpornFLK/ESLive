import uuid
from datetime import datetime

from pydantic import BaseModel, ConfigDict


class GameOut(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: uuid.UUID
    slug: str
    name: str
    pandascore_slug: str | None
    logo_url: str | None
    created_at: datetime


class TeamOut(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: uuid.UUID
    game_id: uuid.UUID
    name: str
    logo_url: str | None
    created_at: datetime


class PlayerOut(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: uuid.UUID
    team_id: uuid.UUID
    handle: str
    created_at: datetime


class TournamentOut(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: uuid.UUID
    game_id: uuid.UUID
    name: str
    league_name: str | None
    league_logo_url: str | None
    region: str | None
    type: str | None
    team_count: int | None
    prizepool: str | None
    begin_at: datetime | None
    end_at: datetime | None
    created_at: datetime
