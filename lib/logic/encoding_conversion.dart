import 'dart:collection';

import 'package:speedy_poker/constants.dart';
import 'package:speedy_poker/enums/face_values.dart';
import 'package:speedy_poker/enums/suit.dart';

int getFaceValue(int card) {
  return card >> suitBinWidth;
}

int getSuitValue(int card) {
  return mask(suitBinWidth) & card;
}

int mask(int card) {
  return (1 << card) - 1;
}

String createCardSVGPath(int card) {
  final Map<FaceValue, String> faceValueNum = HashMap();
  List<String> faceValueNums = [
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11-JACK',
    '12-QUEEN',
    '13-KING',
    '1',
  ];

  for (var i = 0; i < faceValueNums.length; i++) {
    faceValueNum[FaceValue.values[i]] = faceValueNums[i];
  }
  String cardNum = faceValueNum[FaceValue.values[getFaceValue(card)]]??cardBackSVGPath;
  return "$cardsPrefixPath${Suit.values[getSuitValue(card)].name.toUpperCase()}-$cardNum.svg";
}
