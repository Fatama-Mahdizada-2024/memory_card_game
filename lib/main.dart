import 'package:flutter/material.dart';
import 'package:memory_card_game/utils/game_logic.dart';
import 'package:memory_card_game/widgets/score_board.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Game _game = Game();
  int tries = 0;
  int score = 0;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    _game.initGame();
    setState(() {
      tries = 0;
      score = 0;
    });
  }

  void _showRestartDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Game Over'),
        content: const Text('Congratulations! Do you want to restart?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _initializeGame();
            },
            child: const Text('Restart'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screen_width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFe55870),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Center(
            child: Text(
              'Memory Game',
              style: TextStyle(
                fontSize: 48.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(
            height: 24.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              scoreBoard('Tries', '$tries'),
              scoreBoard('Score', '$score'),
            ],
          ),
          SizedBox(
            height: screen_width,
            width: screen_width,
            child: GridView.builder(
              itemCount: _game.gameImg!.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
              ),
              padding: const EdgeInsets.all(16.0),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    print(_game.cards_list[index]);
                    setState(() {
                      tries++;
                      _game.gameImg![index] = _game.cards_list[index];
                      _game.matchCheck.add({index: _game.cards_list[index]});
                    });
                    if (_game.matchCheck.length == 2) {
                      if (_game.matchCheck[0].values.first ==
                          _game.matchCheck[1].values.first) {
                        print('true');
                        score += 100;
                        _game.matchCheck.clear();
                        // Check if the game is completed
                        if (score == (_game.cards_list.length ~/ 2) * 100) {
                          _showRestartDialog();
                        }
                      } else {
                        print(false);
                        Future.delayed(const Duration(milliseconds: 500), () {
                          setState(() {
                            _game.gameImg![_game.matchCheck[0].keys.first] =
                                _game.hiddenCardpath;
                            _game.gameImg![_game.matchCheck[1].keys.first] =
                                _game.hiddenCardpath;
                            _game.matchCheck.clear();
                          });
                        });
                      }
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFB46A),
                      borderRadius: BorderRadius.circular(8.0),
                      image: DecorationImage(
                        image: AssetImage(_game.gameImg![index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
