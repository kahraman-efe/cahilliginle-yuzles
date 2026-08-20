import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../models/models.dart';
import 'oyun_ekrani.dart';

class ZorlukEkrani extends StatelessWidget {
  final Kategori secilenKategori;

  ZorlukEkrani({required this.secilenKategori});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("Zorluk Seç"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Hero(
              tag: secilenKategori.ad,
              child: Icon(secilenKategori.ikon, size: 60, color: secilenKategori.renk),
            ),
            SizedBox(height: 10),
            Text(secilenKategori.ad, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
            SizedBox(height: 30),
            Expanded(
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: [
                  _zorlukKarti(context, Zorluk.kolay, "Kolay", "Isınma turu", "+10 Puan / -5 Puan", AppColors.kolay),
                  _zorlukKarti(context, Zorluk.orta, "Orta", "Biraz düşün", "+20 Puan / -10 Puan", AppColors.orta),
                  _zorlukKarti(context, Zorluk.zor, "Zor", "Gerçekten biliyor musun?", "+30 Puan / -15 Puan", AppColors.zor),
                  _zorlukKarti(context, Zorluk.uzman, "Uzman", "Cahilliğinle yüzleş!", "+50 Puan / -25 Puan", AppColors.uzman),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _zorlukKarti(BuildContext context, Zorluk z, String ad, String aciklama, String puanMetni, Color renk) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (_) => OyunEkrani(kategori: secilenKategori, zorluk: z, zorlukRengi: renk)
          ));
        },
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: renk.withOpacity(0.5), width: 2),
            boxShadow: [
              BoxShadow(color: renk.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 4))
            ]
          ),
          child: Row(
            children: [
              Container(
                width: 16, height: 16,
                decoration: BoxDecoration(color: renk, shape: BoxShape.circle),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(ad, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                    SizedBox(height: 4),
                    Text(aciklama, style: TextStyle(color: AppColors.textMuted, fontSize: 14)),
                  ],
                ),
              ),
              Text(puanMetni, style: TextStyle(color: renk, fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}