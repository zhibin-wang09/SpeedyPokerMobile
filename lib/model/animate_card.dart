import 'package:flutter/material.dart';

class AnimatingCard {
  final int cardNumber;
  final Animation<Offset> animation;
  final AnimationController controller;

  AnimatingCard({
    required this.cardNumber,
    required this.animation,
    required this.controller,
  });
}