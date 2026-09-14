from typing import List
from fastapi import APIRouter, Depends
from app.schemas.match import PatchNoteOut
from app.db import get_db
from sqlalchemy.orm import Session
from app.models.match import PatchNote
from sqlalchemy import desc

router = APIRouter()


@router.get("/patch", response_model=List[PatchNoteOut])
def readPatch(db: Session = Depends(get_db)):

    patch_list = db.query(PatchNote).order_by(desc(PatchNote.published_at)).all()

    return patch_list
