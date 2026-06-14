enum GameMode { vsAI, vsPlayer }

enum Difficulty { easy, medium, hard }

enum GameStatus { playing, won, draw }

class GameState {
  final List<String> board; // 'X', 'O', or ''
  final String currentTurn; // 'X' or 'O'
  final GameMode gameMode;
  final Difficulty difficulty;
  final String playerSymbol; // Symbol of the human player ('X' or 'O') in vsAI mode
  final GameStatus status;
  final List<int>? winningLine; // e.g., [0, 1, 2]
  final int scoreX;
  final int scoreO;
  final int scoreTies;

  GameState({
    required this.board,
    required this.currentTurn,
    required this.gameMode,
    required this.difficulty,
    required this.playerSymbol,
    required this.status,
    this.winningLine,
    required this.scoreX,
    required this.scoreO,
    required this.scoreTies,
  });

  factory GameState.initial({
    GameMode gameMode = GameMode.vsAI,
    Difficulty difficulty = Difficulty.medium,
    String playerSymbol = 'X',
  }) {
    return GameState(
      board: List.filled(9, ''),
      currentTurn: 'X', // 'X' always starts
      gameMode: gameMode,
      difficulty: difficulty,
      playerSymbol: playerSymbol,
      status: GameStatus.playing,
      winningLine: null,
      scoreX: 0,
      scoreO: 0,
      scoreTies: 0,
    );
  }

  GameState copyWith({
    List<String>? board,
    String? currentTurn,
    GameMode? gameMode,
    Difficulty? difficulty,
    String? playerSymbol,
    GameStatus? status,
    List<int>? winningLine,
    bool clearWinningLine = false,
    int? scoreX,
    int? scoreO,
    int? scoreTies,
  }) {
    return GameState(
      board: board ?? this.board,
      currentTurn: currentTurn ?? this.currentTurn,
      gameMode: gameMode ?? this.gameMode,
      difficulty: difficulty ?? this.difficulty,
      playerSymbol: playerSymbol ?? this.playerSymbol,
      status: status ?? this.status,
      winningLine: clearWinningLine ? null : (winningLine ?? this.winningLine),
      scoreX: scoreX ?? this.scoreX,
      scoreO: scoreO ?? this.scoreO,
      scoreTies: scoreTies ?? this.scoreTies,
    );
  }

  bool get isAITurn {
    if (gameMode == GameMode.vsPlayer) return false;
    return currentTurn != playerSymbol;
  }
}
