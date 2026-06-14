import 'package:flutter/material.dart';
import '../models/game_model.dart';
import 'game_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  GameMode _gameMode = GameMode.vsAI;
  Difficulty _difficulty = Difficulty.medium;
  String _playerSymbol = 'X';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorX = Colors.cyan.shade400;
    final colorO = Colors.pink.shade400;

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
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                // App Logo / Title
                _buildHeader(isDark),
                const SizedBox(height: 40),

                // Game Mode Selector
                _buildSectionTitle('Select Mode', isDark),
                const SizedBox(height: 12),
                _buildGameModeSelector(isDark),
                const SizedBox(height: 28),

                // Symbol Selector (Only relevant or shown if vs AI or just as a general preference)
                _buildSectionTitle(
                  _gameMode == GameMode.vsAI ? 'Choose Your Side' : 'Player 1 Side',
                  isDark,
                ),
                const SizedBox(height: 12),
                _buildSymbolSelector(colorX, colorO, isDark),
                const SizedBox(height: 28),

                // Difficulty Selector (Only show if vs AI)
                AnimatedSize(
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeInOut,
                  child: _gameMode == GameMode.vsAI
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _buildSectionTitle('AI Difficulty', isDark),
                            const SizedBox(height: 12),
                            _buildDifficultySelector(isDark),
                            const SizedBox(height: 40),
                          ],
                        )
                      : const SizedBox(height: 12),
                ),

                // Start Action Button
                _buildStartButton(isDark),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.close, size: 48, color: Colors.cyan.shade400),
            const SizedBox(width: 8),
            Icon(Icons.radio_button_unchecked, size: 40, color: Colors.pink.shade400),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          'TIC TAC TOE',
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            letterSpacing: 3,
            color: isDark ? Colors.white : Colors.grey.shade900,
            shadows: isDark
                ? [
                    BoxShadow(
                      color: Colors.cyan.shade400.withOpacity(0.5),
                      blurRadius: 15,
                    ),
                  ]
                : [],
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'A Premium Neon Experience',
          style: TextStyle(
            fontSize: 14,
            color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
        color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
      ),
    );
  }

  Widget _buildGameModeSelector(bool isDark) {
    return Row(
      children: [
        Expanded(
          child: _buildModeButton(
            title: 'vs AI',
            subtitle: 'Challenge Computer',
            icon: Icons.computer,
            isSelected: _gameMode == GameMode.vsAI,
            onTap: () => setState(() => _gameMode = GameMode.vsAI),
            isDark: isDark,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _buildModeButton(
            title: 'Pass & Play',
            subtitle: 'Local Multiplayer',
            icon: Icons.people_outline,
            isSelected: _gameMode == GameMode.vsPlayer,
            onTap: () => setState(() => _gameMode = GameMode.vsPlayer),
            isDark: isDark,
          ),
        ),
      ],
    );
  }

  Widget _buildModeButton({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    final activeColor = Colors.cyan.shade400;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        decoration: BoxDecoration(
          color: isDark
              ? (isSelected ? activeColor.withOpacity(0.12) : Colors.grey.shade900.withOpacity(0.5))
              : (isSelected ? activeColor.withOpacity(0.08) : Colors.white),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? activeColor
                : (isDark ? Colors.grey.shade800 : Colors.grey.shade300),
            width: isSelected ? 2.0 : 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: activeColor.withOpacity(0.3),
                    blurRadius: 10,
                  ),
                ]
              : [],
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 28,
              color: isSelected ? activeColor : (isDark ? Colors.grey.shade400 : Colors.grey.shade600),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isSelected ? (isDark ? Colors.white : activeColor) : (isDark ? Colors.grey.shade300 : Colors.grey.shade800),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 11,
                color: isDark ? Colors.grey.shade500 : Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSymbolSelector(Color colorX, Color colorO, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSymbolCard(
          symbol: 'X',
          color: colorX,
          isSelected: _playerSymbol == 'X',
          onTap: () => setState(() => _playerSymbol = 'X'),
          icon: Icons.close,
          isDark: isDark,
        ),
        const SizedBox(width: 28),
        _buildSymbolCard(
          symbol: 'O',
          color: colorO,
          isSelected: _playerSymbol == 'O',
          onTap: () => setState(() => _playerSymbol = 'O'),
          icon: Icons.radio_button_unchecked,
          isDark: isDark,
        ),
      ],
    );
  }

  Widget _buildSymbolCard({
    required String symbol,
    required Color color,
    required bool isSelected,
    required VoidCallback onTap,
    required IconData icon,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: isDark
              ? (isSelected ? color.withOpacity(0.12) : Colors.grey.shade900.withOpacity(0.5))
              : (isSelected ? color.withOpacity(0.08) : Colors.white),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? color : (isDark ? Colors.grey.shade800 : Colors.grey.shade300),
            width: isSelected ? 2.5 : 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.35),
                    blurRadius: 12,
                  ),
                ]
              : [],
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 44,
                color: isSelected ? color : (isDark ? Colors.grey.shade500 : Colors.grey.shade600),
              ),
              const SizedBox(height: 4),
              Text(
                'Play as $symbol',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDifficultySelector(bool isDark) {
    final difficulties = [Difficulty.easy, Difficulty.medium, Difficulty.hard];
    final activeColor = Colors.purple.shade400;

    return Row(
      children: difficulties.map((diff) {
        final isSelected = _difficulty == diff;
        String name = 'Easy';
        IconData icon = Icons.child_care;
        if (diff == Difficulty.medium) {
          name = 'Medium';
          icon = Icons.psychology;
        } else if (diff == Difficulty.hard) {
          name = 'Hard';
          icon = Icons.bolt;
        }

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: GestureDetector(
              onTap: () => setState(() => _difficulty = diff),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isDark
                      ? (isSelected ? activeColor.withOpacity(0.15) : Colors.grey.shade900.withOpacity(0.5))
                      : (isSelected ? activeColor.withOpacity(0.08) : Colors.white),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected
                        ? activeColor
                        : (isDark ? Colors.grey.shade800 : Colors.grey.shade300),
                    width: isSelected ? 2.0 : 1.5,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      icon,
                      size: 20,
                      color: isSelected ? activeColor : (isDark ? Colors.grey.shade400 : Colors.grey.shade600),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isDark ? Colors.grey.shade200 : Colors.grey.shade800,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildStartButton(bool isDark) {
    final startColor = Colors.cyan.shade400;

    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: isDark
            ? [
                BoxShadow(
                  color: startColor.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ]
            : [],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: startColor,
          foregroundColor: const Color(0xFF070510),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GameScreen(
                gameMode: _gameMode,
                difficulty: _difficulty,
                playerSymbol: _playerSymbol,
              ),
            ),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'START BATTLE',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.play_arrow_rounded, size: 22),
          ],
        ),
      ),
    );
  }
}
