import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'theme/app_colors.dart';
import 'services/storage_service.dart';
import 'screens/ana_menu_ekrani.dart';

void main() async {
  // SharedPreferences ve Flutter engine bağlantısını güvenli başlatır.
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase'i başlat
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Cihazdaki istatistikleri yükle
  await StorageService.init();

  // Sadece dikey kullanım
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(CahilliginleYuzlesApp());
}

class CahilliginleYuzlesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cahilliğinle Yüzleş',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: AppColors.bg,
        appBarTheme: AppBarTheme(backgroundColor: AppColors.bg, elevation: 0),
         // Veya Google Fonts kullanıyorsan değiştirebilirsin
      ),
      home: AnaMenuEkrani(),
    );
  }
}