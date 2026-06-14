import 'package:flutter/material.dart';
import '../models/game_model.dart';
import '../services/ai_service.dart';
import '../widgets/game_board.dart';
import '../widgets/score_board.dart';
import '../widgets/winning_line.dart';

class GameScreen extends StatefulWidget {
  final GameMode gameMode;
  final Difficulty difficulty;
  final String playerSymbol;

  const GameScreen({
    super.key,
    required this.gameMode,
    required this.difficulty,
    required this.playerSymbol,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late GameState _state;
  bool _isAiThinking = false;

  @override
  void initState() {
    super.initState();
    _state = GameState.initial(
      gameMode: widget.gameMode,
      difficulty: widget.difficulty,
      playerSymbol: widget.playerSymbol,
    );

    // If AI is 'X' (goes first), trigger AI move
    if (_state.isAITurn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _makeAIMove();
      });
    }
  }

  void _handleCellTap(int index) {
    if (_state.status != GameStatus.playing ||
        _state.board[index].isNotEmpty ||
        _state.isAITurn ||
        _isAiThinking) {
      return;
    }

    _makeMove(index);
  }

  void _makeMove(int index) {
    setState(() {
      final newBoard = List<String>.from(_state.board);
      newBoard[index] = _state.currentTurn;

      final winningLine = AiService.getWinningLine(newBoard);
      if (winningLine != null) {
        // Active player wins
        final winner = _state.currentTurn;
        final scoreX = winner == 'X' ? _state.scoreX + 1 : _state.scoreX;
        final scoreO = winner == 'O' ? _state.scoreO + 1 : _state.scoreO;

        _state = _state.copyWith(
          board: newBoard,
          status: GameStatus.won,
          winningLine: winningLine,
          scoreX: scoreX,
          scoreO: scoreO,
        );
      } else if (!newBoard.contains('')) {
        // Draw
        _state = _state.copyWith(
          board: newBoard,
          status: GameStatus.draw,
          scoreTies: _state.scoreTies + 1,
        );
      } else {
        // Next player turn
        final nextTurn = _state.currentTurn == 'X' ? 'O' : 'X';
        _state = _state.copyWith(
          board: newBoard,
          currentTurn: nextTurn,
        );

        // If next turn is AI, schedule AI move
        if (_state.isAITurn) {
          _makeAIMove();
        }
      }
    });
  }

  Future<void> _makeAIMove() async {
    if (!mounted) return;
    setState(() {
      _isAiThinking = true;
    });

    // Add a natural-feeling delay so the AI "thinks"
    await Future.delayed(const Duration(milliseconds: 700));

    if (!mounted) return;

    final aiMove = AiService.getBestMove(
      _state.board,
      _state.currentTurn,
      _state.difficulty,
    );

    if (aiMove != -1) {
      setState(() {
        _isAiThinking = false;
      });
      _makeMove(aiMove);
    } else {
      setState(() {
        _isAiThinking = false;
      });
    }
  }

  void _resetBoard() {
    setState(() {
      _isAiThinking = false;
      _state = _state.copyWith(
        board: List.filled(9, ''),
        currentTurn: 'X', // 'X' always starts
        status: GameStatus.playing,
        clearWinningLine: true,
      );
    });

    if (_state.isAITurn) {
      _makeAIMove();
    }
  }

  void _resetScores() {
    setState(() {
      _state = _state.copyWith(
        scoreX: 0,
        scoreO: 0,
        scoreTies: 0,
      );
      _resetBoard();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [
                    const Color(0xFF0F0C20),
                    const Color(0xFF15102A),
                    const Color(0xFF070510)
                  ]
                : [
                    const Color(0xFFF5F7FA),
                    const Color(0xFFE4E8F0),
                  ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              children: [
                // Top Custom App Bar
                _buildAppBar(isDark),
                const SizedBox(height: 16),

                // Score Board
                ScoreBoard(
                  scoreX: _state.scoreX,
                  scoreO: _state.scoreO,
                  scoreTies: _state.scoreTies,
                  currentTurn: _state.currentTurn,
                  playerSymbol: _state.playerSymbol,
                  vsAI: _state.gameMode == GameMode.vsAI,
                ),
                const Spacer(),

                // Status Indicator
                _buildStatusBanner(isDark),
                const SizedBox(height: 16),

                // 3x3 Game Board Grid
                Stack(
                  children: [
                    GameBoard(
                      board: _state.board,
                      onTap: _handleCellTap,
                      winningLine: _state.winningLine,
                      isInteractive: _state.status == GameStatus.playing &&
                          !_state.isAITurn &&
                          !_isAiThinking,
                    ),
                    if (_state.status == GameStatus.won && _state.winningLine != null)
                      Positioned.fill(
                        child: IgnorePointer(
                          child: WinningLine(
                            winningLine: _state.winningLine!,
                            winner: _state.board[_state.winningLine![0]],
                          ),
                        ),
                      ),
                  ],
                ),
                const Spacer(),

                // Game Controls
                _buildControls(isDark),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: isDark ? Colors.grey.shade400 : Colors.grey.shade800,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        Column(
          children: [
            Text(
              _state.gameMode == GameMode.vsAI ? 'VS COMPUTER' : 'PASS & PLAY',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              ),
            ),
            if (_state.gameMode == GameMode.vsAI)
              Text(
                'DIFFICULTY: ${_state.difficulty.name.toUpperCase()}',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                  color: _state.difficulty == Difficulty.easy
                      ? Colors.green.shade400
                      : _state.difficulty == Difficulty.medium
                          ? Colors.orange.shade400
                          : Colors.purple.shade400,
                ),
              ),
          ],
        ),
        IconButton(
          icon: Icon(
            Icons.refresh_rounded,
            color: isDark ? Colors.grey.shade400 : Colors.grey.shade800,
          ),
          tooltip: 'Reset Scores',
          onPressed: _resetScores,
        ),
      ],
    );
  }

  Widget _buildStatusBanner(bool isDark) {
    String message = '';
    Color color = isDark ? Colors.white : Colors.grey.shade900;
    bool showSpinner = false;

    if (_state.status == GameStatus.won) {
      final winner = _state.board[_state.winningLine![0]];
      final isAIWin = _state.gameMode == GameMode.vsAI && winner != _state.playerSymbol;
      
      if (_state.gameMode == GameMode.vsAI) {
        if (isAIWin) {
          message = 'Computer Wins!';
          color = Colors.pink.shade400;
        } else {
          message = 'You Win!';
          color = Colors.cyan.shade400;
        }
      } else {
        message = 'Player $winner Wins!';
        color = winner == 'X' ? Colors.cyan.shade400 : Colors.pink.shade400;
      }
    } else if (_state.status == GameStatus.draw) {
      message = "It's a Tie!";
      color = isDark ? Colors.grey.shade300 : Colors.grey.shade700;
    } else if (_isAiThinking) {
      message = 'Computer is thinking...';
      color = Colors.pink.shade400;
      showSpinner = true;
    } else {
      final turn = _state.currentTurn;
      if (_state.gameMode == GameMode.vsAI) {
        message = turn == _state.playerSymbol ? 'Your Turn' : 'Computer is thinking...';
        color = turn == _state.playerSymbol ? Colors.cyan.shade400 : Colors.pink.shade400;
      } else {
        message = "Player $turn's Turn";
        color = turn == 'X' ? Colors.cyan.shade400 : Colors.pink.shade400;
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (showSpinner) ...[
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          const SizedBox(width: 10),
        ],
        Text(
          message,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: color,
            letterSpacing: 0.5,
            shadows: isDark && _state.status != GameStatus.draw
                ? [
                    BoxShadow(
                      color: color.withOpacity(0.3),
                      blurRadius: 8,
                    )
                  ]
                : [],
          ),
        ),
      ],
    );
  }

  Widget _buildControls(bool isDark) {
    final activeColor = Colors.cyan.shade400;

    return Row(
      children: [
        Expanded(
          child: Container(
            height: 52,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                width: 1.5,
              ),
            ),
            child: TextButton(
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: _resetScores,
              child: Text(
                'RESET SCORE',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            height: 52,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: isDark
                  ? [
                      BoxShadow(
                        color: activeColor.withOpacity(0.25),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [],
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: activeColor,
                foregroundColor: const Color(0xFF070510),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              onPressed: _resetBoard,
              child: const Text(
                'PLAY AGAIN',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
