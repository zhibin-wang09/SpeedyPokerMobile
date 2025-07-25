import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speedy_poker/enums/mode.dart';
import 'package:speedy_poker/model/socket.dart';
import 'package:speedy_poker/page/waiting_page.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:speedy_poker/util/helper_function.dart';

class SpeedyPokerFormPage extends StatefulWidget {
  const SpeedyPokerFormPage({super.key, required this.mode});

  final Mode mode;

  @override
  State<SpeedyPokerFormPage> createState() => _SpeedyPokerFormPageState();
}

class _SpeedyPokerFormPageState extends State<SpeedyPokerFormPage> {
  final GlobalKey<FormState> _formkey =
      GlobalKey<FormState>(); // form key for the overall form
  final GlobalKey<FormFieldState> _nameInputKey = GlobalKey();
  final TextEditingController roomIdController =
      TextEditingController(); // controller to monitor input change in first input field
  final TextEditingController nameController =
      TextEditingController(); // controller for t
  late SocketService socketService;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.on("game:error", _handleGameError);
    socketService.socket.on("user:joined", _handleUserJoin);
  }

  @override
  void dispose() {
    socketService.socket.off("user:joined", _handleUserJoin);
    socketService.socket.off("game:error", _handleGameError);
    roomIdController.dispose();
    nameController.dispose();
    super.dispose();
  }

  void _handleUserJoin(dynamic json) {
    String roomId = json as String;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SpeedyPokerWaitingPage(roomID: int.parse(roomId)),
      ),
    );
  }

  void _handleGameError(dynamic json) {
    String errorMessage = json as String;

    showErrorAndBack(
      context,
      errorMessage,
      ToastGravity.BOTTOM,
      const Color.fromARGB(255, 229, 104, 116),
      Colors.white,
    );
  }

  Widget _inputField(
    String label,
    String hint,
    String? Function(String?)? validator,
    TextEditingController controller,
    GlobalKey? key,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: const Color.fromARGB(255, 78, 77, 77)),
        ),
        TextFormField(
          key: key,
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(fontSize: 12, color: Colors.black),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
            ),
          ),
          validator: validator,
          style: TextStyle(fontSize: 12, color: Colors.black),
        ),
      ],
    );
  }

  Widget _button(
    VoidCallback onPressed,
    Color color,
    String buttonText,
    SocketService socketService,
  ) {
    return ElevatedButton(
      style: ButtonStyle(backgroundColor: WidgetStateProperty.all(color)),
      onPressed: onPressed,
      child: Text(
        buttonText,
        style: TextStyle(fontSize: 12, color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
        body: Center(
          child: Form(
            key: _formkey,
            child: Container(
              margin: EdgeInsets.all(40.0),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  _inputField(
                    'Player Name',
                    'Ex. Raisa',
                    (value) {
                      if (value == null || value.isEmpty) {
                        return 'You must have a user name';
                      }
                      return null;
                    },
                    nameController,
                    _nameInputKey,
                  ),
                  const SizedBox(height: 40),
                  widget.mode == Mode.joinTargetRoom
                      ? _inputField(
                          'Game Code',
                          'Ex. 4242024',
                          (value) {
                            int? val = int.tryParse(value!);
                            if (val == null || value.isEmpty) {
                              return 'Please enter room number (Ex. 1910)';
                            } else if (val < 0) {
                              return 'Room numbers can only be positive';
                            }
                            return null;
                          },
                          roomIdController,
                          null,
                        )
                      : const SizedBox.shrink(),
                  const SizedBox(height: 10),
                  widget.mode == Mode.create
                      ? _button(
                          () {
                            if (_nameInputKey.currentState!.validate()) {
                              String playerName = nameController.text;

                              socketService.emit('user:create', [playerName]);

                              SocketService().socket.on('user:joined', (
                                roomID,
                              ) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        SpeedyPokerWaitingPage(
                                          roomID: int.parse(roomID),
                                        ),
                                  ),
                                );
                              });
                            }
                          },
                          Colors.blue,
                          'CREATE GAME',
                          socketService,
                        )
                      : const SizedBox.shrink(),
                  const SizedBox(height: 10),
                  widget.mode == Mode.joinTargetRoom
                      ? _button(
                          () {
                            if (_formkey.currentState!.validate()) {
                              int roomID = int.parse(roomIdController.text);
                              String playerName = nameController.text;

                              // join the game room
                              socketService.emit('user:join', [
                                roomID,
                                playerName,
                              ]);
                            }
                          },
                          Colors.green,
                          'JOIN VIA CODE',
                          socketService,
                        )
                      : const SizedBox.shrink(),
                  widget.mode == Mode.joinAnyRoom
                      ? _button(
                          () {
                            if (_formkey.currentState!.validate()) {
                              String playerName = nameController.text;

                              // join the game room
                              socketService.emit('user:join_any', [playerName]);

                              SocketService().socket.on('user:joined', (
                                roomID,
                              ) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        SpeedyPokerWaitingPage(
                                          roomID: int.parse(roomID),
                                        ),
                                  ),
                                );
                              });
                            }
                          },
                          Colors.red,
                          'JOIN ANY GAME',
                          socketService,
                        )
                      : const SizedBox.shrink(),
                  _button(
                    () {
                      Navigator.pop(context);
                    },
                    Colors.indigo,
                    'GO BACK',
                    socketService,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
