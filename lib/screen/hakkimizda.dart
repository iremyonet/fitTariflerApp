import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class hakkimizda extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var ekranbilgisi = MediaQuery.of(context);
    final double ekranYuksekligi = ekranbilgisi.size.height;
    final double ekranGenislik = ekranbilgisi.size.width;
    return new Scaffold(
      body: new Image.asset(
        "images/hakkimizda.jpg",
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
        alignment: Alignment.center,
      ),
    );
  }
}
