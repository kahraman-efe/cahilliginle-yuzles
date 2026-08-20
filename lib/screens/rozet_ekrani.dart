import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../data/rozetler.dart';
import '../services/storage_service.dart';

class RozetEkrani extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<String> kazanilanlar = StorageService.kazanilanRozetler;

    return Scaffold(
      appBar: AppBar(title: Text("Rozetlerim"), backgroundColor: Colors.transparent, elevation: 0),
      body: GridView.builder(
        padding: EdgeInsets.all(20),
        physics: BouncingScrollPhysics(),
        itemCount: tumRozetler.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 0.85
        ),
        itemBuilder: (context, i) {
          final rozet = tumRozetler[i];
          final kazanildi = kazanilanlar.contains(rozet.id);
          
          return Container(
            decoration: BoxDecoration(
              color: kazanildi ? rozet.renk.withOpacity(0.15) : AppColors.card,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: kazanildi ? rozet.renk : Colors.white12, width: kazanildi ? 2 : 1),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(rozet.ikon, style: TextStyle(fontSize: 48, color: kazanildi ? null : Colors.grey.withOpacity(0.3))),
                SizedBox(height: 12),
                Text(rozet.ad, style: TextStyle(
                  color: kazanildi ? Colors.white : AppColors.textMuted, 
                  fontWeight: FontWeight.bold, fontSize: 16
                )),
                SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(rozet.aciklama, textAlign: TextAlign.center, style: TextStyle(
                    color: kazanildi ? Colors.white70 : Colors.white24, fontSize: 11
                  )),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}