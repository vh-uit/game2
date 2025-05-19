import 'package:flame/components.dart';
import 'player_count_selector.dart';
import 'hud_button.dart';

/// The main menu screen for the game.
///
/// Provides buttons to start the game or open the options screen.
class MainMenuScreen extends Component with HasGameReference {
  /// Callback when the start button is pressed.
  final void Function(int playerCount)? onStart;

  /// Callback when the options button is pressed.
  final void Function()? onOptions;

  int _selectedPlayerCount = 1;

  MainMenuScreen({this.onStart, this.onOptions});

  /// Loads the main menu and adds menu buttons as children.
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final double buttonWidth = 250; // Slightly wider buttons
    final double buttonHeight = 70; // Slightly taller buttons
    final double spacing = 30; // Reduced spacing slightly

    // Center buttons on the screen
    final screenSize = game.size;
    final centerX = (screenSize.x - buttonWidth) / 2;
    final totalHeight = buttonHeight * 3 + spacing * 2;
    final startY = (screenSize.y - totalHeight) / 2;

    // Player count selector
    add(PlayerCountSelector(
      position: Vector2(centerX, startY),
      size: Vector2(buttonWidth, buttonHeight),
      initialCount: _selectedPlayerCount,
      onChanged: (count) {
        _selectedPlayerCount = count;
      },
    ));

    add(
      HudButton(
        label: 'Start Game',
        onPressed: () => onStart?.call(_selectedPlayerCount),
        position: Vector2(centerX, startY + buttonHeight + spacing),
        size: Vector2(buttonWidth, buttonHeight), // Pass size to button
      ),
    );

    add(
      HudButton(
        label: 'Options',
        onPressed: onOptions,
        position: Vector2(centerX, startY + (buttonHeight + spacing) * 2),
        size: Vector2(buttonWidth, buttonHeight), // Pass size to button
      ),
    );
  }
}
