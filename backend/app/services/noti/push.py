import json
import firebase_admin
from firebase_admin import credentials, messaging
from app.core.config import settings

# เก็บการเชื่อมต่อที่่ใช้ร่วมกัน
_app = None

# ต่อกับ Firebase
def _init() -> None:
    global _app

    if _app is not None:
        return

    # แปลงเป็นกุญแจที่ Firebase เข้าใจ
    cred = credentials.Certificate(json.loads(settings.firebase_credentials))
    _app = firebase_admin.initialize_app(cred)


# ส่ง Noti -> MyPhone
def sendPush(token: str, title: str, body: str) -> bool:
    _init()

    msg = messaging.Message(
        token=token,
        notification=messaging.Notification(title=title, body=body),
    )

    try:
        messaging.send(msg)
        return True
    except (messaging.UnregisteredError, messaging.SenderIdMismatchError):
        return False
