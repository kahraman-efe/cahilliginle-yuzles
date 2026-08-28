import 'package:flutter/material.dart';

// Zorluk seviyelerimiz
enum Zorluk {
  kolay,
  orta,
  zor,
  uzman
}

// Kategori modelimiz
class Kategori {
  final String ad;
  final IconData ikon;
  final Color renk;

  Kategori(this.ad, this.ikon, this.renk);
}

// Resim ve Ses destekli Soru modelimiz
class Soru {
  final String id; // YENİ - Firestore doküman ID'si
  final String kategori;
  final Zorluk zorluk;
  final String soruMetni;
  final String secenekA;
  final String secenekB;
  final String secenekC;
  final String secenekD;
  final String dogruCevap;
  final String? gorselUrl; // Resim linki (opsiyonel)
  final String? sesUrl;    // Ses linki (opsiyonel)

  Soru({
    required this.id, // YENİ
    required this.kategori,
    required this.zorluk,
    required this.soruMetni,
    required this.secenekA,
    required this.secenekB,
    required this.secenekC,
    required this.secenekD,
    required this.dogruCevap,
    this.gorselUrl,
    this.sesUrl,
  });

}

  // Rozet (Başarım) modelimiz
class Rozet {
  final String id;
  final String ad;
  final String aciklama;
  final String ikon;
  final Color renk;

  Rozet({
    required this.id,
    required this.ad,
    required this.aciklama,
    required this.ikon,
    required this.renk,
  });
}