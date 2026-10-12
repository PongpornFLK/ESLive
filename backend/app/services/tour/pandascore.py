from app.core.config import settings
from app.core.http import http

##### Bracket
def getBracket(tournament_id: int) -> dict:
    res = http.get(
        f"https://api.pandascore.co/tournaments/{tournament_id}/brackets",
        headers={"Authorization": f"Bearer {settings.pandascore_api_key}"},
    )
    return res.json()

##### Group
def getStanding(tournament_id: int) -> dict:
    res = http.get(
        f"https://api.pandascore.co/tournaments/{tournament_id}/standings",
        headers={"Authorization": f"Bearer {settings.pandascore_api_key}"},
    )
    return res.json()

def getPandaListTour(gameSlug : str) -> dict:
    res = http.get(
        f"https://api.pandascore.co/{gameSlug}/tournaments",
        headers={"Authorization": f"Bearer {settings.pandascore_api_key}"},
        params={"per_page" : 100}, 
    )
    return res.json()