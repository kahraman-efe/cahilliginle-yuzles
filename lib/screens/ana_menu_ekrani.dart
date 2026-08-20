import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../data/kategoriler.dart';
import '../models/models.dart';
import '../services/storage_service.dart';
import 'zorluk_ekrani.dart';
import 'istatistik_ekrani.dart';
import 'rozet_ekrani.dart';

class AnaMenuEkrani extends StatefulWidget {
  @override
  _AnaMenuEkraniState createState() => _AnaMenuEkraniState();
}

class _AnaMenuEkraniState extends State<AnaMenuEkrani> {
  @override
  Widget build(BuildContext context) {
    double basariOrani = StorageService.toplamOyun == 0 
        ? 0 
        : (StorageService.toplamDogru / (StorageService.toplamDogru + StorageService.toplamYanlis) * 100);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Üst Başlık ve Butonlar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Cahilliğinle", style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.white, height: 1.1)),
                      Text("Yüzleş", style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: AppColors.accent, height: 1.1)),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.bar_chart, color: Colors.white),
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => IstatistikEkrani())).then((_) => setState((){})),
                      ),
                      IconButton(
                        icon: Icon(Icons.military_tech, color: AppColors.accent, size: 28),
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RozetEkrani())).then((_) => setState((){})),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(height: 20),
              
              // İstatistik Kartı
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _statItem("Puan", StorageService.toplamPuan.toString(), Icons.star, AppColors.accent),
                    _statItem("Başarı", "%${basariOrani.toInt()}", Icons.track_changes, AppColors.correct),
                    _statItem("Oyun", StorageService.toplamOyun.toString(), Icons.gamepad, Colors.blue),
                  ],
                ),
              ),
              SizedBox(height: 24),
              Text("Kategoriler", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
              SizedBox(height: 12),
              
              // Kategoriler Grid
              Expanded(
                child: GridView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: tumKategoriler.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.1,
                  ),
                  itemBuilder: (context, i) => _kategoriKarti(context, tumKategoriler[i]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statItem(String baslik, String deger, IconData ikon, Color renk) {
    return Column(
      children: [
        Icon(ikon, color: renk, size: 24),
        SizedBox(height: 8),
        Text(deger, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        Text(baslik, style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
      ],
    );
  }

  Widget _kategoriKarti(BuildContext context, Kategori k) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (_) => ZorlukEkrani(secilenKategori: k)
        ));
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [k.renk.withOpacity(0.9), k.renk.withOpacity(0.5)],
          ),
          boxShadow: [
            BoxShadow(color: k.renk.withOpacity(0.3), blurRadius: 10, offset: Offset(0, 5)),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(k.ikon, size: 40, color: Colors.white),
            SizedBox(height: 12),
            Text(k.ad, style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}