import uuid
from datetime import datetime

from pydantic import BaseModel, ConfigDict

from app.models.match import MatchStatus, AnalysisStatus
from app.schemas.game import TeamOut, TournamentOut, GameOut


class MatchAnalysisOut(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    status: AnalysisStatus
    win_pct_a: float | None
    win_pct_b: float | None
    reasoning: str | None
    key_players: dict | None
    generated_at: datetime | None


class MatchOut(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: uuid.UUID
    game: GameOut
    tournament: TournamentOut
    team_a: TeamOut
    team_b: TeamOut
    winner_team_id: uuid.UUID | None
    status: MatchStatus
    begin_at: datetime
    score_a: int | None
    score_b: int | None
    stream_url: str | None
    analysis: MatchAnalysisOut | None


class PatchNoteOut(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: uuid.UUID
    game: GameOut
    version: str
    ai_summary: str | None
    raw_content: str
    raw_source_url: str | None
    status: AnalysisStatus
    published_at: datetime | None
