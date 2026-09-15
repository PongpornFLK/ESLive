from fastapi import FastAPI
from app.core.config import settings
from app.api import match, patch, tour

app = FastAPI(title="ESLive API")

app.include_router(match.router)
app.include_router(patch.router)
app.include_router(tour.router)


@app.get("/health")
def health():
    return {"status": "ok"}
