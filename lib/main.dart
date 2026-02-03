import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'pages/home_page.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // 设置横屏模式（适配平板）
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

  // // 设置系统UI样式（暗色状态栏）
  // SystemChrome.setSystemUIOverlayStyle(
  //   const SystemUiOverlayStyle(
  //     statusBarColor: Colors.transparent,
  //     statusBarIconBrightness: Brightness.light,
  //     systemNavigationBarColor: AppTheme.backgroundColor,
  //     systemNavigationBarIconBrightness: Brightness.light,
  //   ),
  // );

  // 隐藏状态栏和导航栏（全屏模式）
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky, overlays: []);
  runApp(const PhotoRefractorApp());
}

class PhotoRefractorApp extends StatelessWidget {
  const PhotoRefractorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PhotoRefractor',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const HomePage(),
    );
  }
}
