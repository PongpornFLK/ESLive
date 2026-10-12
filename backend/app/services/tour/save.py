from sqlalchemy.orm import Session
from app.models.game import Tournament
from app.services.tour.map import mapTour
from app.services.match.save import getGameId


def saveTour(db: Session, raw: dict):    
    tour = db.query(Tournament).filter(Tournament.pandascore_id == raw["id"]).first()
    game_id = getGameId(db,raw)
    tour_data = mapTour(game_id,raw)
    
    if tour is None:
        tour_data = Tournament(**tour_data)
        db.add(tour_data)
        db.commit()
        tour = tour_data
    else:
        tour.name = tour_data["name"]
        tour.serie_id = tour_data["serie_id"]
        tour.serie_name = tour_data["serie_name"]
        tour.game_id= tour_data["game_id"]
        tour.has_bracket = tour_data["has_bracket"]
        tour.prizepool = tour_data["prizepool"]
        tour.begin_at = tour_data["begin_at"]
        tour.end_at = tour_data["end_at"]
        tour.league_name = tour_data["league_name"]
        tour.league_logo_url = tour_data["league_logo_url"]
        tour.type = tour_data["type"]
        tour.team_count = tour_data["team_count"]

        db.commit()
        
    return tour.id
