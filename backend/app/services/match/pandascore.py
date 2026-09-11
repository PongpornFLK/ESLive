import httpx
from app.core.config import settings


def getPandaAPI(gameSlug: str , status : str) -> list[dict]:
    if status != "finished":
        res = httpx.get(
            f"https://api.pandascore.co/matches/{status}",
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
