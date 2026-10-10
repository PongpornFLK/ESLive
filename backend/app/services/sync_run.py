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

    # วิเคราะห์เฉพาะแมตช์ที่ยังไม่แข่ง กับ ถูกยกเลิก
    todo = (
        db.query(MatchAnalysis)
        .join(Match, Match.id == MatchAnalysis.match_id)
        .filter(
            MatchAnalysis.status != "ready",
            Match.status.notin_(["finished", "canceled"]),
        )
        .all()
    )

    print(f"  มี {len(todo)} แมตช์ที่ยังไม่ได้วิเคราะห์")
    for a in todo:
        result = checkStatus(db, a.match_id)
        print(f"    {str(a.match_id)[:8]} -> {result.status}")
    return f"วิเคราะห์ {len(todo)} แมตช์ สร้างแถวใหม่ {new}"


def syncNotify(db):
    """หาคนที่ถึงเวลาแล้วส่งแจ้งเตือน จดว่าส่งไปแล้ว และเก็บกวาด token ที่ตาย

    ขั้นนี้ยิง FCM จริง เลยไม่รวมอยู่ในการรันแบบปกติ
    ต้องสั่งชื่อ notify มาตรง ๆ หรือ all เท่านั้น
    """
    from app.models.user import DeviceToken, MatchNotified
    from app.services.noti.find import findDue
    from app.services.noti.push import sendPush

    due = findDue(db)
    print(f"  มี {len(due)} คนที่ถึงเวลาแจ้งเตือน")

    sent = dead = 0
    for item in due:
        for token in item["tokens"]:
            # แนบ match_id
            payload = {"match_id": str(item["match_id"])}
            if sendPush(token, item["title"], item["body"], payload):
                sent += 1
            else:
                # sendPush คืน False เฉพาะตอน token ตายถาวร ลบทิ้งไม่ให้ค้าง
                db.query(DeviceToken).filter(DeviceToken.token == token).delete()
                dead += 1

        # จดไว้ว่าคู่นี้เตือนไปแล้ว รอบหน้า findDue จะข้ามให้เอง
        db.add(MatchNotified(profile_id=item["profile_id"], match_id=item["match_id"]))

    db.commit()
    return f"เตือน {len(due)} คน ส่ง {sent} เครื่อง ลบ token ตาย {dead}"


# ลำดับสำคัญ : tour ต้องมาก่อน match / patch ต้องมาก่อน summary
# notify อยู่ท้ายสุด จะได้อ่านเวลาแมตช์ที่ match เพิ่งอัปเดตมา
STEPS = [
    ("tour", syncTour),
    ("match", syncMatch),
    ("patch", syncPatch),
    ("summary", syncSummary),
    ("analysis", syncAnalysis),
    ("notify", syncNotify),
]

# ขั้นที่ใช้เงิน/โควต้า หรือส่งของออกไปหาผู้ใช้จริง ไม่รันให้เองถ้าไม่สั่งชื่อมาตรง ๆ
COSTLY = {"summary", "analysis", "notify"}

def runSteps(names: list[str]) -> list[dict]:
    """รับชื่อขั้นตอน -> รันตามลำดับใน STEPS -> คืนผลของแต่ละขั้น

    ไม่อ่าน argv ไม่ print ไม่รู้จัก HTTP
    คนเรียกเอาผลไปแสดงเองว่าจะ print ลง terminal หรือเขียน log

        names ว่าง       ทุกขั้นยกเว้น COSTLY
        names มี "all"   ทุกขั้น
        นอกนั้น           เฉพาะชื่อที่ระบุ แต่ลำดับยึดตาม STEPS เสมอ
    """
    names = [n.lower() for n in names]

    if not names:
        chosen = [s for s in STEPS if s[0] not in COSTLY]
    elif "all" in names:
        chosen = STEPS
    else:
        unknown = [n for n in names if n not in {s[0] for s in STEPS}]
        if unknown:
            # โยนให้คนเรียกตัดสินใจเอง CLI จะ print แล้วจบ / endpoint จะตอบ 400
            raise ValueError("ไม่รู้จักขั้นตอน: " + ", ".join(unknown))
        chosen = [s for s in STEPS if s[0] in names]

    # เปิด session เองเพราะทั้ง terminal และ HTTP ไม่มี db อยู่ในมือ
    db = SessionLocal()
    results = []

    try:
        for name, fn in chosen:
            start = time.time()
            try:
                detail = fn(db)
                ok = True
            except Exception as e:
                # ขั้นเดียวพังไม่ควรทำให้ขั้นที่เหลือไม่ได้รัน
                db.rollback()
                detail = f"{type(e).__name__}: {e}"
                ok = False

            results.append(
                {
                    "step": name,
                    "ok": ok,
                    "detail": detail,
                    "seconds": round(time.time() - start, 1),
                }
            )
    finally:
        db.close()

    return results
