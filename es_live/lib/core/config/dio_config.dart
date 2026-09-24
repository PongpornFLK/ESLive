import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final dio = Dio(
    BaseOptions(
      // baseUrl: 'http://127.0.0.1:8000',
      baseUrl: 'http://10.0.2.2:8000',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
    ),
  )
  // แนบ token ให้ทุก request ที่เดียว ไม่ต้องใส่ header เองทีละที่
  ..interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        // อ่านตอนยิงทุกครั้ง ไม่เก็บไว้ เพราะ Supabase ต่ออายุ token เองเรื่อย ๆ
        final token =
            Supabase.instance.client.auth.currentSession?.accessToken;

        if (token != null) {
          options.headers["Authorization"] = "Bearer $token";
        }

        return handler.next(options);
      },
    ),
  );
