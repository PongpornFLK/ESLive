from typing import List
from fastapi import APIRouter, Depends
from app.schemas.match import PatchNoteOut
from app.db import get_db
from sqlalchemy.orm import Session
from app.models.match import PatchNote

router = APIRouter()

@router.get('/patch' , response_model=List[PatchNoteOut] )
def readPatch(db : Session = Depends(get_db)):
    
    patch_list = db.query(PatchNote).all()
    
    return patch_list