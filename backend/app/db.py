import sqlalchemy as _sql
import sqlalchemy.ext.declarative as _declarative
import sqlalchemy.orm as _orm

from app.core.config import settings

DATABASE_URL = settings.database_url or "postgresql://myuser:password@localhost:5432/fastapi_database"
# Supabase (and some other providers) hand out "postgres://" URLs, but SQLAlchemy
# only recognizes the "postgresql://" dialect name.
DATABASE_URL = DATABASE_URL.replace("postgres://", "postgresql://", 1)

engine = _sql.create_engine(
    DATABASE_URL,
    pool_size=10,
    max_overflow=20,
    pool_timeout=30,
    pool_pre_ping=True,  # สำคัญมากสำหรับ Supabase เพื่อตรวจสอบ connection ที่อาจโดนตัด
    pool_recycle=3600,
)

SessionLocal = _orm.sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = _declarative.declarative_base()


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
