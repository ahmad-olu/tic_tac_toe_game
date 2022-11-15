import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tick_tac_toe/helper.dart';
import 'package:tick_tac_toe/player_model.dart';
import 'package:tick_tac_toe/tick_tack_toe_notifier.dart';

class TickTackToePage extends StatefulWidget {
  const TickTackToePage({Key? key}) : super(key: key);

  @override
  State<TickTackToePage> createState() => _TickTackToePageState();
}

class _TickTackToePageState extends State<TickTackToePage> {
  static const countMatrix = 3;
  static const double size = 92;

  String lastMove = Player.none;
  List<List<String>> matrix = [];
  @override
  void initState() {
    setEmptyFields();
    super.initState();
  }

  void setEmptyFields() => setState(() {
        matrix = List.generate(
            countMatrix,
            (_) => List.generate(
                  countMatrix,
                  (_) => Player.none,
                ));
      });
  Widget buildRow(int x) {
    final values = matrix[x];
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: Utils.modelBuilder(values, (y, value) => buildField(x, y)),
    );
  }

  Widget buildField(int x, int y) {
    final value = matrix[x][y];
    return Container(
      margin: const EdgeInsets.all(3),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(size, size),
            backgroundColor: Colors.white,
          ),
          onPressed: () => selectField(value, x, y),
          child: Text(
            value,
            style: GoogleFonts.aleo(
              fontSize: 24,
              fontStyle: FontStyle.italic,
              color: Colors.black,
            ),
          )),
    );
  }

  void selectField(String value, int x, int y) {
    if (value == Player.none) {
      final newValue = lastMove == Player.x ? Player.o : Player.x;
      setState(() {
        lastMove = newValue;
        matrix[x][y] = newValue;
      });

      if (isWinner(x, y)) {
        showEndDialog('Player $newValue Won');
      } else if (isEnd()) {
        showEndDialog('Undecided Game');
      }
    }
  }

  bool isEnd() =>
      matrix.every((value) => value.every((value) => value != Player.none));

  bool isWinner(int x, int y) {
    var col = 0, row = 0, diag = 0, rdiag = 0;
    final player = matrix[x][y];
    const n = countMatrix;
    for (int i = 0; i < n; i++) {
      if (matrix[x][i] == player) col++;
      if (matrix[i][y] == player) row++;
      if (matrix[i][i] == player) diag++;
      if (matrix[i][n - i - 1] == player) rdiag++;
    }
    return row == n || col == n || diag == n || rdiag == n;
  }

  Future showEndDialog(String title) => showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: const Text('Press to restart the game'),
          actions: [
            ElevatedButton(
                onPressed: () {
                  setEmptyFields();
                  Navigator.of(context).pop();
                },
                child: const Text('Restart')),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tick Tack Toe')),
      backgroundColor: Colors.blueGrey,
      body: Consumer(
        builder: (context, ref, child) {
          final gameState = ref.watch(gameNotifierProvider);
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: Utils.modelBuilder(matrix, (x, value) => buildRow(x)),
          );
        },
      ),
    );
  }
}
