def mapPatch(raw: dict, game_id) -> dict | None:

    raw_source_url = raw["url"]
    published_at = raw["date"]
    title = raw["title"]
    raw_content = raw["description"]

    if title.split()[1] == "Patch" and title.split()[2] == "Notes":
        num = title.split()[3].replace(".", "").isdigit()
        if num == True:
            version = title.split()[3]

            return {
                "game_id": game_id,
                "raw_content": raw_content,
                "version": version,
                "raw_source_url": raw_source_url,
                "published_at": published_at,
            }

