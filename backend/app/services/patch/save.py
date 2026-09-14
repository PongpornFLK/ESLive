from sqlalchemy.orm import Session
from app.services.patch.riot_patch import getPatchGameURL, getPatchRiot
from app.models.game import Game
from app.services.patch.map import mapPatch
from app.models.match import PatchNote
from sqlalchemy import and_


def getGamePatchId(db: Session, game: str):
    list_game_patch = {"val": "valorant"}

    patch_game = db.query(Game).filter(Game.slug == list_game_patch[game]).first()

    return patch_game.id


def savePatch(db: Session, raw: dict, game_id):
    patch_list = mapPatch(raw, game_id)
    
    if patch_list is None:
        return "Error"

    patch_data = (
        db.query(PatchNote)
        .filter(
            and_(
                PatchNote.game_id == patch_list["game_id"],
                PatchNote.version == patch_list["version"],
            )
        )
        .first()
    )

    if patch_data is None:
        patch_list["raw_content"] = getPatchGameURL(patch_list["raw_source_url"])
        patch_data = PatchNote(**patch_list)
        db.add(patch_data)
        db.commit()
    else:
        print("Duplicated")

    return patch_data


if __name__ == "__main__":
    from app.db import SessionLocal

    db = SessionLocal()

    game_id = getGamePatchId(db, "val")
    patch_news = getPatchRiot("val", "en-us")

    for raw in patch_news:
        savePatch(db, raw, game_id)
