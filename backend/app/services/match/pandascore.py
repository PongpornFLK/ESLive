import httpx
from app.core.config import settings


def getPandaMatch(gameSlug: str, status: str) -> list[dict]:
    if status != "finished":
        res = httpx.get(
            f"https://api.pandascore.co/matches/{status}",
            headers={
                "Authorization": f"Bearer {settings.pandascore_api_key}",
            },
            params={"filter[videogame]": gameSlug, "per_page": 2},
        )

        return res.json()


def getPandaTour(tournament_id: int) -> dict:
    res = httpx.get(
        f"https://api.pandascore.co/tournaments/{tournament_id}",
        headers={
            "Authorization": f"Bearer {settings.pandascore_api_key}",
        },
    )

    return res.json()


# # Test API : python -m app.services.pandascore
# if __name__ == "__main__":
#     result = getPandaAPI("valorant")
#     print(result)
