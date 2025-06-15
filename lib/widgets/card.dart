import 'package:flutter/material.dart';
import 'package:speedy_poker/logic/encoding_conversion.dart';

class Card extends StatelessWidget {
  final int cardNumber;

  const Card({super.key, required this.cardNumber});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Image(image: AssetImage(createCardSVGPath(cardNumber)));
  }
}
