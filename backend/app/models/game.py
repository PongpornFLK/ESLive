import uuid

from sqlalchemy import ForeignKey, String, BigInteger, Integer, Boolean
from sqlalchemy.dialects.postgresql import UUID, TIMESTAMP
from sqlalchemy.orm import Mapped, mapped_column, relationship
from sqlalchemy.sql import func

from app.db import Base


class Game(Base):
    __tablename__ = "game"

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    slug: Mapped[str] = mapped_column(String, unique=True, nullable=False)
    name: Mapped[str] = mapped_column(String, nullable=False)
    pandascore_slug: Mapped[str | None] = mapped_column(String)
    logo_url: Mapped[str | None] = mapped_column(String)
    created_at: Mapped[object] = mapped_column(TIMESTAMP(timezone=True), server_default=func.now())

    teams: Mapped[list["Team"]] = relationship(back_populates="game")
    tournaments: Mapped[list["Tournament"]] = relationship(back_populates="game")


class Team(Base):
    __tablename__ = "team"

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    game_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("game.id"), nullable=False)
    name: Mapped[str] = mapped_column(String, nullable=False)
    logo_url: Mapped[str | None] = mapped_column(String)
    pandascore_id: Mapped[int | None] = mapped_column(BigInteger, unique=True)
    riot_id: Mapped[str | None] = mapped_column(String, unique=True)
    created_at: Mapped[object] = mapped_column(TIMESTAMP(timezone=True), server_default=func.now())

    game: Mapped["Game"] = relationship(back_populates="teams")
    players: Mapped[list["Player"]] = relationship(back_populates="team")


class Player(Base):
    __tablename__ = "player"

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    team_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("team.id"), nullable=False)
    handle: Mapped[str] = mapped_column(String, nullable=False)
    pandascore_id: Mapped[int | None] = mapped_column(BigInteger, unique=True)
    riot_id: Mapped[str | None] = mapped_column(String, unique=True)
    created_at: Mapped[object] = mapped_column(TIMESTAMP(timezone=True), server_default=func.now())

    team: Mapped["Team"] = relationship(back_populates="players")


class Tournament(Base):
    __tablename__ = "tournament"

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    game_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("game.id"), nullable=False)
    name: Mapped[str] = mapped_column(String, nullable=False)
    league_name: Mapped[str | None] = mapped_column(String)
    league_logo_url: Mapped[str | None] = mapped_column(String)
    region: Mapped[str | None] = mapped_column(String)
    type: Mapped[str | None] = mapped_column(String)
    team_count: Mapped[int | None] = mapped_column(Integer)
    has_bracket: Mapped[bool | None] = mapped_column(Boolean)
    prizepool: Mapped[str | None] = mapped_column(String)
    begin_at: Mapped[object | None] = mapped_column(TIMESTAMP(timezone=True))
    end_at: Mapped[object | None] = mapped_column(TIMESTAMP(timezone=True))
    pandascore_id: Mapped[int | None] = mapped_column(BigInteger, unique=True)
    created_at: Mapped[object] = mapped_column(TIMESTAMP(timezone=True), server_default=func.now())

    game: Mapped["Game"] = relationship(back_populates="tournaments")
