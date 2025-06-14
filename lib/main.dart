import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'model/player.dart';
import 'model/game.dart';
import 'model/socket.dart';
import 'page/home_page.dart';

void main() {

  SocketService socket = SocketService();
  runApp(
      MultiProvider(
          providers:[
            Provider(create: (context) => socket),
            ChangeNotifierProvider(create: (context) => Player()),
            ChangeNotifierProvider(create: (context) => Game()),
          ],
          child: const SpeedyPoker(),
      ),
  );
}

