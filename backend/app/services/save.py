from sqlalchemy.orm import Session
from app.models.game import Game, Tournament, Team
from app.models.match import Match
from app.services.map import mapMatch


# หา game_id ของ Pandascore
# game.id , game.name , game.slug, game.pandascore_slug , game.logo_url , game.created_at
def getGameId(db: Session, raw: dict):
    game_slug = raw["videogame"]["slug"]
    game = db.query(Game).filter(Game.pandascore_slug == game_slug).first()

    return game.id


def getTourId(db: Session, raw: dict, game_id):
    tour_panda_id = raw["league"]["id"]
    tour = (
        db.query(Tournament).filter(Tournament.pandascore_id == tour_panda_id).first()
    )

    if tour is None:
        tour_data = Tournament(
            game_id=game_id, name=raw["league"]["slug"], pandascore_id=tour_panda_id
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
        db.add(match_data)
        db.commit()
        match_panda = match_data
        # print(f"saveMatch : {match_panda}")

    elif match_data["status"] == "finished":
        match_panda.score_a = match_data["score_a"]
        match_panda.score_b = match_data["score_b"]
        match_panda.status = match_data["status"]
        match_panda.winner_team_id = match_data["winner_team_id"]

        db.commit()

        # print(f"{match_panda}")

    return match_panda.id


if __name__ == "__main__":
    from app.db import SessionLocal
    from app.services.pandascore import getPandaAPI

    db = SessionLocal()

    for status in ["upcoming", "running", "past"]:
        matches = getPandaAPI("valorant", status)
        # print(matches)
        for raw in matches:
            match_id = saveMatch(db, raw)
            # print("Saved match:", match_id)
