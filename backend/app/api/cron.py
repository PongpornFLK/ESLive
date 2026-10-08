# app/api/cron.py
import logging
from fastapi import APIRouter, BackgroundTasks, Header, HTTPException
from app.core.config import settings
from app.services.sync_run import STEPS, runSteps

router = APIRouter()
log = logging.getLogger("cron")

def _runInBackground(names: list[str]) -> None:
    """ตัวที่ทำงานจริงหลังตอบ request ไปแล้ว ผลไปโผล่ที่ Logs ของ Render"""
    global _running
    work_hard = set(names) != {"notify"} # false

    # ให้ส่วนอื่นทำงานผ่านได้ตอนที่ notify กำลังทำงาน 
    # ถ้า noti มันไม่หนักเกินไป แล้วในขณะที่ตัวอื่นทำงานอยุ่จะไม่ให้มันมาชนกัน
    if work_hard : 
        _running = True
    
    try:
        for r in runSteps(names):
            log.warning(
                "[%s] %-9s %6.1fs  %s",
                "OK" if r["ok"] else "FAIL",
                r["step"],
                r["seconds"],
                r["detail"],
            )
    finally:
        if work_hard:
            _running = False


@router.post("/internal/cron")
def runCron(
    tasks: BackgroundTasks,
    step: str = "match",  # query param  ?step=match
    x_cron_key: str = Header(None),  # X-Cron-Key
):
    # ด่าน 1
    if not settings.cron_job_key or x_cron_key != settings.cron_job_key:
        raise HTTPException(status_code=401, detail="Unauthorized")

    # ด่าน 2 แปลงเป็น list แล้วเช็คชื่อที่ส่งมีจริง
    names = [s.strip() for s in step.split(",")]
    valid = {s[0] for s in STEPS} | {"all"}
    unknown = [n for n in names if n not in valid]
    if unknown:
        raise HTTPException(
            status_code=400, detail="ไม่รู้จักขั้นตอน: " + ", ".join(unknown)
        )

    # ด่าน 3 รอบก่อนทำงานอยู่
    # notify ไม่ต้องรอ เพราะอ่านคนละตารางกับ sync และต้องยิงทุก 10 นาทีให้ตรงเวลา
    if _running and set(names) != {"notify"}:
        raise HTTPException(status_code=409, detail="sync รอบก่อนยังทำงานอยู่")

    tasks.add_task(_runInBackground, names)

    return {"accepted": names, "note": "กำลังทำงานเบื้องหลัง ดูผลที่ Logs"}
