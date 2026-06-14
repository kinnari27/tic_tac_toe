import 'dart:math';
import '../models/game_model.dart';

class AiService {
  static const List<List<int>> _winningCombos = [
    [0, 1, 2], [3, 4, 5], [6, 7, 8], // Rows
    [0, 3, 6], [1, 4, 7], [2, 5, 8], // Columns
    [0, 4, 8], [2, 4, 6]             // Diagonals
  ];

  static int getBestMove(List<String> board, String aiSymbol, Difficulty difficulty) {
    final playerSymbol = aiSymbol == 'X' ? 'O' : 'X';

    switch (difficulty) {
      case Difficulty.easy:
        return _getRandomMove(board);
      case Difficulty.medium:
        return _getMediumMove(board, aiSymbol, playerSymbol);
      case Difficulty.hard:
        return _getMinimaxMove(board, aiSymbol, playerSymbol);
    }
  }

  // Easy Difficulty: Pure Random Moves
  static int _getRandomMove(List<String> board) {
    final emptyCells = _getEmptyCells(board);
    if (emptyCells.isEmpty) return -1;
    final random = Random();
    return emptyCells[random.nextInt(emptyCells.length)];
  }

  // Medium Difficulty: 
  // 1. Play winning move if available.
  // 2. Block player's winning move if available.
  // 3. Otherwise, 50% chance of playing minimax/best move, 50% chance of random.
  static int _getMediumMove(List<String> board, String aiSymbol, String playerSymbol) {
    // 1. Check for immediate AI win
    for (int cell in _getEmptyCells(board)) {
      List<String> tempBoard = List.from(board);
      tempBoard[cell] = aiSymbol;
      if (_checkWinner(tempBoard) == aiSymbol) {
        return cell;
      }
    }

    // 2. Check to block Player win
    for (int cell in _getEmptyCells(board)) {
      List<String> tempBoard = List.from(board);
      tempBoard[cell] = playerSymbol;
      if (_checkWinner(tempBoard) == playerSymbol) {
        return cell;
      }
    }

    // 3. 50/50 strategic move vs random move
    if (Random().nextBool()) {
      return _getMinimaxMove(board, aiSymbol, playerSymbol);
    } else {
      return _getRandomMove(board);
    }
  }

  // Hard Difficulty: Perfect Minimax
  static int _getMinimaxMove(List<String> board, String aiSymbol, String playerSymbol) {
    int bestScore = -1000;
    int bestMove = -1;

    for (int cell in _getEmptyCells(board)) {
      List<String> tempBoard = List.from(board);
      tempBoard[cell] = aiSymbol;
      
      // AI is maximizing player, so next turn is Player (minimizing player)
      int score = _minimax(tempBoard, 0, false, aiSymbol, playerSymbol);
      
      if (score > bestScore) {
        bestScore = score;
        bestMove = cell;
      }
    }
    return bestMove;
  }

  static int _minimax(
    List<String> board,
    int depth,
    bool isMaximizing,
    String aiSymbol,
    String playerSymbol,
  ) {
    String winner = _checkWinner(board);
    if (winner == aiSymbol) return 10 - depth;
    if (winner == playerSymbol) return depth - 10;
    if (_getEmptyCells(board).isEmpty) return 0;

    if (isMaximizing) {
      int bestScore = -1000;
      for (int cell in _getEmptyCells(board)) {
        List<String> tempBoard = List.from(board);
        tempBoard[cell] = aiSymbol;
        int score = _minimax(tempBoard, depth + 1, false, aiSymbol, playerSymbol);
        bestScore = max(bestScore, score);
      }
      return bestScore;
    } else {
      int bestScore = 1000;
      for (int cell in _getEmptyCells(board)) {
        List<String> tempBoard = List.from(board);
        tempBoard[cell] = playerSymbol;
        int score = _minimax(tempBoard, depth + 1, true, aiSymbol, playerSymbol);
        bestScore = min(bestScore, score);
      }
      return bestScore;
    }
  }

  static List<int> _getEmptyCells(List<String> board) {
    List<int> cells = [];
    for (int i = 0; i < board.length; i++) {
      if (board[i] == '') {
        cells.add(i);
      }
    }
    return cells;
  }

  static String _checkWinner(List<String> board) {
    for (var combo in _winningCombos) {
      if (board[combo[0]] != '' &&
          board[combo[0]] == board[combo[1]] &&
          board[combo[0]] == board[combo[2]]) {
        return board[combo[0]];
      }
    }
    return '';
  }

  // Returns winning line indices if a winner exists
  static List<int>? getWinningLine(List<String> board) {
    for (var combo in _winningCombos) {
      if (board[combo[0]] != '' &&
          board[combo[0]] == board[combo[1]] &&
          board[combo[0]] == board[combo[2]]) {
        return combo;
      }
    }
    return null;
  }
}
