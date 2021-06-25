import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'colors.dart';

Container search_box() {
  return Container(
    margin: EdgeInsets.all(20),
    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(50),
      border: Border.all(
        color: ksecondaryColor.withOpacity(0.32),
      ),
    ),
    child: TextField(
      decoration: InputDecoration(
        border: InputBorder.none,
        icon: SvgPicture.asset("icons/search.svg"),
        hintText: "Search Here",
        hintStyle: TextStyle(color: ksecondaryColor),
      ),
    ),
  );
}