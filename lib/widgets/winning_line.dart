import 'package:flutter/material.dart';

class WinningLine extends StatefulWidget {
  final List<int> winningLine;
  final String winner; // 'X' or 'O'

  const WinningLine({
    super.key,
    required this.winningLine,
    required this.winner,
  });

  @override
  State<WinningLine> createState() => _WinningLineState();
}

class _WinningLineState extends State<WinningLine>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutQuart,
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant WinningLine oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.winningLine != oldWidget.winningLine) {
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          painter: _LinePainter(
            winningLine: widget.winningLine,
            winner: widget.winner,
            progress: _animation.value,
          ),
          child: const SizedBox.expand(),
        );
      },
    );
  }
}

class _LinePainter extends CustomPainter {
  final List<int> winningLine;
  final String winner;
  final double progress;

  _LinePainter({
    required this.winningLine,
    required this.winner,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (winningLine.length < 3) return;

    final color = winner == 'X' ? Colors.cyan.shade400 : Colors.pink.shade400;

    // Calculate center coordinates for start and end cells
    final startIdx = winningLine[0];
    final endIdx = winningLine[2];

    final startCenter = _getCellCenter(startIdx, size);
    final endCenter = _getCellCenter(endIdx, size);

    // Calculate current animated end point
    final currentEnd = Offset(
      startCenter.dx + (endCenter.dx - startCenter.dx) * progress,
      startCenter.dy + (endCenter.dy - startCenter.dy) * progress,
    );

    // 1. Draw outer neon glow (thick, low opacity)
    final glowPaint = Paint()
      ..color = color.withOpacity(0.35)
      ..strokeWidth = 14.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawLine(startCenter, currentEnd, glowPaint);

    // 2. Draw core neon line (thinner, full opacity)
    final corePaint = Paint()
      ..color = color
      ..strokeWidth = 6.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawLine(startCenter, currentEnd, corePaint);
  }

  Offset _getCellCenter(int index, Size size) {
    final cellWidth = size.width / 3;
    final cellHeight = size.height / 3;

    final row = index ~/ 3;
    final col = index % 3;

    final x = (col + 0.5) * cellWidth;
    final y = (row + 0.5) * cellHeight;

    return Offset(x, y);
  }

  @override
  bool shouldRepaint(covariant _LinePainter oldDelegate) {
    return oldDelegate.winningLine != winningLine ||
        oldDelegate.winner != winner ||
        oldDelegate.progress != progress;
  }
}
