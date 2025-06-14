import 'package:flutter/cupertino.dart';

class SpeedyPokerGamePage extends StatefulWidget{
  const SpeedyPokerGamePage({super.key, required this.gameCode});

  final int gameCode;

  @override
  State<SpeedyPokerGamePage> createState() => _SpeedyPokerGamePageState();
}

class _SpeedyPokerGamePageState extends State<SpeedyPokerGamePage>{

  @override
  Widget build(BuildContext context){
    return Center();
  }
}