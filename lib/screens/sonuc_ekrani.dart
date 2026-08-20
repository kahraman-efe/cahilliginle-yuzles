import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../models/models.dart';
import '../services/storage_service.dart';

class SonucEkrani extends StatefulWidget {
  final Kategori kategori;
  final Zorluk zorluk;
  final int puan;
  final int dogru;
  final int yanlis;
  final int maxCombo;
  final int toplamSoru;

  SonucEkrani({
    required this.kategori, required this.zorluk, required this.puan, 
    required this.dogru, required this.yanlis, required this.maxCombo, required this.toplamSoru
  });

  @override
  _SonucEkraniState createState() => _SonucEkraniState();
}

class _SonucEkraniState extends State<SonucEkrani> {
  bool yeniRekor = false;

  @override
  void initState() {
    super.initState();
    if (widget.puan > StorageService.enYuksekSkor && StorageService.toplamOyun > 0) {
      yeniRekor = true;
    }
    
    // Verileri Kaydet
    StorageService.istatistikleriGuncelle(
      puan: widget.puan, dogru: widget.dogru, yanlis: widget.yanlis, maxCombo: widget.maxCombo
    );
    
    _rozetleriKontrolEt();
  }

  void _rozetleriKontrolEt() async {
    if (StorageService.toplamDogru >= 1) await StorageService.rozetEkle("ilk_adim");
    if (widget.maxCombo >= 5) await StorageService.rozetEkle("beste_bes");
    if (StorageService.toplamDogru >= 50) await StorageService.rozetEkle("bilgili");
    if (widget.zorluk == Zorluk.zor) await StorageService.rozetEkle("zor_adam");
    if (widget.zorluk == Zorluk.uzman) await StorageService.rozetEkle("uzman");
    if (widget.dogru / widget.toplamSoru >= 0.9) await StorageService.rozetEkle("keskin_nisanci");
    if (StorageService.toplamPuan >= 1000) await StorageService.rozetEkle("quiz_ustasi");
  }

  @override
  Widget build(BuildContext context) {
    double basariOrani = widget.toplamSoru == 0 ? 0 : (widget.dogru / widget.toplamSoru) * 100;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (yeniRekor)
                  Container(
                    margin: EdgeInsets.only(bottom: 20),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(20)),
                    child: Text("🔥 YENİ REKOR!", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                Text("OYUN TAMAMLANDI", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 2)),
                SizedBox(height: 30),
                Text("${widget.puan}", style: TextStyle(fontSize: 72, fontWeight: FontWeight.w900, color: AppColors.accent, height: 1)),
                Text("Puan", style: TextStyle(fontSize: 18, color: AppColors.textMuted)),
                SizedBox(height: 40),
                
                // İstatistik Grid
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    children: [
                      _sonucSatiri("Doğru", "${widget.dogru} / ${widget.toplamSoru}", AppColors.correct),
                      Divider(color: Colors.white12, height: 30),
                      _sonucSatiri("Başarı", "%${basariOrani.toInt()}", Colors.blue),
                      Divider(color: Colors.white12, height: 30),
                      _sonucSatiri("Max Combo", "x${widget.maxCombo}", Colors.orange),
                    ],
                  ),
                ),
                SizedBox(height: 40),
                
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.kategori.renk,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))
                    ),
                    onPressed: () => Navigator.pop(context), // Menüye döner, oyunu zorluk ekranı üzerinden açmıştı
                    child: Text("Ana Menüye Dön", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sonucSatiri(String baslik, String deger, Color renk) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(baslik, style: TextStyle(fontSize: 18, color: Colors.white)),
        Text(deger, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: renk)),
      ],
    );
  }
}