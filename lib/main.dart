import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speedy_poker/page/home_page.dart';
import 'model/socket.dart';

void main() {
  SocketService socket = SocketService();
  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => socket),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const SpeedyPoker(),
      ),
    ),
  );
}
