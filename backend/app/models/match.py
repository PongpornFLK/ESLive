import enum
import uuid

from sqlalchemy import ForeignKey, String, BigInteger, Integer, Numeric, Text
from sqlalchemy.dialects.postgresql import UUID, TIMESTAMP, JSONB
from sqlalchemy.orm import Mapped, mapped_column, relationship
from sqlalchemy.sql import func
from sqlalchemy import Enum as SAEnum

from app.db import Base


class MatchStatus(str, enum.Enum):
    upcoming = "upcoming"
    live = "live"
    finished = "finished"


class AnalysisStatus(str, enum.Enum):
    pending = "pending"
    ready = "ready"
    failed = "failed"


match_status_type = SAEnum(MatchStatus, name="match_status")
analysis_status_type = SAEnum(AnalysisStatus, name="analysis_status")


class Match(Base):
    __tablename__ = "match"

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    game_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("game.id"), nullable=False)
    tournament_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("tournament.id"), nullable=False)
    team_a_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("team.id"), nullable=False)
    team_b_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("team.id"), nullable=False)
    winner_team_id: Mapped[uuid.UUID | None] = mapped_column(ForeignKey("team.id"))
    status: Mapped[MatchStatus] = mapped_column(match_status_type, nullable=False, default=MatchStatus.upcoming)
    scheduled_at: Mapped[object] = mapped_column(TIMESTAMP(timezone=True), nullable=False)
    score_a: Mapped[int | None] = mapped_column(Integer)
    score_b: Mapped[int | None] = mapped_column(Integer)
    stream_url: Mapped[str | None] = mapped_column(String)
    source_priority: Mapped[str | None] = mapped_column(String)
    pandascore_id: Mapped[int | None] = mapped_column(BigInteger, unique=True)
    riot_id: Mapped[str | None] = mapped_column(String, unique=True)
    last_synced_at: Mapped[object | None] = mapped_column(TIMESTAMP(timezone=True))
    created_at: Mapped[object] = mapped_column(TIMESTAMP(timezone=True), server_default=func.now())

    team_a: Mapped["Team"] = relationship(foreign_keys=[team_a_id])
    team_b: Mapped["Team"] = relationship(foreign_keys=[team_b_id])
    winner_team: Mapped["Team | None"] = relationship(foreign_keys=[winner_team_id])
    analysis: Mapped["MatchAnalysis | None"] = relationship(back_populates="match", uselist=False)


class MatchAnalysis(Base):
    __tablename__ = "match_analysis"

    match_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("match.id"), primary_key=True)
    status: Mapped[AnalysisStatus] = mapped_column(
        analysis_status_type, nullable=False, default=AnalysisStatus.pending
    )
    win_pct_a: Mapped[float | None] = mapped_column(Numeric)
    win_pct_b: Mapped[float | None] = mapped_column(Numeric)
    reasoning: Mapped[str | None] = mapped_column(Text)
    key_players: Mapped[dict | None] = mapped_column(JSONB)
    generated_at: Mapped[object | None] = mapped_column(TIMESTAMP(timezone=True))

    match: Mapped["Match"] = relationship(back_populates="analysis")


class PatchNote(Base):
    __tablename__ = "patch_note"

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    game_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("game.id"), nullable=False)
    version: Mapped[str] = mapped_column(String, nullable=False)
    raw_source_url: Mapped[str | None] = mapped_column(String)
    raw_content: Mapped[str | None] = mapped_column(Text)
    ai_summary: Mapped[str | None] = mapped_column(Text)
    status: Mapped[AnalysisStatus] = mapped_column(
        analysis_status_type, nullable=False, default=AnalysisStatus.pending
    )
    published_at: Mapped[object | None] = mapped_column(TIMESTAMP(timezone=True))
    created_at: Mapped[object] = mapped_column(TIMESTAMP(timezone=True), server_default=func.now())
