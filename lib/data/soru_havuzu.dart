import '../models/models.dart';

final List<Soru> genelSoruHavuzu = [
  // YAZILIM - KOLAY
  Soru(kategori: "Yazılım", zorluk: Zorluk.kolay, soruMetni: "Flutter uygulamaları geliştirmek için hangi dil kullanılır?", secenekA: "Java", secenekB: "C#", secenekC: "Dart", secenekD: "Python", dogruCevap: "C"),
  Soru(kategori: "Yazılım", zorluk: Zorluk.kolay, soruMetni: "Web sayfalarının iskeletini oluşturan işaretleme dili hangisidir?", secenekA: "HTML", secenekB: "CSS", secenekC: "JS", secenekD: "PHP", dogruCevap: "A"),
  // YAZILIM - ORTA
  Soru(kategori: "Yazılım", zorluk: Zorluk.orta, soruMetni: "C# dilini hangi şirket geliştirmiştir?", secenekA: "Google", secenekB: "Apple", secenekC: "Microsoft", secenekD: "Meta", dogruCevap: "C"),
  Soru(kategori: "Yazılım", zorluk: Zorluk.orta, soruMetni: "Aşağıdakilerden hangisi bir ilişkisel veritabanı (RDBMS) değildir?", secenekA: "MySQL", secenekB: "PostgreSQL", secenekC: "MongoDB", secenekD: "SQLite", dogruCevap: "C"),
  // YAZILIM - ZOR
  Soru(kategori: "Yazılım", zorluk: Zorluk.zor, soruMetni: "Flutter'da durum yönetimi (state management) için kullanılan 'Provider' paketinin yaratıcısı kimdir?", secenekA: "Remi Rousselet", secenekB: "Felix Angelov", secenekC: "Filip Hracek", secenekD: "Lars Bak", dogruCevap: "A"),
  // YAZILIM - UZMAN
  Soru(kategori: "Yazılım", zorluk: Zorluk.uzman, soruMetni: "Dart dilinde bir 'Isolate' diğer bir Isolate ile belleği paylaşır mı?", secenekA: "Evet", secenekB: "Hayır", secenekC: "Sadece Web'de", secenekD: "Sadece Mobile'da", dogruCevap: "B"),
  
  // TARİH - KOLAY
  Soru(kategori: "Tarih", zorluk: Zorluk.kolay, soruMetni: "Türkiye Cumhuriyeti hangi yıl kurulmuştur?", secenekA: "1920", secenekB: "1923", secenekC: "1919", secenekD: "1925", dogruCevap: "B"),
  // TARİH - UZMAN
  Soru(kategori: "Tarih", zorluk: Zorluk.uzman, soruMetni: "Roma İmparatorluğu'nda 'Beş İyi İmparator' döneminin sonuncusu kimdir?", secenekA: "Nerva", secenekB: "Trajan", secenekC: "Hadrian", secenekD: "Marcus Aurelius", dogruCevap: "D"),
  
  // FİTNESS - ORTA
  Soru(kategori: "Fitness", zorluk: Zorluk.orta, soruMetni: "Kas gelişimi (Hypertrophy) için en önemli makro besin hangisidir?", secenekA: "Karbonhidrat", secenekB: "Yağ", secenekC: "Protein", secenekD: "Lif", dogruCevap: "C"),
];