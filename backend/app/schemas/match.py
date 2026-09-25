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
    reasoning_eng: str | None
    reasoning_th: str | None
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


class HistoryRowOut(BaseModel):
    # 1 แถว = 1 นัดที่ทีมนั้นเคยแข่ง
    # ไม่ใช้ from_attributes เพราะประกอบเป็น dict เองใน service
    result: str  # "W" หรือ "L"
    opponent_name: str
    opponent_logo: str | None
    score_team: int | None
    score_opponent: int | None
    begin_at: datetime


class MatchHistoryOut(BaseModel):
    # ฟอร์มล่าสุดของทั้ง 2 ทีม ว่างได้ถ้าทีมยังไม่เคยมีประวัติในระบบ
    form_a: list[HistoryRowOut]
    form_b: list[HistoryRowOut]


class PatchNoteOut(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: uuid.UUID
    game: GameOut
    version: str
    ai_summary_eng: str | None
    ai_summary_th: str | None
    raw_content: str
    raw_source_url: str | None
    status: AnalysisStatus
    published_at: datetime | None
