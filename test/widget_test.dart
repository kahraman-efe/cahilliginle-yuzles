/// Cahilliğinle Yüzleş - Temel widget testi
//
// Bu test, uygulamanın açılışta Kategori Ekranını gösterdiğini
// ve bir kategoriye tıklandığında Oyun Ekranına geçtiğini doğrular.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ilk_uygulamam/main.dart';

void main() {
  testWidgets('Kategori ekranı açılır ve başlık görünür',
      (WidgetTester tester) async {
    // Uygulamayı derle ve ilk frame'i tetikle.
    await tester.pumpWidget(CahilliginleYuzlesApp());

    // Başlığın ekranda olduğunu doğrula.
    expect(find.text('Cahilliğinle'), findsOneWidget);
    expect(find.text('Yüzleş'), findsOneWidget);

    // Kategori kartlarından birinin (örn. "Yazılım") göründüğünü doğrula.
    expect(find.text('Yazılım'), findsOneWidget);
  });

  testWidgets('Kategoriye tıklayınca Oyun Ekranı açılır',
      (WidgetTester tester) async {
    await tester.pumpWidget(CahilliginleYuzlesApp());

    // "Yazılım" kategorisine tıkla.
    await tester.tap(find.text('Yazılım'));
    await tester.pumpAndSettle(); // geçiş animasyonunun bitmesini bekle

    // Oyun ekranındaki ilk soru metninin göründüğünü doğrula.
    expect(
      find.text('Flutter uygulamaları geliştirmek için hangi dil kullanılır?'),
      findsOneWidget,
    );
  });
}

