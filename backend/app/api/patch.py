from typing import List
import uuid
from fastapi import APIRouter, Depends, HTTPException
from app.schemas.match import PatchDetailOut, PatchNoteOut
from app.db import get_db
from sqlalchemy.orm import Session
from app.models.match import PatchNote
from sqlalchemy import desc

router = APIRouter()


@router.get("/patch", response_model=List[PatchNoteOut])
def readPatch(db: Session = Depends(get_db)):

    patch_list = db.query(PatchNote).order_by(desc(PatchNote.published_at)).all()

    return patch_list

# patch raw_content by ID only
@router.get("/patch/{patch_id}" , response_model=PatchDetailOut)
def readPatchDetail(patch_id : uuid.UUID , db : Session = Depends(get_db)):
    
    patch = db.query(PatchNote).filter(PatchNote.id == patch_id).first()
    
    if patch is None:
        raise HTTPException(status_code=404,detail="Not Found")
    
    return patch