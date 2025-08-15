// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

class theme {
  final Color background_color;
  final LinearGradient elevated_background_color;
  final Color main_text_color;
  final Color sub_text_color;
  final Color main_button_color;
  final Color main_button_text_color;
  final Color sub_button_color;
  final Color sub_button_text_color;
  final Color tab_bar_color;

  theme({
    required this.elevated_background_color, 
    required this.main_button_text_color, 
    required this.sub_button_text_color,
    required this.background_color,
    required this.main_button_color,
    required this.main_text_color,
    required this.sub_button_color,
    required this.sub_text_color,
    required this.tab_bar_color
  });
}

theme lightTheme = theme(
  background_color: Colors.grey[100]!,
  elevated_background_color: 
    LinearGradient(
      colors: [
        Colors.deepPurple[400]!,
        Colors.deepPurple[200]!,
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  main_text_color: Colors.black,
  sub_text_color: Colors.black54,
  main_button_color: Colors.deepPurple,
  main_button_text_color: Colors.white,
  sub_button_color: Colors.white,
  sub_button_text_color: Colors.black,
  tab_bar_color: Colors.deepPurple[400]!
);

theme darkTheme = theme(
  background_color: Colors.grey[900]!, 
  elevated_background_color: 
    LinearGradient(
      colors: [
        Colors.deepPurple,
        Colors.deepPurple[200]!,
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  main_text_color: Colors.white,
  sub_text_color: Colors.grey[400]!,
  main_button_color: Colors.deepPurple,
  main_button_text_color: Colors.white,
  sub_button_color: Colors.grey[800]!, 
  sub_button_text_color: Colors.white,
  tab_bar_color: Colors.deepPurple
);