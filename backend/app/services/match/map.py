from app.models.match import MatchStatus


def mapMatch(raw: dict, team_a_id, team_b_id, game_id, tournament_id,) -> dict:

    winner_team_id = None
    opp_a_id = raw["opponents"][0]["opponent"]["id"]
    opp_b_id = raw["opponents"][1]["opponent"]["id"]
    score_a = 0
    score_b = 0
    
    if raw["status"] == "not_started":
        status = MatchStatus.upcoming
    elif raw["status"] == "running":
        status = MatchStatus.live
    elif raw["status"] == "finished":
        status = MatchStatus.finished
        if raw["winner"]["id"] == opp_a_id:
            winner_team_id = team_a_id
        else:
            winner_team_id = team_b_id
    else:
        status = MatchStatus.upcoming


    for s in raw["results"]:
        if s["team_id"] == opp_a_id:
            score_a = s["score"]
        elif s["team_id"] == opp_b_id:
            score_b = s["score"]

    url = ""  # None = null

    for u in raw["streams_list"]:
        if u["main"] == True:
            url = u["raw_url"]

    return {
        "pandascore_id": raw["id"],
        "begin_at": raw["begin_at"] or raw["scheduled_at"],
        "tournament_id": tournament_id,
        "game_id": game_id,
        "team_a_id": team_a_id,
        "team_b_id": team_b_id,
        "score_a": score_a,
        "score_b": score_b,
        "status": status,
        "stream_url": url,
        "winner_team_id": winner_team_id,
        # "game_id" : raw["videogame"]["name"],
    }