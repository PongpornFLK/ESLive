# ES-Live

แอปติดตามการแข่งขันอีสปอร์ตแบบเรียลไทม์ พร้อมบทวิเคราะห์จาก AI

ดึงข้อมูลแมตช์และทัวร์นาเมนต์จาก PandaScore ดูดแพตช์โน้ตจากเว็บผู้พัฒนาเกม
ให้ Gemini สรุปและวิเคราะห์เป็นสองภาษา แล้วส่งแจ้งเตือนก่อนแมตช์ของทีมที่ผู้ใช้ติดตามเริ่มแข่ง

ณ ตอนนี้รองรับแค่เกม Valorant เป็นหลัก (เกมเดียวแต่ยังมีแนวคิดจะเพิ่มเกม)

---

## สารบัญ

- [ภาพรวม](#ภาพรวม)
- [เทคโนโลยีที่ใช้](#เทคโนโลยีที่ใช้)
- [โครงสร้างโปรเจกต์](#โครงสร้างโปรเจกต์)
- [เริ่มต้นใช้งาน](#เริ่มต้นใช้งาน)
- [ตัวแปรสภาพแวดล้อม](#ตัวแปรสภาพแวดล้อม)
- [API](#api)
- [งานตามเวลา](#งานตามเวลา)
- [การ deploy](#การ-deploy)

---

## ภาพรวม

```
PandaScore ──┐
             ├──> FastAPI ──> PostgreSQL (Supabase) ──> Flutter
เว็บแพตช์โน้ต ─┘      │                                      ▲
                     ├──> Gemini  สรุป/วิเคราะห์             │
                     └──> Firebase Cloud Messaging ─────────┘
                              แจ้งเตือนก่อนแมตช์เริ่ม

cron-job.org ──> POST /internal/cron   ปลุกให้ดึงข้อมูลตามเวลา
```

รายละเอียดว่าแต่ละส่วนคุยกันยังไง อ่านที่ [docs/architecture.md](docs/architecture.md)

---

## เทคโนโลยีที่ใช้

| ส่วน | ใช้อะไร |
|---|---|
| แอป | Flutter 3.29 · Riverpod 3 · Dio · flutter_localizations (ARB) |
| เซิร์ฟเวอร์ | Python 3.11 · FastAPI · SQLAlchemy 2 · Pydantic v2 |
| ฐานข้อมูล | PostgreSQL ผ่าน Supabase |
| ยืนยันตัวตน | Supabase Auth (อีเมล + รหัสผ่าน) |
| AI | Google Gemini |
| แจ้งเตือน | Firebase Cloud Messaging |
| แหล่งข้อมูล | PandaScore API · เว็บแพตช์โน้ตของผู้พัฒนาเกม |
| โฮสต์ | Render (Free-Tire) |
| งานตามเวลา | cron-job.org |

---

## โครงสร้างโปรเจกต์

```
backend/                 FastAPI  40 ไฟล์ · ~2,000 บรรทัด
  app/
    api/                 endpoint แต่ละกลุ่ม
    core/                config · auth
    models/              ตาราง SQLAlchemy
    schemas/             Pydantic ขาเข้า/ขาออก
    services/            ตรรกะจริงทั้งหมด
      ai/                prompt + เรียก Gemini
      match/ tour/ patch/  ดึงและบันทึกข้อมูลภายนอก
      noti/              หาคนที่ควรได้รับ + ส่ง
      sync_run.py        รวมทุกขั้นตอนไว้ที่เดียว
  sync.py                ทางเข้าจาก terminal

es_live/                 Flutter  90 ไฟล์ · ~7,400 บรรทัด
  lib/
    _service/            เรียก API + Riverpod provider
    core/                model · theme · config · i18n
    auth/ homelive/ tour/ follow/ patch/ noti/ set/   หน้าจอแต่ละกลุ่ม
    widgets/             widget ที่ใช้ร่วมกันหลายหน้า
    l10n/                ไฟล์ .arb ทั้งสองภาษา
```

---

## เริ่มต้นใช้งาน

### เซิร์ฟเวอร์

```bash
cd backend
python -m venv venv
venv\Scripts\activate          # macOS/Linux: source venv/bin/activate
pip install -r requirements.txt

# สร้าง .env ตามหัวข้อถัดไป แล้วสั่ง
venv\Scripts\python.exe -m uvicorn app.main:app --reload
```

เปิด `http://127.0.0.1:8000/docs` จะเห็น endpoint ทั้งหมด

### แอป

```bash
cd es_live
flutter pub get
flutter run
```

ต้องใช้ **Android emulator ที่มี Google Play Services** เพราะการแจ้งเตือนใช้ FCM
Windows desktop และ web ยังไม่รองรับส่วนนี้

ถ้าจะต่อกับเซิร์ฟเวอร์ในเครื่อง เปลี่ยน `baseUrl` ใน `lib/core/config/dio_config.dart`
เป็น `http://10.0.2.2:8000` (`10.0.2.2` คือเลขที่ emulator ใช้เรียกเครื่องคอมที่รันมันอยู่)

### ดึงข้อมูลเข้าฐานข้อมูลครั้งแรก

```bash
cd backend
python sync.py            # tour -> match -> patch
python sync.py all        # ทุกขั้น รวมที่ใช้โควต้า Gemini
python sync.py match      # เฉพาะขั้นที่ระบุ
```

---

## ตัวแปรสภาพแวดล้อม - env

สร้างไฟล์ `backend/.env` (ถูก gitignore ไว้แล้ว)

| ชื่อ | ใช้ทำอะไร |
|---|---|
| `DATABASE_URL` | สตริงเชื่อมต่อ PostgreSQL ของ Supabase |
| `SUPABASE_URL` | โปรเจกต์ Supabase สำหรับตรวจ token |
| `SUPABASE_KEY` | **service_role key — ห้ามใส่ในแอป Flutter เด็ดขาด** |
| `PANDASCORE_API_KEY` | ดึงแมตช์และทัวร์นาเมนต์ |
| `GEMINI_API_KEY` | สรุปแพตช์และวิเคราะห์แมตช์ |
| `FIREBASE_CREDENTIALS` | เนื้อไฟล์ Service Account ทั้งก้อน ย่อเหลือบรรทัดเดียว |
| `FIREBASE_PROJECT_ID` | โปรเจกต์ Firebase |
| `CRON_JOB_KEY` | กันไม่ให้คนนอกยิง `/internal/cron` |

ย่อ Service Account เป็นบรรทัดเดียว

```bash
python -c "import json;print(json.dumps(json.load(open('serviceAccount.json'))),end='')"
```

แล้ววางใน `.env` โดยครอบด้วยเครื่องหมายคำพูดเดี่ยว ส่วนบน Render วางค่าดิบไม่ต้องครอบ

ฝั่งแอปใช้ **anon key** เท่านั้น ตั้งไว้ที่ `lib/core/config/supabase_config.dart`

---

## API

| method | path | ต้องล็อกอิน | ทำอะไร |
|---|---|---|---|
| `GET` | `/health` | — | เช็คว่าเซิร์ฟเวอร์ตื่นอยู่ |
| `GET` | `/matchcoming` | — | แมตช์ที่กำลังแข่งและกำลังจะแข่ง พร้อมผลวิเคราะห์ |
| `GET` | `/match/history/{match_id}` | — | ผลการเจอกันที่ผ่านมาของสองทีม |
| `GET` | `/tournament` | — | รายการทัวร์นาเมนต์ |
| `GET` | `/tournament/bracket/{id}` | — | สายการแข่ง |
| `GET` | `/tournament/standing/{id}` | — | ตารางคะแนนรอบแบ่งกลุ่ม |
| `GET` | `/patch` | — | แพตช์โน้ตพร้อมบทสรุปจาก AI สองภาษา |
| `GET` | `/user` | ✅ | ค่าตั้งค่าของผู้ใช้ |
| `PATCH` | `/user` | ✅ | แก้ค่าตั้งค่า ส่งเฉพาะช่องที่จะแก้ |
| `GET` `POST` | `/user/follow` | ✅ | ทีมที่ติดตาม |
| `DELETE` | `/user/follow/{team_id}` | ✅ | เลิกติดตาม |
| `POST` | `/user/device` | ✅ | ลงทะเบียนเครื่องสำหรับรับแจ้งเตือน |
| `DELETE` | `/user/device/{token}` | ✅ | ถอนเครื่องออก |
| `POST` | `/internal/cron` | 🔑 คีย์ | ทางเข้าให้ cron สั่งดึงข้อมูล |

ที่มี ✅ ต้องแนบ `Authorization: Bearer <supabase access token>`
ส่วน `/internal/cron` ใช้ header `X-Cron-Key`

---

## งานตามเวลา

ตั้งไว้ที่ cron-job.org ทั้งหมด ยิงเข้ามาที่เซิร์ฟเวอร์

| # | ยิงอะไร | ตาราง | ทำไม |
|---|---|---|---|
| 1 | `GET /health` | ทุก 5 นาที | กัน Render แพ็กฟรีหลับ **ถ้าไม่มีตัวนี้อีก 4 ตัวพังหมด** |
| 2 | `?step=match` | ทุก 30 นาที | สกอร์ · สถานะไลฟ์ · ทีมใหม่ |
| 3 | `?step=all` | 04:45 | ตาข่ายนิรภัยรายวัน มี `tour` ที่ไม่มีใครทำให้ |
| 4 | `?step=patch,summary,analysis` | ทุก 6 ชม. นาทีที่ 15 | แพตช์ใหม่ + งาน AI |
| 5 | `?step=notify` | ทุก 10 นาที | ส่งแจ้งเตือนก่อนแมตช์เริ่ม |

**ต้องหลบเวลากัน** เพราะ `match` กินเวลาราว 131 วินาที ถ้ายิงชนกันตัวที่มาทีหลังจะได้ `409`
ยกเว้น `notify` ที่ออกแบบให้วิ่งพร้อมกันได้

Render แพ็กฟรีให้ 750 ชั่วโมงต่อเดือน ส่วน 24/7 ใช้ 744 ชั่วโมง — เหลือไม่มาก

---

## การ deploy

เซิร์ฟเวอร์อยู่บน Render (สิงคโปร์ เพราะฐานข้อมูล Supabase อยู่โตเกียว)
push ขึ้น `main` แล้ว Render build ให้เอง อ่าน `backend/requirements.txt`

ตัวแปรสภาพแวดล้อมตั้งที่ Render → Environment ไม่ได้อ่านจาก `.env` ในเครื่อง

⚠️ **`uvicorn --reload` ไม่อ่าน `.env` ใหม่** แก้ค่าแล้วต้องปิดเปิดเอง

---

## คำสั่งที่ใช้บ่อย

```bash
# backend
python sync.py match                  ดึงข้อมูลเฉพาะแมตช์
venv\Scripts\python.exe -m uvicorn app.main:app --reload

# flutter
flutter analyze                       ตรวจ lint และชนิดข้อมูล
flutter build bundle                  ยืนยันว่าคอมไพล์ผ่านจริง เร็วกว่า flutter run มาก
flutter gen-l10n                      สร้างไฟล์ภาษาใหม่หลังแก้ .arb
dart format lib/                      จัดรูปแบบโค้ด
```

> `flutter analyze` ผ่านไม่ได้แปลว่ารันได้ — analyzer กับคอมไพเลอร์เข้มไม่เท่ากัน
> แก้อะไรที่เกี่ยวกับชนิดข้อมูลหรือ generic ให้ยืนยันด้วย `flutter build bundle`
