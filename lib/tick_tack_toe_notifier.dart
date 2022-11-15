import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tick_tac_toe/player_model.dart';

class GameNotifier extends ChangeNotifier {
  static const countMatrix = 3;
  final double _size = 92;
  double get size => _size;

  bool _showEndDialog = false;
  bool get showEndDialog => _showEndDialog;

  String lastMove = Player.none;
  List<List<String>> _matrix = [];
  List<List<String>> get matrix => _matrix;

  void setEmptyFields() {
    _matrix = List.generate(
        countMatrix,
        (_) => List.generate(
              countMatrix,
              (_) => Player.none,
            ));
    notifyListeners();
  }

  void selectField(String value, int x, int y) {
    if (value == Player.none) {
      final newValue = lastMove == Player.x ? Player.o : Player.x;
      lastMove = newValue;
      _matrix[x][y] = newValue;

      // if (isWinner(x, y)) {
      //   showEndDialog('Player $newValue Won');
      // } else if (isEnd()) {
      //   showEndDialog('Undecided Game');
      // }
    }
  }

  bool isEnd() =>
      _matrix.every((value) => value.every((value) => value != Player.none));

  bool isWinner(int x, int y) {
    var col = 0, row = 0, diag = 0, rdiag = 0;
    final player = _matrix[x][y];
    const n = countMatrix;
    for (int i = 0; i < n; i++) {
      if (_matrix[x][i] == player) col++;
      if (_matrix[i][y] == player) row++;
      if (_matrix[i][i] == player) diag++;
      if (_matrix[i][n - i - 1] == player) rdiag++;
    }
    return row == n || col == n || diag == n || rdiag == n;
  }
}

final gameNotifierProvider = ChangeNotifierProvider<GameNotifier>((ref) {
  return GameNotifier();
});
