class Game {
  final String hiddenCardpath = 'assets/images/hidden.png';
  List<String>? gameImg;

  final List<String> cards_list = [
    'assets/images/circle.png',
    'assets/images/triangle.png',
    'assets/images/circle.png',
    'assets/images/heart.png',
    'assets/images/star.png',
    'assets/images/triangle.png',
    'assets/images/star.png',
    'assets/images/heart.png',
  ];

  List<Map<int, String>> matchCheck = [];

  final int carCount = 8;

  void initGame() {
    gameImg = List.generate(carCount, (index) => hiddenCardpath);
  }
}
