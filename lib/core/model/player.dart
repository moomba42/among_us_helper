import 'dart:ui';

enum Player {
  BROWN,
  RED,
  ORANGE,
  YELLOW,
  LIME,
  GREEN,
  CYAN,
  BLUE,
  PURPLE,
  PINK,
  WHITE,
  BLACK,
}

extension PlayerColor on Player {
  Color getColor() {
    switch (this) {
      case Player.BROWN:
        return Color(0xFF72491E);
      case Player.RED:
        return Color(0xFFC51111);
        break;
      case Player.ORANGE:
        return Color(0xFFEE7E0E);
        break;
      case Player.YELLOW:
        return Color(0xFFF5F558);
        break;
      case Player.LIME:
        return Color(0xFF50EF39);
        break;
      case Player.GREEN:
        return Color(0xFF127F2D);
        break;
      case Player.CYAN:
        return Color(0xFF39FEDB);
        break;
      case Player.BLUE:
        return Color(0xFF132FD2);
        break;
      case Player.PURPLE:
        return Color(0xFF6B30BC);
        break;
      case Player.PINK:
        return Color(0xFFED53B9);
        break;
      case Player.WHITE:
        return Color(0xFFD2DDEA);
        break;
      case Player.BLACK:
        return Color(0xFF3F484E);
        break;
      default:
        return Color(0xFFD2DDEA);
    }
  }
}
