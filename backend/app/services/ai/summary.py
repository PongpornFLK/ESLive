from app.services.ai.gemini import getGemini
from sqlalchemy.orm import Session
from app.models.match import PatchNote
import uuid
from app.services.ai.prompt import prompt_list

# patch.game.slug = "game_name"


def checkStatus(db: Session, id: uuid.UUID):

    patch = db.query(PatchNote).filter(PatchNote.id == id).first()

    try:
        if patch.status != "ready":
            raw_content = prompt_list[patch.game.slug].format(
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


if __name__ == "__main__":
    from app.db import SessionLocal

    db = SessionLocal()

    patch_list = db.query(PatchNote).filter(PatchNote.status != "ready").all()

    print(f"Found {len(patch_list)} patch note(s) to summarize")

    for patch in patch_list:
        result = checkStatus(db, patch.id)
        print(f"  {result.version:<8} -> {result.status}")
