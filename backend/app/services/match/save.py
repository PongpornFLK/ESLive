from sqlalchemy.orm import Session
from app.models.game import Game, Tournament, Team
from app.models.match import Match
from app.services.match.map import mapMatch
from app.services.match.pandascore import getPandaTourForMatch
import logging
from app.services.tour.map import mapTour

log = logging.getLogger("sync")

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

        tour_data = mapTour(game_id, tournament_detail)
        tour_data = Tournament(**tour_data)
        db.add(tour_data)
        db.commit()

        tour = tour_data

        log.debug("Save Tour")
    else:
        log.debug("Duplicate")

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
        log.debug("Save Team")
        db.add(team_data)
        db.commit()
        team_id = team_data
    else:
        log.debug("Duplicated")

    return team_id.id


def saveMatch(db: Session, raw: dict):

    if len(raw["opponents"]) < 2:
        return None

    game_id = getGameId(db, raw)
    tour_id = getTourId(db, raw, game_id)
    team_a_id = getTeamId(db, raw["opponents"][0]["opponent"], game_id)
    team_b_id = getTeamId(db, raw["opponents"][1]["opponent"], game_id)

    match_data = mapMatch(raw, team_a_id, team_b_id, game_id, tour_id)

    log.debug("match_data : %s", match_data)

    match_panda = (
        db.query(Match).filter(Match.pandascore_id == match_data["pandascore_id"])
    ).first()

    if match_panda is None:
        match_data = Match(**match_data)
        db.add(match_data)  # save match
        db.commit()
        match_panda = match_data

    else:
        match_panda.status = match_data["status"]
        match_panda.score_a = match_data["score_a"]
        match_panda.score_b = match_data["score_b"]
        match_panda.winner_team_id = match_data["winner_team_id"]
        match_panda.begin_at = match_data["begin_at"]
        match_panda.stream_url = match_data["stream_url"]

        db.commit()

    return match_panda.id
