import httpx

from app.core.config import settings

BASE_URL = "https://api.pandascore.co"


def _get(path: str, params: dict | None = None) -> httpx.Response:
    response = httpx.get(
        f"{BASE_URL}{path}",
        headers={"Authorization": f"Bearer {settings.pandascore_api_key}"},
        params=params,
        timeout=15,
    )
    response.raise_for_status()
    return response


def get_upcoming_matches(videogame_slug: str, per_page: int = 50) -> list[dict]:
    """Fetch upcoming (not yet started) matches for one game, newest-scheduled first."""
    response = _get(
        "/matches/upcoming",
        params={"filter[videogame]": videogame_slug, "per_page": per_page, "sort": "begin_at"},
    )
    return response.json()
