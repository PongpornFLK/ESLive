import httpx
from app.core.config import settings


def getPandaAPI(gameSlug: str) -> list[dict]:
    res = httpx.get(
        "https://api.pandascore.co/matches/upcoming",
        headers={
            "Authorization": f"Bearer {settings.pandascore_api_key}",
        },
        params={"filter[videogame]": gameSlug, "per_page": 2},
    )

    return res.json()


# # Test API : python -m app.services.pandascore
# if __name__ == "__main__":
#     result = getPandaAPI("valorant")
#     print(result)
