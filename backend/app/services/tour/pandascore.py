import httpx
from app.core.config import settings

##### Bracket
def getBracket(tournament_id: int) -> dict:
    res = httpx.get(
        f"https://api.pandascore.co/tournaments/{tournament_id}/brackets",
        headers={"Authorization": f"Bearer {settings.pandascore_api_key}"},
    )
    return res.json()

##### Group
def getStanding(tournament_id: int) -> dict:
    res = httpx.get(
        f"https://api.pandascore.co/tournaments/{tournament_id}/standings",
        headers={"Authorization": f"Bearer {settings.pandascore_api_key}"},
    )
    return res.json()

def getPandaListTour(gameSlug : str) -> dict:
    res = httpx.get(
        f"https://api.pandascore.co/{gameSlug}/tournaments",
        headers={"Authorization": f"Bearer {settings.pandascore_api_key}"},
    )
    return res.json()