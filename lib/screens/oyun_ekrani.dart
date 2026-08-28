import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:audioplayers/audioplayers.dart'; // SES PAKETİ EKLENDİ
import '../theme/app_colors.dart';
import '../models/models.dart';
import 'sonuc_ekrani.dart';
import '../services/storage_service.dart';

class OyunEkrani extends StatefulWidget {
  final Kategori kategori;
  final Zorluk zorluk;
  final Color zorlukRengi;

  OyunEkrani({required this.kategori, required this.zorluk, required this.zorlukRengi});

  @override
  _OyunEkraniState createState() => _OyunEkraniState();
}

class _OyunEkraniState extends State<OyunEkrani> {
  bool isLoading = true;
  int puan = 0;
  int kacinciSoru = 0;
  int dogruSayisi = 0;
  int yanlisSayisi = 0;
  int combo = 0;
  int maxCombo = 0;

  List<Soru> aktifSorular = [];
  String? secilenSik;
  bool cevapVerildi = false;

  final AudioPlayer _audioPlayer = AudioPlayer(); // SES OYNATICI

  @override
  void initState() {
    super.initState();
    _firebaseDenSorulariCek();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

   Future<void> _firebaseDenSorulariCek() async {
    try {
      String zorlukString = widget.zorluk.name;
      String anahtar = "${widget.kategori.ad}_$zorlukString";

      var snapshot = await FirebaseFirestore.instance
          .collection('Sorular')
          .where('kategori', isEqualTo: widget.kategori.ad)
          .where('zorluk', isEqualTo: zorlukString)
          .get();

      List<Soru> tumSorular = snapshot.docs.map((doc) {
        var data = doc.data();
        return Soru(
          id: doc.id, // YENİ
          kategori: data['kategori'] ?? '',
          zorluk: widget.zorluk,
          soruMetni: data['soruMetni'] ?? '',
          secenekA: data['secenekA'] ?? '',
          secenekB: data['secenekB'] ?? '',
          secenekC: data['secenekC'] ?? '',
          secenekD: data['secenekD'] ?? '',
          dogruCevap: data['dogruCevap'] ?? '',
          gorselUrl: data['gorselUrl'],
          sesUrl: data['sesUrl'],
        );
      }).toList();

      // Daha önce görülmüş soruları filtrele
      List<String> gorulenler = StorageService.gorulenSorular(anahtar);
      List<Soru> gorulmemisSorular =
          tumSorular.where((s) => !gorulenler.contains(s.id)).toList();

      // Görülmemiş soru kalmadıysa listeyi sıfırla, baştan başla
      if (gorulmemisSorular.length < 10) {
        await StorageService.gorulenSorulariSifirla(anahtar);
        gorulmemisSorular = tumSorular;
      }

      gorulmemisSorular.shuffle();
      aktifSorular = gorulmemisSorular.take(10).toList();

      // Bu sefer gösterilecek soruları "görülen" olarak işaretle
      await StorageService.gorulenSorulariEkle(
          anahtar, aktifSorular.map((s) => s.id).toList());

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print("Firebase'den soru çekilirken hata oluştu: $e");
      setState(() {
        isLoading = false;
      });
    }
  }
  int get dogruPuani {
    switch (widget.zorluk) {
      case Zorluk.kolay:
        return 10;
      case Zorluk.orta:
        return 20;
      case Zorluk.zor:
        return 30;
      case Zorluk.uzman:
        return 50;
    }
  }

  int get yanlisPuani {
    switch (widget.zorluk) {
      case Zorluk.kolay:
        return 5;
      case Zorluk.orta:
        return 10;
      case Zorluk.zor:
        return 15;
      case Zorluk.uzman:
        return 25;
    }
  }

  void cevapKontrolEt(String kullaniciCevabi) {
    if (cevapVerildi) return;

    bool dogruMu = kullaniciCevabi == aktifSorular[kacinciSoru].dogruCevap;

    setState(() {
      cevapVerildi = true;
      secilenSik = kullaniciCevabi;

      if (dogruMu) {
        _audioPlayer.play(AssetSource('sesler/dogru.wav')); // DOĞRU SESİ
        dogruSayisi++;
        combo++;
        if (combo > maxCombo) maxCombo = combo;

        int kazanilan = dogruPuani + (combo > 1 ? combo * 2 : 0);
        puan += kazanilan;
      } else {
        _audioPlayer.play(AssetSource('sesler/yanlis.wav')); // YANLIŞ SESİ
        yanlisSayisi++;
        combo = 0;
        puan -= yanlisPuani;
        if (puan < 0) puan = 0;
      }
    });

    Timer(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      setState(() {
        if (kacinciSoru < aktifSorular.length - 1) {
          kacinciSoru++;
          cevapVerildi = false;
          secilenSik = null;
        } else {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => SonucEkrani(
                  kategori: widget.kategori,
                  zorluk: widget.zorluk,
                  puan: puan,
                  dogru: dogruSayisi,
                  yanlis: yanlisSayisi,
                  maxCombo: maxCombo,
                  toplamSoru: aktifSorular.length,
                ),
              ));
        }
      });
    });
  }

  Widget sikButonu(String harf, String metin) {
    final soru = aktifSorular[kacinciSoru];
    Color bgRenk = AppColors.card;
    Color borderRenk = Colors.white12;
    double scale = 1.0;

    if (cevapVerildi) {
      if (harf == soru.dogruCevap) {
        bgRenk = AppColors.correct.withOpacity(0.2);
        borderRenk = AppColors.correct;
        scale = 1.02;
      } else if (harf == secilenSik) {
        bgRenk = AppColors.wrong.withOpacity(0.2);
        borderRenk = AppColors.wrong;
        scale = 0.98;
      }
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutBack,
      transform: Matrix4.identity()..scale(scale),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: bgRenk,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderRenk, width: 2),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => cevapKontrolEt(harf),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: borderRenk == Colors.white12 ? Colors.white12 : borderRenk,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Text(harf,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(metin, style: const TextStyle(fontSize: 16, color: Colors.white)),
              ),
              if (cevapVerildi && harf == soru.dogruCevap)
                Icon(Icons.check_circle, color: AppColors.correct),
              if (cevapVerildi && harf == secilenSik && harf != soru.dogruCevap)
                Icon(Icons.cancel, color: AppColors.wrong),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.kategori.ad), backgroundColor: Colors.transparent),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: widget.zorlukRengi),
              const SizedBox(height: 16),
              const Text("Sorular buluttan çekiliyor...", style: TextStyle(color: Colors.white70)),
            ],
          ),
        ),
      );
    }

    if (aktifSorular.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.kategori.ad), backgroundColor: Colors.transparent),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              "Bu kategori ve zorlukta henüz soru eklenmemiş. Lütfen daha sonra tekrar dene!",
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ),
      );
    }

    final soru = aktifSorular[kacinciSoru];
    final ilerleme = (kacinciSoru + 1) / aktifSorular.length;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.kategori.ad, style: const TextStyle(fontSize: 16)),
            Text(widget.zorluk.name.toUpperCase(),
                style: TextStyle(fontSize: 12, color: widget.zorlukRengi)),
          ],
        ),
        actions: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration:
                  BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(12)),
              child: Text("$puan Puan",
                  style: const TextStyle(
                      color: AppColors.accent, fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Soru ${kacinciSoru + 1} / ${aktifSorular.length}",
                      style: const TextStyle(color: AppColors.textMuted)),
                  AnimatedOpacity(
                    opacity: combo > 1 ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: Text("🔥 $combo Combo!",
                        style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                  )
                ],
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: ilerleme),
                  duration: const Duration(milliseconds: 300),
                  builder: (context, val, _) => LinearProgressIndicator(
                    value: val,
                    minHeight: 8,
                    backgroundColor: AppColors.card,
                    valueColor: AlwaysStoppedAnimation(widget.zorlukRengi),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                flex: 3,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  child: Container(
                    key: ValueKey(kacinciSoru),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          soru.soruMetni,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              height: 1.4),
                        ),
                        if (soru.gorselUrl != null && soru.gorselUrl!.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              soru.gorselUrl!,
                              height: 160,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => const Icon(
                                  Icons.broken_image,
                                  color: Colors.white54,
                                  size: 50),
                            ),
                          ),
                        ]
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                flex: 4,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  child: ListView(
                    key: ValueKey('secenekler_$kacinciSoru'),
                    physics: const BouncingScrollPhysics(),
                    children: [
                      sikButonu("A", soru.secenekA),
                      sikButonu("B", soru.secenekB),
                      sikButonu("C", soru.secenekC),
                      sikButonu("D", soru.secenekD),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}