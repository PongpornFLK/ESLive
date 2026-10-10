import re


def mapPatch(raw: dict, game_id) -> dict | None:
    raw_source_url = raw["url"]
    published_at = raw["date"]
    title = raw["title"]
    raw_content = raw["description"]    

    find_patch = re.search(r"\bPatch\b\D*?(\d+(?:\.\d+)+)", title, re.IGNORECASE)
    
    if find_patch is None:
        return None

    version = find_patch.group(1)
        
    return {
        "game_id": game_id,
        "raw_content": raw_content,
        "version": version,
        "raw_source_url": raw_source_url,
        "published_at": published_at,
    }

###  Patern Patch each of game
# VALORANT Patch Notes 11.08
# League of Legends Patch 26.20 Notes    
