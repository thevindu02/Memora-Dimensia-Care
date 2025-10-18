import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../constants/color_constants.dart';
import 'alerts/all.dart';
import 'board_style.dart';
import 'splash_screen_page.dart';
import 'styles.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String versionNumber = '2.4.1';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sudoku',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Styles.primaryColor),
      home: const SplashScreenPage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  bool firstRun = true;
  bool gameOver = false;
  int timesCalled = 0;
  bool isButtonDisabled = false;
  bool isFABDisabled = false;
  late List<List<List<int>>> gameList;
  late List<List<int>> game;
  late List<List<int>> gameCopy;
  late List<List<int>> gameSolved;
  static String? currentDifficultyLevel;
  static String? currentTheme;
  static String? currentAccentColor;
  static String platform = () {
    if (kIsWeb) {
      return 'web-${defaultTargetPlatform.toString().replaceFirst("TargetPlatform.", "").toLowerCase()}';
    } else {
      return defaultTargetPlatform
          .toString()
          .replaceFirst("TargetPlatform.", "")
          .toLowerCase();
    }
  }();
  static bool isDesktop = ['windows', 'linux', 'macos'].contains(platform);

  @override
  void initState() {
    super.initState();
    getPrefs().whenComplete(() {
      if (currentDifficultyLevel == null) {
        currentDifficultyLevel = 'easy';
        setPrefs('currentDifficultyLevel');
      }
      if (currentTheme == null) {
        if (MediaQuery.maybeOf(context)?.platformBrightness != null) {
          currentTheme =
              MediaQuery.of(context).platformBrightness == Brightness.light
              ? 'light'
              : 'dark';
        } else {
          currentTheme = 'dark';
        }
        setPrefs('currentTheme');
      }
      if (currentAccentColor == null) {
        currentAccentColor = 'Blue';
        setPrefs('currentAccentColor');
      }
      newGame(currentDifficultyLevel!);
      changeTheme('set');
      changeAccentColor(currentAccentColor!, true);
    });
  }

  Future<void> getPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      currentDifficultyLevel = prefs.getString('currentDifficultyLevel');
      currentTheme = prefs.getString('currentTheme');
      currentAccentColor = prefs.getString('currentAccentColor');
    });
  }

  setPrefs(String property) async {
    final prefs = await SharedPreferences.getInstance();
    if (property == 'currentDifficultyLevel') {
      prefs.setString('currentDifficultyLevel', currentDifficultyLevel!);
    } else if (property == 'currentTheme') {
      prefs.setString('currentTheme', currentTheme!);
    } else if (property == 'currentAccentColor') {
      prefs.setString('currentAccentColor', currentAccentColor!);
    }
  }

  void changeTheme(String mode) {
    setState(() {
      if (currentTheme == 'light') {
        if (mode == 'switch') {
          Styles.primaryBackgroundColor = Styles.darkGrey;
          Styles.secondaryBackgroundColor = Styles.grey;
          Styles.foregroundColor = Styles.white;
          currentTheme = 'dark';
        } else if (mode == 'set') {
          Styles.primaryBackgroundColor = Styles.white;
          Styles.secondaryBackgroundColor = Styles.white;
          Styles.foregroundColor = Styles.darkGrey;
        }
      } else if (currentTheme == 'dark') {
        if (mode == 'switch') {
          Styles.primaryBackgroundColor = Styles.white;
          Styles.secondaryBackgroundColor = Styles.white;
          Styles.foregroundColor = Styles.darkGrey;
          currentTheme = 'light';
        } else if (mode == 'set') {
          Styles.primaryBackgroundColor = Styles.darkGrey;
          Styles.secondaryBackgroundColor = Styles.grey;
          Styles.foregroundColor = Styles.white;
        }
      }
      setPrefs('currentTheme');
    });
  }

  void changeAccentColor(String color, [bool firstRun = false]) {
    setState(() {
      if (Styles.accentColors.keys.contains(color)) {
        Styles.primaryColor = Styles.accentColors[color]!;
      } else {
        currentAccentColor = 'Blue';
        Styles.primaryColor = Styles.accentColors[color]!;
      }
      if (color == 'Red') {
        Styles.secondaryColor = Styles.orange;
      } else {
        Styles.secondaryColor = Styles.lightRed;
      }
      if (!firstRun) {
        setPrefs('currentAccentColor');
      }
    });
  }

  void checkResult() {
    print('Checking result...');
    try {
      if (_isSudokuSolved(game)) {
        print('Game won!');
        isButtonDisabled = !isButtonDisabled;
        gameOver = true;
        Timer(const Duration(milliseconds: 500), () {
          showDialog<void>(
            barrierDismissible: true,
            context: context,
            builder: (_) => const AlertGameOver(),
          ).whenComplete(() {
            if (AlertGameOver.newGame) {
              newGame();
              AlertGameOver.newGame = false;
            } else if (AlertGameOver.restartGame) {
              restartGame();
              AlertGameOver.restartGame = false;
            }
          });
        });
      } else {
        print('Game not yet solved or invalid solution');
        // Check if all cells are filled but solution is wrong
        bool allFilled = true;
        for (int i = 0; i < 9; i++) {
          for (int j = 0; j < 9; j++) {
            if (game[i][j] == 0) {
              allFilled = false;
              break;
            }
          }
          if (!allFilled) break;
        }

        if (allFilled) {
          print('All cells filled but solution is incorrect');
          // Show error message for incorrect solution
          showDialog<void>(
            barrierDismissible: true,
            context: context,
            builder: (_) => AlertDialog(
              title: Text(
                'Incorrect Solution',
                style: TextStyle(color: PatientColors.onSurface),
              ),
              content: Text(
                'The puzzle is not solved correctly. Please check your numbers.',
                style: TextStyle(color: PatientColors.onSurface),
              ),
              backgroundColor: PatientColors.surface,
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'OK',
                    style: TextStyle(color: PatientColors.primary),
                  ),
                ),
              ],
            ),
          );
        }
      }
    } catch (e) {
      print('Error checking result: $e');
      return;
    }
  }

  // Simple sudoku validation method
  bool _isSudokuSolved(List<List<int>> grid) {
    // Check if all cells are filled
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        if (grid[i][j] == 0) {
          print('Empty cell found at ($i, $j)');
          return false;
        }
      }
    }

    print('All cells filled, checking validity...');

    // Check rows
    for (int i = 0; i < 9; i++) {
      Set<int> seen = {};
      for (int j = 0; j < 9; j++) {
        if (grid[i][j] < 1 || grid[i][j] > 9 || !seen.add(grid[i][j])) {
          print('Row $i validation failed');
          return false;
        }
      }
    }

    // Check columns
    for (int j = 0; j < 9; j++) {
      Set<int> seen = {};
      for (int i = 0; i < 9; i++) {
        if (grid[i][j] < 1 || grid[i][j] > 9 || !seen.add(grid[i][j])) {
          print('Column $j validation failed');
          return false;
        }
      }
    }

    // Check 3x3 boxes
    for (int box = 0; box < 9; box++) {
      Set<int> seen = {};
      for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
          int row = (box ~/ 3) * 3 + i;
          int col = (box % 3) * 3 + j;
          if (grid[row][col] < 1 ||
              grid[row][col] > 9 ||
              !seen.add(grid[row][col])) {
            print('Box $box validation failed');
            return false;
          }
        }
      }
    }

    print('Sudoku is solved correctly!');
    return true;
  }

  static Future<List<List<List<int>>>> getNewGame([
    String difficulty = 'easy',
  ]) async {
    int emptySquares;
    switch (difficulty) {
      case 'test':
        {
          emptySquares = 1; // Only 1 empty square for easy testing
        }
        break;
      case 'beginner':
        {
          emptySquares = 18;
        }
        break;
      case 'easy':
        {
          emptySquares = 27;
        }
        break;
      case 'medium':
        {
          emptySquares = 36;
        }
        break;
      case 'hard':
        {
          emptySquares = 54;
        }
        break;
      default:
        {
          emptySquares = 27;
        }
        break;
    }

    // Generate a simple sudoku puzzle
    List<List<int>> completed = _generateCompletedSudoku();
    List<List<int>> puzzle = _createPuzzle(completed, emptySquares);

    print('Generated puzzle with $emptySquares empty squares');
    return [puzzle, completed];
  }

  // Simple sudoku generation - creates a basic valid sudoku
  static List<List<int>> _generateCompletedSudoku() {
    // Base valid sudoku pattern
    List<List<int>> base = [
      [5, 3, 4, 6, 7, 8, 9, 1, 2],
      [6, 7, 2, 1, 9, 5, 3, 4, 8],
      [1, 9, 8, 3, 4, 2, 5, 6, 7],
      [8, 5, 9, 7, 6, 1, 4, 2, 3],
      [4, 2, 6, 8, 5, 3, 7, 9, 1],
      [7, 1, 3, 9, 2, 4, 8, 5, 6],
      [9, 6, 1, 5, 3, 7, 2, 8, 4],
      [2, 8, 7, 4, 1, 9, 6, 3, 5],
      [3, 4, 5, 2, 8, 6, 1, 7, 9],
    ];

    // Shuffle the solution to create variety
    Random random = Random();

    // Randomly swap some numbers
    for (int i = 0; i < 10; i++) {
      int num1 = random.nextInt(9) + 1;
      int num2 = random.nextInt(9) + 1;
      if (num1 != num2) {
        _swapNumbers(base, num1, num2);
      }
    }

    return base.map((row) => [...row]).toList();
  }

  static void _swapNumbers(List<List<int>> grid, int num1, int num2) {
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        if (grid[i][j] == num1) {
          grid[i][j] = num2;
        } else if (grid[i][j] == num2) {
          grid[i][j] = num1;
        }
      }
    }
  }

  static List<List<int>> _createPuzzle(
    List<List<int>> completed,
    int emptySquares,
  ) {
    List<List<int>> puzzle = completed.map((row) => [...row]).toList();
    Random random = Random();

    int removed = 0;
    while (removed < emptySquares) {
      int row = random.nextInt(9);
      int col = random.nextInt(9);

      if (puzzle[row][col] != 0) {
        puzzle[row][col] = 0;
        removed++;
      }
    }

    return puzzle;
  }

  static List<List<int>> copyGrid(List<List<int>> grid) {
    return grid.map((row) => [...row]).toList();
  }

  void setGame(int mode, [String difficulty = 'easy']) async {
    if (mode == 1) {
      // Create proper independent lists for each row
      game = List.generate(9, (index) => List.filled(9, 0));
      gameCopy = List.generate(9, (index) => List.filled(9, 0));
      gameSolved = List.generate(9, (index) => List.filled(9, 0));
    } else {
      gameList = await getNewGame(difficulty);
      game = gameList[0];
      gameCopy = copyGrid(game);
      gameSolved = gameList[1];
    }
  }

  void showSolution() {
    setState(() {
      game = copyGrid(gameSolved);
      isButtonDisabled = !isButtonDisabled
          ? !isButtonDisabled
          : isButtonDisabled;
      gameOver = true;
    });
  }

  void newGame([String difficulty = 'easy']) {
    setState(() {
      isFABDisabled = !isFABDisabled;
    });
    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        setGame(2, difficulty);
        isButtonDisabled = isButtonDisabled
            ? !isButtonDisabled
            : isButtonDisabled;
        gameOver = false;
        isFABDisabled = !isFABDisabled;
      });
    });
  }

  void restartGame() {
    setState(() {
      game = copyGrid(gameCopy);
      isButtonDisabled = isButtonDisabled
          ? !isButtonDisabled
          : isButtonDisabled;
      gameOver = false;
    });
  }

  List<SizedBox> createButtons() {
    if (firstRun) {
      setGame(1);
      firstRun = false;
    }

    List<SizedBox> buttonList = List<SizedBox>.filled(9, const SizedBox());
    for (var i = 0; i <= 8; i++) {
      var k = timesCalled;
      buttonList[i] = SizedBox(
        key: Key('grid-button-$k-$i'),
        width: buttonSize(),
        height: buttonSize(),
        child: TextButton(
          onPressed: isButtonDisabled || gameCopy[k][i] != 0
              ? null
              : () {
                  showDialog<void>(
                    barrierDismissible: true,
                    context: context,
                    builder: (_) => const AlertNumbersState(),
                  ).whenComplete(() {
                    callback([k, i], AlertNumbersState.number);
                    AlertNumbersState.number = null;
                  });
                },
          onLongPress: isButtonDisabled || gameCopy[k][i] != 0
              ? null
              : () => callback([k, i], 0),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              buttonColor(k, i),
            ),
            foregroundColor: MaterialStateProperty.resolveWith<Color>((
              Set<MaterialState> states,
            ) {
              if (states.contains(MaterialState.disabled)) {
                return gameCopy[k][i] == 0
                    ? emptyColor(gameOver)
                    : Styles.foregroundColor;
              }
              return game[k][i] == 0
                  ? buttonColor(k, i)
                  : Styles.secondaryColor;
            }),
            shape: MaterialStateProperty.all<OutlinedBorder>(
              RoundedRectangleBorder(borderRadius: buttonEdgeRadius(k, i)),
            ),
            side: MaterialStateProperty.all<BorderSide>(
              BorderSide(
                color: Styles.foregroundColor,
                width: 1,
                style: BorderStyle.solid,
              ),
            ),
          ),
          child: Text(
            game[k][i] != 0 ? game[k][i].toString() : ' ',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: buttonFontSize()),
          ),
        ),
      );
    }
    timesCalled++;
    if (timesCalled == 9) {
      timesCalled = 0;
    }
    return buttonList;
  }

  Row oneRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: createButtons(),
    );
  }

  List<Row> createRows() {
    List<Row> rowList = List<Row>.generate(9, (i) => oneRow());
    return rowList;
  }

  void callback(List<int> index, int? number) {
    setState(() {
      if (number == null) {
        return;
      } else if (number == 0) {
        game[index[0]][index[1]] = number;
      } else {
        game[index[0]][index[1]] = number;
        print('Number $number placed at (${index[0]}, ${index[1]})');
        // Check result after any number is placed
        Future.delayed(Duration(milliseconds: 100), () {
          checkResult();
        });
      }
    });
  }

  showOptionModalSheet(BuildContext context) {
    BuildContext outerContext = context;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Styles.secondaryBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      builder: (context) {
        final TextStyle customStyle = TextStyle(
          inherit: false,
          color: Styles.foregroundColor,
        );
        return Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.refresh, color: Styles.foregroundColor),
              title: Text('Restart Game', style: customStyle),
              onTap: () {
                Navigator.pop(context);
                Timer(const Duration(milliseconds: 200), () => restartGame());
              },
            ),
            ListTile(
              leading: Icon(Icons.add_rounded, color: Styles.foregroundColor),
              title: Text('New Game', style: customStyle),
              onTap: () {
                Navigator.pop(context);
                Timer(
                  const Duration(milliseconds: 200),
                  () => newGame(currentDifficultyLevel!),
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.lightbulb_outline_rounded,
                color: Styles.foregroundColor,
              ),
              title: Text('Show Solution', style: customStyle),
              onTap: () {
                Navigator.pop(context);
                Timer(const Duration(milliseconds: 200), () => showSolution());
              },
            ),
            ListTile(
              leading: Icon(
                Icons.build_outlined,
                color: Styles.foregroundColor,
              ),
              title: Text('Set Difficulty', style: customStyle),
              onTap: () {
                Navigator.pop(context);
                Timer(
                  const Duration(milliseconds: 300),
                  () =>
                      showDialog<void>(
                        barrierDismissible: true,
                        context: outerContext,
                        builder: (_) =>
                            AlertDifficultyState(currentDifficultyLevel!),
                      ).whenComplete(() {
                        if (AlertDifficultyState.difficulty != null) {
                          Timer(const Duration(milliseconds: 300), () {
                            newGame(AlertDifficultyState.difficulty ?? 'test');
                            currentDifficultyLevel =
                                AlertDifficultyState.difficulty;
                            AlertDifficultyState.difficulty = null;
                            setPrefs('currentDifficultyLevel');
                          });
                        }
                      }),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PatientColors.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56.0),
        child: AppBar(
          centerTitle: true,
          title: const Text(
            'Sudoku',
            style: TextStyle(
              color: PatientColors.onSurface,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: PatientColors.surface,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: PatientColors.onSurface),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      body: Builder(
        builder: (builder) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: createRows(),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Styles.primaryBackgroundColor,
        backgroundColor: isFABDisabled
            ? Styles.primaryColor[900]
            : Styles.primaryColor,
        onPressed: isFABDisabled ? null : () => showOptionModalSheet(context),
        child: const Icon(Icons.menu_rounded),
      ),
    );
  }
}
