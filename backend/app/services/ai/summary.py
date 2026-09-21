from app.services.ai.gemini import getGemini
from sqlalchemy.orm import Session
from app.models.match import PatchNote
import uuid
from app.services.ai.prompt_patch import prompt_list_patch

# patch.game.slug = "game_name"


def checkStatus(db: Session, id: uuid.UUID):

    patch = db.query(PatchNote).filter(PatchNote.id == id).first()

    try:
        if patch.status != "ready":
            raw_content = prompt_list_patch[patch.game.slug].format(
                raw_content=patch.raw_content
            )
            patch.ai_summary = getGemini(raw_content)
            patch.status = "ready"
            print(f"{patch.version} {patch.status}-> {patch.status}")
            
    except Exception as e:
        patch.status = "failed"
        print(e)

    db.commit()

    return patch
