import httpx


def getPatchRiot(game : str , zone : str):

    res = httpx.get(f"https://data.rito.news/{game}/{zone}/news.json")

    return res.json()
