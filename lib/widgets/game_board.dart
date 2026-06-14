import 'package:flutter/material.dart';

class GameBoard extends StatelessWidget {
  final List<String> board;
  final Function(int) onTap;
  final List<int>? winningLine;
  final bool isInteractive;

  const GameBoard({
    super.key,
    required this.board,
    required this.onTap,
    this.winningLine,
    required this.isInteractive,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 14.0,
          mainAxisSpacing: 14.0,
        ),
        itemCount: 9,
        itemBuilder: (context, index) {
          final isWinningCell = winningLine?.contains(index) ?? false;
          return _buildGridCell(context, index, isWinningCell);
        },
      ),
    );
  }

  Widget _buildGridCell(BuildContext context, int index, bool isWinningCell) {
    final symbol = board[index];
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Accents
    final colorX = Colors.cyan.shade400;
    final colorO = Colors.pink.shade400;

    // Glowing border color for winning cells
    Color? cellBorderColor;
    if (isWinningCell) {
      cellBorderColor = symbol == 'X' ? colorX : colorO;
    }

    return GestureDetector(
      onTap: (isInteractive && symbol.isEmpty) ? () => onTap(index) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: isWinningCell
              ? (symbol == 'X' ? colorX.withOpacity(0.25) : colorO.withOpacity(0.25))
              : (isDark ? Colors.grey.shade900.withOpacity(0.6) : Colors.grey.shade100),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isWinningCell
                ? cellBorderColor!
                : (isDark ? Colors.grey.shade800 : Colors.grey.shade300),
            width: isWinningCell ? 3 : 1.5,
          ),
          boxShadow: [
            if (isWinningCell)
              BoxShadow(
                color: (symbol == 'X' ? colorX : colorO).withOpacity(0.5),
                blurRadius: 12,
                spreadRadius: 2,
              )
            else if (isDark)
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 6,
                offset: const Offset(0, 4),
              )
            else
              BoxShadow(
                color: Colors.grey.shade300.withOpacity(0.5),
                blurRadius: 6,
                offset: const Offset(0, 4),
              )
          ],
        ),
        child: Center(
          child: AnimatedScale(
            scale: symbol.isEmpty ? 0.0 : 1.0,
            duration: const Duration(milliseconds: 400),
            curve: Curves.elasticOut,
            child: AnimatedRotation(
              turns: symbol.isEmpty ? -0.2 : 0.0,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOutBack,
              child: _buildSymbolWidget(symbol, colorX, colorO),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSymbolWidget(String symbol, Color colorX, Color colorO) {
    if (symbol == 'X') {
      return Icon(
        Icons.close,
        size: 54,
        color: colorX,
      );
    } else if (symbol == 'O') {
      return Icon(
        Icons.radio_button_unchecked,
        size: 48,
        color: colorO,
      );
    }
    return const SizedBox.shrink();
  }
}
