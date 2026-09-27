"""สั่งงาน sync จาก terminal

วิธีใช้ (ต้องยืนอยู่ในโฟลเดอร์ backend เสมอ เพราะ .env ถูกอ่านจากตรงนี้)

    python sync.py              รัน tour -> match -> patch
    python sync.py tour         รันเฉพาะ tour
    python sync.py tour match   รันเฉพาะที่ระบุ ตามลำดับที่กำหนดไว้
    python sync.py all          รันทุกอย่าง รวม summary ที่ใช้โควต้า Gemini

ไฟล์นี้ทำแค่ 2 อย่าง แปลง argv แล้ว print ผล
ตัวงานจริงอยู่ที่ app/services/sync_run.py เพื่อให้ทางเข้าอื่น (เช่น endpoint
ที่ cron ยิงเข้ามา) เรียกฟังก์ชันเดียวกันได้ โดยไม่ต้องพึ่ง argv หรือ stdout
"""

import sys

from app.services.sync_run import STEPS, runSteps


def main(argv):
    try:
        results = runSteps(argv[1:])
    except ValueError as e:
        # runSteps โยนมาเมื่อเจอชื่อขั้นตอนที่ไม่รู้จัก
        print(e)
        print("ที่มีให้เลือก:", ", ".join(s[0] for s in STEPS), "หรือ all")
        return 1

    print("\n===== สรุป =====")
    for r in results:
        mark = "OK  " if r["ok"] else "FAIL"
        print(f"  [{mark}] {r['step']:<9} {r['seconds']:6.1f}s  {r['detail']}")

    return 1 if any(not r["ok"] for r in results) else 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
