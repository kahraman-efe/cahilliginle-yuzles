import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static int get toplamPuan => _prefs.getInt('toplamPuan') ?? 0;
  static set toplamPuan(int value) => _prefs.setInt('toplamPuan', value);

  static int get toplamOyun => _prefs.getInt('toplamOyun') ?? 0;
  static set toplamOyun(int value) => _prefs.setInt('toplamOyun', value);

  static int get toplamDogru => _prefs.getInt('toplamDogru') ?? 0;
  static set toplamDogru(int value) => _prefs.setInt('toplamDogru', value);

  static int get toplamYanlis => _prefs.getInt('toplamYanlis') ?? 0;
  static set toplamYanlis(int value) => _prefs.setInt('toplamYanlis', value);

  static int get enYuksekSkor => _prefs.getInt('enYuksekSkor') ?? 0;
  static set enYuksekSkor(int value) => _prefs.setInt('enYuksekSkor', value);

  static int get enUzunSeri => _prefs.getInt('enUzunSeri') ?? 0;
  static set enUzunSeri(int value) => _prefs.setInt('enUzunSeri', value);

  static List<String> get kazanilanRozetler => _prefs.getStringList('rozetler') ?? [];
  static Future<void> rozetEkle(String rozetId) async {
    List<String> mevcutlar = kazanilanRozetler;
    if (!mevcutlar.contains(rozetId)) {
      mevcutlar.add(rozetId);
      await _prefs.setStringList('rozetler', mevcutlar);
    }
  }

  // Oyun sonu istatistikleri güncelleme
  static void istatistikleriGuncelle({
    required int puan,
    required int dogru,
    required int yanlis,
    required int maxCombo,
  }) {
    toplamOyun += 1;
    toplamPuan += puan;
    toplamDogru += dogru;
    toplamYanlis += yanlis;
    
    if (puan > enYuksekSkor) enYuksekSkor = puan;
    if (maxCombo > enUzunSeri) enUzunSeri = maxCombo;
  }
}