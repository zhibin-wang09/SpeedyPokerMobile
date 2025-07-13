import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speedy_poker/enums/mode.dart';
import 'package:speedy_poker/model/socket.dart';
import 'package:speedy_poker/page/form_page.dart';

// This is the top of the widget tree representing the overall theme for the game
class SpeedyPoker extends StatelessWidget {
  const SpeedyPoker({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Speedy Poker',
      theme: ThemeData(scaffoldBackgroundColor: Colors.white),
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Speedy Poker'.toUpperCase(),
                style: TextStyle(fontSize: 30, color: Colors.black),
              ),
              SpeedyPokerHomePage(),
            ],
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

// Stateful widget that keeps track is the home page
// Contains input fields for game code and name
class SpeedyPokerHomePage extends StatefulWidget {
  const SpeedyPokerHomePage({super.key});

  // createState() function is what StatefulWidget uses to keep track of it's states
  @override
  State<SpeedyPokerHomePage> createState() => _SpeedyPokerHomePageState();
}

// The state for SpeedyPokerHomePage widget
// contains form, two input fields, and a submission button
class _SpeedyPokerHomePageState extends State<SpeedyPokerHomePage> {
  late Mode mode;

  @override
  void initState() {
    super.initState();
    mode = Mode.home;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(40.0),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Consumer<SocketService>(
              builder: (context, socketService, child) {
                return Column(
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Colors.blue),
                      ),
                      onPressed: () {
                        if (mode == Mode.home) {
                         Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SpeedyPokerFormPage(mode: Mode.create),
                              settings: RouteSettings(name: "/home")
                            ),
                          );
                        }
                      },
                      child: const Text(
                        'CREATE GAME',
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.green),
                      ),
                      onPressed: () {
                        if (mode == Mode.home) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SpeedyPokerFormPage(mode: Mode.joinTargetRoom),
                              settings: RouteSettings(name: "/home"),
                            ),
                          );
                        }
                      },
                      child: const Text(
                        'JOIN VIA CODE',
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.red),
                      ),
                      onPressed: () {
                        if (mode == Mode.home) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SpeedyPokerFormPage(mode: Mode.joinAnyRoom),
                              settings: RouteSettings(name: "/home")
                            ),
                          );
                        }
                      },
                      child: const Text(
                        'JOIN ANY GAME',
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      );
  }
}
