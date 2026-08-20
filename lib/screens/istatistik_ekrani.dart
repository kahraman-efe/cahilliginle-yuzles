import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../services/storage_service.dart';

class IstatistikEkrani extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Kariyer İstatistikleri"), backgroundColor: Colors.transparent, elevation: 0),
      body: ListView(
        padding: EdgeInsets.all(20),
        physics: BouncingScrollPhysics(),
        children: [
          _statCard("Toplam Puan", StorageService.toplamPuan.toString(), Icons.star, AppColors.accent),
          _statCard("En Yüksek Skor", StorageService.enYuksekSkor.toString(), Icons.emoji_events, Colors.orange),
          _statCard("Oynanan Oyun", StorageService.toplamOyun.toString(), Icons.gamepad, Colors.blue),
          _statCard("Toplam Doğru", StorageService.toplamDogru.toString(), Icons.check_circle, AppColors.correct),
          _statCard("Toplam Yanlış", StorageService.toplamYanlis.toString(), Icons.cancel, AppColors.wrong),
          _statCard("En Uzun Doğru Serisi", "x${StorageService.enUzunSeri}", Icons.local_fire_department, Colors.deepOrange),
        ],
      ),
    );
  }

  Widget _statCard(String baslik, String deger, IconData ikon, Color renk) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(color: renk.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
            child: Icon(ikon, color: renk, size: 28),
          ),
          SizedBox(width: 20),
          Expanded(child: Text(baslik, style: TextStyle(fontSize: 18, color: Colors.white))),
          Text(deger, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: renk)),
        ],
      ),
    );
  }
}