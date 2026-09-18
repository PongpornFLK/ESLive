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
    has_bracket: bool | None
    prizepool: str | None
    begin_at: datetime | None
    end_at: datetime | None
    created_at: datetime


class PreviousMatchOut(BaseModel):
    type: str
    match_id: int


class BracketOut(BaseModel):
    match_id: int
    name: str
    best_of_game: int
    status: str
    begin_at: datetime | None
    team_a_name: str | None
    team_b_name: str | None
    score_a: int
    score_b: int
    winner_team: str | None
    from_matches: list[PreviousMatchOut]


class StandingOut(BaseModel):
    #1 row = 1 team
    #มีแค่ rank กับ team ที่อยู่ครบที่เหลือเป็น | None
    rank: int
    team_name: str
    team_logo: str | None

    # 24 แถวไม่มีฟิลด์กลุ่มนี้
    matches_played: int | None
    wins: int | None
    losses: int | None
    game_wins: int | None
    game_losses: int | None
    game_ties: int | None
