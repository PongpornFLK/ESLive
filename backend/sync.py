"""รวมงาน sync ทุกอย่างไว้ที่เดียว

วิธีใช้ (ต้องยืนอยู่ในโฟลเดอร์ backend เสมอ เพราะ .env ถูกอ่านจากตรงนี้)

    python sync.py              รัน tour -> match -> patch
    python sync.py tour         รันเฉพาะ tour
    python sync.py tour match   รันเฉพาะที่ระบุ ตามลำดับที่กำหนดไว้
    python sync.py all          รันทุกอย่าง รวม summary ที่ใช้โควต้า Gemini

ไฟล์นี้วางไว้ในโฟลเดอร์ backend เพื่อให้ import app.* ได้โดยไม่ต้องตั้ง PYTHONPATH
"""

import sys
import time

from app.db import SessionLocal

# แต่ละขั้น import ของตัวเองข้างในฟังก์ชัน ไม่ import ไว้ข้างบนไฟล์
# เพราะถ้าแพ็กเกจของขั้นใดขั้นหนึ่งมีปัญหา (เช่น google-genai ยังไม่ได้ลง)
# จะล้มทั้งไฟล์ตั้งแต่ยังไม่เริ่มทำงาน ทั้งที่ขั้นอื่นไม่เกี่ยวอะไรด้วย

GAME_SLUGS = ["valorant", "pubg"]
MATCH_STATUSES = ["upcoming", "running", "past"]


def syncTour(db):
    """ดึงรายชื่อทัวร์ทั้งหมดของแต่ละเกม แล้วบันทึกอันที่ยังไม่มี

    ต้องรันก่อน syncMatch เสมอ เพราะ getTourId ใน saveMatch จะได้เจอของเดิม
    ไม่ต้องยิง API หารายละเอียดทัวร์ทีละอัน
    """
    from app.services.tour.pandascore import getPandaListTour
    from app.services.tour.save import saveTour

    total = 0
    for slug in GAME_SLUGS:
        tours = getPandaListTour(slug)
        print(f"  {slug:<10} ได้ {len(tours)} ทัวร์")
        for raw in tours:
            saveTour(db, raw)
        total += len(tours)
    return f"ตรวจ {total} ทัวร์"


def syncMatch(db):
    """ดึงแมตช์ของ valorant ทั้ง 3 สถานะ แล้วบันทึก พร้อมทีมที่ยังไม่มี"""
    from app.services.match.pandascore import getPandaMatch
    from app.services.match.save import saveMatch

    total = skipped = 0
    for status in MATCH_STATUSES:
        matches = getPandaMatch("valorant", status)
        print(f"  {status:<10} ได้ {len(matches)} แมตช์")
        for raw in matches:
            # saveMatch คืน None เมื่อข้ามแมตช์ที่ยังประกาศคู่ไม่ครบ 2 ทีม
            if saveMatch(db, raw) is None:
                skipped += 1
            else:
                total += 1
    return f"บันทึก {total} แมตช์ ข้าม {skipped} (ยังไม่มีคู่แข่ง)"


def syncPatch(db):
    """ดูดหน้า patch note ของ valorant จากเว็บ Riot แล้วบันทึกอันที่ยังไม่มี"""
    from app.services.patch.riot_patch import getPatchRiot
    from app.services.patch.save import getGamePatchId, savePatch

    game_id = getGamePatchId(db, "val")
    patch_news = getPatchRiot("val", "en-us")
    print(f"  เจอ {len(patch_news)} หน้า")
    for raw in patch_news:
        savePatch(db, raw, game_id)
    return f"ตรวจ {len(patch_news)} หน้า"


def syncSummary(db):
    """ส่ง patch ที่ยังไม่ ready เข้า Gemini เพื่อสรุป

    ขั้นนี้ใช้โควต้า Gemini จริง เลยไม่รวมอยู่ในการรันแบบปกติ
    ต้องสั่ง python sync.py summary หรือ python sync.py all เท่านั้น
    """
    from app.models.match import PatchNote
    from app.services.ai.summary import checkStatus

    patch_list = db.query(PatchNote).filter(PatchNote.status != "ready").all()
    print(f"  มี {len(patch_list)} patch ที่ยังไม่ได้สรุป")
    for patch in patch_list:
        result = checkStatus(db, patch.id)
        print(f"    {result.version:<8} -> {result.status}")
    return f"สรุป {len(patch_list)} patch"


def syncAnalysis(db):
    """สร้างแถว match_analysis ที่ยังไม่มี แล้วส่งแมตช์ที่ยังไม่ ready เข้า Gemini

    ขั้นนี้ใช้โควต้า Gemini จริง เลยไม่รวมอยู่ในการรันแบบปกติ
    ต้องสั่ง python sync.py analysis หรือ python sync.py all เท่านั้น
    """
    from app.models.match import Match, MatchAnalysis
    from app.services.ai.match_analyze import checkStatus

    # เติมแถวให้แมตช์ที่ยังไม่มี ทั้งของเก่าและที่เพิ่ง sync เข้ามา
    done = {r[0] for r in db.query(MatchAnalysis.match_id).all()}
    new = 0
    for (match_id,) in db.query(Match.id).all():
        if match_id not in done:
            db.add(MatchAnalysis(match_id=match_id))
            new += 1
    db.commit()
    print(f"  สร้างแถวใหม่ {new} แถว")

    # วิเคราะห์เฉพาะแมตช์ที่ยังไม่แข่ง แมตช์ที่จบแล้วรู้ผลอยู่แล้ว
    # ไม่มีใครอ่านคำทำนาย และเปลืองโควต้า Gemini ฟรี ๆ
    todo = (
        db.query(MatchAnalysis)
        .join(Match, Match.id == MatchAnalysis.match_id)
        .filter(MatchAnalysis.status != "ready", Match.status != "finished")
        .all()
    )
    print(f"  มี {len(todo)} แมตช์ที่ยังไม่ได้วิเคราะห์")
    for a in todo:
        result = checkStatus(db, a.match_id)
        print(f"    {str(a.match_id)[:8]} -> {result.status}")
    return f"วิเคราะห์ {len(todo)} แมตช์ สร้างแถวใหม่ {new}"


# ลำดับสำคัญ : tour ต้องมาก่อน match / patch ต้องมาก่อน summary
STEPS = [
    ("tour", syncTour),
    ("match", syncMatch),
    ("patch", syncPatch),
    ("summary", syncSummary),
    ("analysis", syncAnalysis),
]

# ขั้นที่ใช้เงิน/โควต้า ไม่รันให้เองถ้าไม่สั่งชื่อมาตรง ๆ
COSTLY = {"summary", "analysis"}


def main(argv):
    names = [a.lower() for a in argv[1:]]

    if not names:
        chosen = [s for s in STEPS if s[0] not in COSTLY]
    elif "all" in names:
        chosen = STEPS
    else:
        unknown = [n for n in names if n not in {s[0] for s in STEPS}]
        if unknown:
            print("ไม่รู้จักขั้นตอน:", ", ".join(unknown))
            print("ที่มีให้เลือก:", ", ".join(s[0] for s in STEPS), "หรือ all")
            return 1
        chosen = [s for s in STEPS if s[0] in names]

    db = SessionLocal()
    results = []
    failed = 0

    try:
        for name, fn in chosen:
            print(f"\n===== {name} =====")
            start = time.time()
            try:
                summary = fn(db)
                results.append((name, "OK", summary, time.time() - start))
            except Exception as e:
                db.rollback()
                failed += 1
                results.append(
                    (name, "FAIL", f"{type(e).__name__}: {e}", time.time() - start)
                )
                print(f"  พัง: {type(e).__name__}: {e}")
    finally:
        db.close()

    print("\n===== สรุป =====")
    for name, state, detail, secs in results:
        mark = "OK  " if state == "OK" else "FAIL"
        print(f"  [{mark}] {name:<9} {secs:6.1f}s  {detail}")

    return 1 if failed else 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
