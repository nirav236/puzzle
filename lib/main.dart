import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<int> numbers;
  late bool gameStarted;

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    numbers = List<int>.generate(9, (index) => index + 1);
    numbers.shuffle();
    gameStarted = true;
  }

  void moveTile(int index) {
    if (!gameStarted) return;
    if (index != 8 && numbers[index + 1] == 9) {
      setState(() {
        numbers[index + 1] = numbers[index];
        numbers[index] = 9;
      });
    } else if (index != 0 && numbers[index - 1] == 9) {
      setState(() {
        numbers[index - 1] = numbers[index];
        numbers[index] = 9;
      });
    } else if (index >= 3 && numbers[index - 3] == 9) {
      setState(() {
        numbers[index - 3] = numbers[index];
        numbers[index] = 9;
      });
    } else if (index < 6 && numbers[index + 3] == 9) {
      setState(() {
        numbers[index + 3] = numbers[index];
        numbers[index] = 9;
      });
    }

    if (_isGameFinished()) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Congratulations!'),
            content: Text('You have solved the puzzle!'),
            actions: <Widget>[
              ElevatedButton(
                child: Text('Play Again'),
                onPressed: () {
                  startGame();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  bool _isGameFinished() {
    for (int i = 0; i < numbers.length; i++) {
      if (numbers[i] != i + 1) {
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Center(child: Text('Puzzle')),
      ),
      body: GridView.builder(
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemCount: 9,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              moveTile(index);
            },
            child: Container(
              color: Colors.blue,
              margin: EdgeInsets.all(4.0),
              child: Center(
                child: Text(
                  numbers[index] != 9 ? '${numbers[index]}' : '',
                  style: TextStyle(fontSize: 48.0, color: Colors.white),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
