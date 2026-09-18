from sqlalchemy.orm import Session
from app.models.game import Tournament
from app.services.tour.map import mapTour
from app.services.match.save import getGameId
from app.services.tour.pandascore import getPandaListTour


def saveTour(db: Session, raw: dict):    
    tour = db.query(Tournament).filter(Tournament.pandascore_id == raw["id"]).first()
    
    if tour is None:
        game_id = getGameId(db,raw)
        tour_data = mapTour(game_id,raw)
        tour_data = Tournament(**tour_data)
        db.add(tour_data)
        db.commit()
        tour = tour_data
    else:
        print("Duplicated")

    return tour.id
