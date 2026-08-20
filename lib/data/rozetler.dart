import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme/app_colors.dart';

final List<Rozet> tumRozetler = [
  Rozet(id: "ilk_adim", ad: "İlk Adım", aciklama: "İlk doğru cevabını ver.", ikon: "🥉", renk: Colors.brown),
  Rozet(id: "beste_bes", ad: "5'te 5", aciklama: "Arka arkaya 5 doğru cevap ver.", ikon: "🔥", renk: Colors.orange),
  Rozet(id: "bilgili", ad: "Bilgili", aciklama: "Toplam 50 doğru cevaba ulaş.", ikon: "🧠", renk: Colors.blue),
  Rozet(id: "zor_adam", ad: "Zor Adam", aciklama: "Zor seviyede bir oyunu tamamla.", ikon: "💀", renk: AppColors.zor),
  Rozet(id: "uzman", ad: "Uzman", aciklama: "Uzman seviyesinde bir oyunu tamamla.", ikon: "👑", renk: AppColors.uzman),
  Rozet(id: "keskin_nisanci", ad: "Keskin Nişancı", aciklama: "Bir oyunda %90 başarı sağla.", ikon: "🎯", renk: Colors.green),
  Rozet(id: "quiz_ustasi", ad: "Quiz Ustası", aciklama: "Toplam 1000 puana ulaş.", ikon: "🏆", renk: Colors.amber),
];