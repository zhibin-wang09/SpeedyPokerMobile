import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speedy_poker/model/game.dart';
import 'package:speedy_poker/model/socket.dart';
import 'package:speedy_poker/page/waiting_page.dart';

// This is the top of the widget tree representing the overall theme for the game
class SpeedyPoker extends StatelessWidget {
  const SpeedyPoker({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Speedy Poker',
      theme: ThemeData(scaffoldBackgroundColor: Colors.black),
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Speedy Poker',
              style: TextStyle(fontSize: 30, color: Colors.white),
            ),
            const SpeedyPokerHomePage(),
          ],
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
  final GlobalKey<FormState> _formkey =
      GlobalKey<FormState>(); // form key for the overall form
  final TextEditingController roomIdController =
      TextEditingController(); // controller to monitor input change in first input field
  final TextEditingController nameController =
      TextEditingController(); // controller for the second input field

  @override
  void dispose() {
    roomIdController.dispose();
    nameController.dispose();
    super.dispose();
  }

  // factored function to modify input field attributes like hints and validator
  Widget _inputField(
    String hint,
    String? Function(String?)? validator,
    TextEditingController controller,
  ) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(fontSize: 12, color: Colors.white),
      ),
      validator: validator,
      style: TextStyle(fontSize: 12, color: Colors.white),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formkey,
      child: Container(
        margin: EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _inputField('Room Number', (value) {
              int? val = int.tryParse(value!);
              if (val == null || value.isEmpty) {
                return 'Please enter room number (Ex. 1910)';
              } else if (val < 0) {
                return 'Room numbers can only be positive';
              }
              return null;
            }, roomIdController),
            _inputField('Name', (value) => null, nameController),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Consumer<SocketService>(
                builder: (context, socketService, child) {
                  return ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.white),
                    ),
                    onPressed: () {
                      if (_formkey.currentState!.validate()) {
                        int roomID = int.parse(roomIdController.text);
                        String playerName = nameController.text;

                        final Game game = Provider.of<Game>(context, listen: false);
                        game.setRoomID = roomID;

                        // join the game room
                        socketService.emit('joinGameRoom', [
                          {'roomID': roomID, 'playerName': playerName},
                        ]);

                        SocketService().socket.on('receiveRoomID', (roomID) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SpeedyPokerWaitingPage(
                                roomID: int.parse(roomID),
                              ),
                            ),
                          );
                        });
                      }
                    },
                    child: const Text(
                      'Submit',
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
