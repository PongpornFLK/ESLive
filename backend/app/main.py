from fastapi import FastAPI

from app.core.config import settings

app = FastAPI(title="ESLive API")


@app.get("/health")
def health():
    return {"status": "ok"}
