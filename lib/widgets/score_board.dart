import 'package:flutter/material.dart';

class ScoreBoard extends StatelessWidget {
  final int scoreX;
  final int scoreO;
  final int scoreTies;
  final String currentTurn;
  final String playerSymbol;
  final bool vsAI;

  const ScoreBoard({
    super.key,
    required this.scoreX,
    required this.scoreO,
    required this.scoreTies,
    required this.currentTurn,
    required this.playerSymbol,
    required this.vsAI,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Theme colors
    final colorX = Colors.cyan.shade400;
    final colorO = Colors.pink.shade400;
    final colorTie = isDark ? Colors.grey.shade400 : Colors.grey.shade600;

    final nameX = vsAI ? (playerSymbol == 'X' ? 'You (X)' : 'AI (X)') : 'Player X';
    final nameO = vsAI ? (playerSymbol == 'O' ? 'You (O)' : 'AI (O)') : 'Player O';

    return Row(
      children: [
        // Player X Card
        Expanded(
          child: _buildScoreCard(
            context: context,
            title: nameX,
            value: scoreX,
            color: colorX,
            isActive: currentTurn == 'X',
          ),
        ),
        const SizedBox(width: 12),
        
        // Ties Card
        Expanded(
          child: _buildScoreCard(
            context: context,
            title: 'Ties',
            value: scoreTies,
            color: colorTie,
            isActive: false,
          ),
        ),
        const SizedBox(width: 12),
        
        // Player O Card
        Expanded(
          child: _buildScoreCard(
            context: context,
            title: nameO,
            value: scoreO,
            color: colorO,
            isActive: currentTurn == 'O',
          ),
        ),
      ],
    );
  }

  Widget _buildScoreCard({
    required BuildContext context,
    required String title,
    required int value,
    required Color color,
    required bool isActive,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: isDark
            ? (isActive ? color.withOpacity(0.15) : Colors.grey.shade900.withOpacity(0.5))
            : (isActive ? color.withOpacity(0.1) : Colors.grey.shade100),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isActive ? color : (isDark ? Colors.grey.shade800 : Colors.grey.shade300),
          width: isActive ? 2.5 : 1,
        ),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: color.withOpacity(0.4),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ]
            : [],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
              color: isActive
                  ? color
                  : (isDark ? Colors.grey.shade400 : Colors.grey.shade600),
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: Text(
              '$value',
              key: ValueKey<int>(value),
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.grey.shade800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
