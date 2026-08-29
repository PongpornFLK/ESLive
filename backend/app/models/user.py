import enum
import uuid

from sqlalchemy import ForeignKey, String, Boolean, Integer
from sqlalchemy.dialects.postgresql import UUID, TIMESTAMP
from sqlalchemy.orm import Mapped, mapped_column
from sqlalchemy.sql import func
from sqlalchemy import Enum as SAEnum

from app.db import Base


class ThemePref(str, enum.Enum):
    dark = "dark"
    light = "light"


class LanguagePref(str, enum.Enum):
    th = "th"
    en = "en"


theme_pref_type = SAEnum(ThemePref, name="theme_pref")
language_pref_type = SAEnum(LanguagePref, name="language_pref")


class Profile(Base):
    """Mirrors a row in auth.users (Supabase Auth). id is not generated here —
    it is assigned by Supabase Auth when the user session (incl. anonymous) is created."""

    __tablename__ = "profiles"

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True)
    display_name: Mapped[str | None] = mapped_column(String)
    theme: Mapped[ThemePref] = mapped_column(theme_pref_type, nullable=False, default=ThemePref.dark)
    language: Mapped[LanguagePref] = mapped_column(language_pref_type, nullable=False, default=LanguagePref.th)
    notify_all_matches: Mapped[bool] = mapped_column(Boolean, nullable=False, default=False)
    notify_before_minutes: Mapped[int] = mapped_column(Integer, nullable=False, default=15)
    created_at: Mapped[object] = mapped_column(TIMESTAMP(timezone=True), server_default=func.now())


class FollowTeam(Base):
    __tablename__ = "follow_team"

    profile_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("profiles.id"), primary_key=True)
    team_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("team.id"), primary_key=True)
    created_at: Mapped[object] = mapped_column(TIMESTAMP(timezone=True), server_default=func.now())


class FollowPlayer(Base):
    __tablename__ = "follow_player"

    profile_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("profiles.id"), primary_key=True)
    player_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("player.id"), primary_key=True)
    created_at: Mapped[object] = mapped_column(TIMESTAMP(timezone=True), server_default=func.now())


class MatchNotificationOverride(Base):
    __tablename__ = "match_notification_override"

    profile_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("profiles.id"), primary_key=True)
    match_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("match.id"), primary_key=True)
    enabled: Mapped[bool] = mapped_column(Boolean, nullable=False, default=True)
