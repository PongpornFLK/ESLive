from app.models.match import MatchStatus


def mapMatch(raw: dict, team_a_id, team_b_id, game_id, tournament_id) -> dict:

    if raw["status"] == "not_started":
        status = MatchStatus.upcoming
    elif raw["status"] == "running":
        status = MatchStatus.live
    elif raw["status"] == "finished":
        status = MatchStatus.finished
    else:
        status = MatchStatus.upcoming

    opp_a_id = raw["opponents"][0]["opponent"]["id"]
    opp_b_id = raw["opponents"][1]["opponent"]["id"]
    score_a = 0
    score_b = 0
    
    for s in raw["results"]:
        if s["team_id"] == opp_a_id :
            score_a = s["score"]
        elif s["team_id"] == opp_b_id :
            score_b = s["score"]

    url = None # None = null
    
    for u in raw["streams_list"]:
        if u["main"] == True:
            url =  u["raw_url"]        
        
    return {
        "pandascore_id": raw["id"],
        "begin_at": raw["begin_at"],
        "tournament_id": tournament_id,
        "game_id": game_id,
        "team_a_id": team_a_id,
        "team_b_id": team_b_id,
        "score_a": score_a,
        "score_b": score_b,
        "status": status,
        "stream_url" : url
        # "game_id" : raw["videogame"]["name"],
    }


# if __name__ == "__main__":
#     fake_raw = {"id": 123, "begin_at": "2026-09-02T15:00:00Z"}
#     print(mapMatch(fake_raw))
