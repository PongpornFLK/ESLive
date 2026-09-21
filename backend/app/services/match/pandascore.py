import httpx
from app.core.config import settings


def getPandaMatch(gameSlug: str, status: str) -> list[dict]:
    if status != "finished":
        res = httpx.get(
            f"https://api.pandascore.co/matches/{status}",
            headers={
                "Authorization": f"Bearer {settings.pandascore_api_key}",
            },
            params={"filter[videogame]": gameSlug, "per_page": 100},
        )

        return res.json()


def getPandaTourForMatch(tournament_id: int) -> dict:
    res = httpx.get(
        f"https://api.pandascore.co/tournaments/{tournament_id}",
        headers={
            "Authorization": f"Bearer {settings.pandascore_api_key}",
        },
    )

    return res.json()
