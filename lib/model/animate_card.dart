import 'package:flutter/material.dart';

import 'package:speedy_poker/enums/animated_card_type.dart';

class AnimatingCard {
  final int cardNumber;
  final Animation<Offset> animation;
  final AnimationController controller;
  final AnimateCardType type;

  AnimatingCard({
    required this.cardNumber,
    required this.animation,
    required this.controller,
    required this.type,
  });
}
