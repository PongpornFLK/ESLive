def mapBracket(raw: dict) -> dict:
    match_id = raw["id"]
    name = raw["name"]
    best_of_game = raw["number_of_games"]
    status = raw["status"]
    begin_at = raw["begin_at"]
    opponents = raw["opponents"]
    from_matches = raw["previous_matches"]
    winner_id = raw["winner_id"]
    score_a = 0
    score_b = 0

    #### Team A
    if len(opponents) > 0:
        opp_a = opponents[0]["opponent"]
        opp_a_id = opp_a["id"]
        team_a_name = opp_a["name"]
    else:
        opp_a = None
        opp_a_id = None
        team_a_name = None

    #### Team B
    if len(opponents) > 1:
        opp_b = opponents[1]["opponent"]
        opp_b_id = opp_b["id"]
        team_b_name = opp_b["name"]
    else:
        opp_b = None
        opp_b_id = None
        team_b_name = None

    #### Score
    for s in raw["results"]:
        if s["team_id"] == opp_a_id:
            score_a = s["score"]
        if s["team_id"] == opp_b_id:
            score_b = s["score"]

    #### Winner Team
    if winner_id == opp_a_id:
        winner_team = team_a_name
    elif winner_id == opp_b_id:
        winner_team = team_b_name
    else:
        winner_team = None

    return {
        "match_id": match_id,
        "name": name,
        "best_of_game": best_of_game,
        "status": status,
        "begin_at": begin_at,
        "team_a_name": team_a_name,
        "team_b_name": team_b_name,
        "score_a": score_a,
        "score_b": score_b,
        "winner_team": winner_team,
        "from_matches": from_matches,
    }


def mapGroupStanding(raw: dict) -> dict:
    rank = raw["rank"]
    team_name = raw["team"]["name"]
    team_logo = raw["team"]["image_url"]
    matches_played = raw["total"]
    win = raw["wins"]
    loss = raw["losses"]
    game_wins = raw["game_wins"]
    game_losses = raw["game_losses"]
    game_ties = raw["game_ties"]

    return {
        "rank": rank,
        "team_name": team_name,
        "team_logo": team_logo,
        "matches_played": matches_played,
        "wins": win,
        "losses": loss,
        "game_wins": game_wins,
        "game_losses": game_losses,
        "game_ties": game_ties,
    }
