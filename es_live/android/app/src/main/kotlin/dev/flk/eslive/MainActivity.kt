package dev.flk.eslive

import android.app.NotificationChannel
import android.app.NotificationManager
import android.os.Build
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        createNotiChannel()
    }

    // Android 8+ จะเด้งแจ้งเตือนเป็นกล่องก็ต่อเมื่อ channel ตั้งความสำคัญเป็น HIGH
    // ช่องที่ FCM สร้างให้เองมีความสำคัญระดับปกติ จึงขึ้นแค่ในแถบ ไม่เด้ง
    private fun createNotiChannel() {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return

        val channel = NotificationChannel(
            "eslive_match",
            "Match alerts",
            NotificationManager.IMPORTANCE_HIGH
        )
        getSystemService(NotificationManager::class.java).createNotificationChannel(channel)
    }
}
