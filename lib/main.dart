import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:melodia/app/widgets/player/mini_player.dart';
import 'package:sizer/sizer.dart';
import 'app/routes/app_pages.dart';
import 'app/theme/app_theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.theme,
          initialRoute: AppRoutes.HOME,
          getPages: AppPages.routes,
        );
      },
    );
  }
}
