from sqlalchemy.orm import Session
from app.models.game import Game, Tournament, Team
from app.models.match import Match
from app.services.match.map import mapMatch
from app.services.match.pandascore import getPandaTourForMatch


# หา game_id ของ Pandascore
# game.id , game.name , game.slug, game.pandascore_slug , game.logo_url , game.created_at
def getGameId(db: Session, raw: dict):
    game_slug = raw["videogame"]["slug"]
    game = db.query(Game).filter(Game.pandascore_slug == game_slug).first()

    return game.id


def getTourId(db: Session, raw: dict, game_id):
    tour_panda_id = raw["tournament"]["id"]
    tour = (
        db.query(Tournament).filter(Tournament.pandascore_id == tour_panda_id).first()
    )

    if tour is None:
        tournament_detail = getPandaTourForMatch(raw["tournament"]["id"])

        tour_data = Tournament(
            game_id=game_id,
            name=raw["tournament"]["slug"],
            pandascore_id=tour_panda_id,
            league_name=raw["league"]["name"],
            league_logo_url=raw["league"]["image_url"],
            region=raw["tournament"]["region"],
            type=raw["tournament"]["type"],
            team_count=len(tournament_detail["teams"]),
            has_bracket=raw["tournament"]["has_bracket"],
            prizepool=raw["tournament"]["prizepool"],
            begin_at=raw["tournament"]["begin_at"],
            end_at=raw["tournament"]["end_at"],
        )
        db.add(tour_data)
        db.commit()

        tour = tour_data

        print("Save Tour")
    else:
        print("Duplicate")

    return tour.id


def getTeamId(db: Session, raw: dict, game_id):
    team_id = db.query(Team).filter(Team.pandascore_id == raw["id"]).first()

    if team_id is None:
        team_data = Team(
            game_id=game_id,
            name=raw["name"],
            pandascore_id=raw["id"],
            logo_url=raw["image_url"],
        )
        print("Save Team")
        db.add(team_data)
        db.commit()
        team_id = team_data
    else:
        print("Duplicated")

    return team_id.id


def saveMatch(db: Session, raw: dict):

    if len(raw["opponents"]) < 2:
        return None

    game_id = getGameId(db, raw)
    tour_id = getTourId(db, raw, game_id)
    team_a_id = getTeamId(db, raw["opponents"][0]["opponent"], game_id)
    team_b_id = getTeamId(db, raw["opponents"][1]["opponent"], game_id)

    match_data = mapMatch(raw, team_a_id, team_b_id, game_id, tour_id)

    print(f"match_data : {match_data}")

    match_panda = (
        db.query(Match).filter(Match.pandascore_id == match_data["pandascore_id"])
    ).first()

    if match_panda is None:
        match_data = Match(**match_data)
        db.add(match_data)  # save match
        db.commit()
        match_panda = match_data

        # print(f"saveMatch : {match_panda}")

    elif match_data["status"] == "finished" or match_data["status"] == "live":
        match_panda.score_a = match_data["score_a"]
        match_panda.score_b = match_data["score_b"]
        match_panda.status = match_data["status"]
        match_panda.winner_team_id = match_data["winner_team_id"]

        db.commit()
        # print(f"{match_panda}")
    else:
        match_panda.status = match_data["status"]
        db.commit()

    return match_panda.id
