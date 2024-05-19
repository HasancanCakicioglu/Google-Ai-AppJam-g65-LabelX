import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labeling/Utility/showDialog.dart';
import 'package:labeling/components/brick.dart';
import 'dart:async';

import 'package:labeling/provider/cubit_heart/heart_cubit.dart';


class BrickBreakerGame extends StatefulWidget {
  @override
  _BrickBreakerGameState createState() => _BrickBreakerGameState();
}

class _BrickBreakerGameState extends State<BrickBreakerGame> with SingleTickerProviderStateMixin {
  double paddleX = 0.0;
  double paddleWidth = 100.0;
  double ballX = 0.0;
  double ballY = 0.0;
  double ballRadius = 10.0;
  double ballSpeedX = 4.5;
  double ballSpeedY = 4.5;
  double screenWidth = 0.0;
  double screenHeight = 0.0;
  Timer? _timer;
  List<Brick> bricks = [];
  bool isGameStarted = false; // Oyun durumu
  bool GameOver = false;

  @override
  void initState() {
    super.initState();
  }

  void _startGame() {
    if (context.read<HeartCubit>().getAliveHeartCount() > 0) {
      _createBricks();
      _timer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
        setState(() {
          _updateGame();
        });
      });
    } else {
      showHeartDialog(context);
    }
  }

  void _createBricks() {
    bricks.clear();
    double brickWidth = 75.0;
    double brickHeight = 20.0;
    int cols = (screenWidth / brickWidth).floor();
    int rows = 5;
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        double x = j * brickWidth;
        double y = i * brickHeight;
        bricks.add(Brick(x: x, y: y, width: brickWidth, height: brickHeight));
      }
    }
  }

  void _updateGame() {
    if (!isGameStarted) return; // Oyun başlamamışsa güncellemeyi durdur

    ballX += ballSpeedX;
    ballY += ballSpeedY;

    // Duvarlara çarpma
    if (ballX <= 0 || ballX >= screenWidth - ballRadius * 2) {
      ballSpeedX = -ballSpeedX;
    }
    if (ballY <= 0) {
      ballSpeedY = -ballSpeedY;
    }

    // Platforma çarpma
    if (ballY >= screenHeight - ballRadius * 2 - 50 && ballX >= paddleX && ballX <= paddleX + paddleWidth) {
      ballSpeedY = -ballSpeedY;
    }

    // Yere düşme
    if (ballY >= screenHeight - ballRadius * 2) {
      _timer?.cancel();
      GameOver = true;
      context.read<HeartCubit>().dead();
      _showGameOverDialog("Game Over");
    }

    // Bloklara çarpma
    for (var brick in bricks) {
      if (brick.isVisible &&
          ballX + ballRadius * 2 >= brick.x &&
          ballX <= brick.x + brick.width &&
          ballY + ballRadius * 2 >= brick.y &&
          ballY <= brick.y + brick.height) {
        ballSpeedY = -ballSpeedY;
        brick.isVisible = false;
      }
    }

    // Tüm bloklar yok oldu mu kontrol et
    if (bricks.every((brick) => !brick.isVisible)) {
      _timer?.cancel();
      _showGameOverDialog("You Win!");
    }
  }

  void _showGameOverDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(message),
          actions: [
            TextButton(
              child: const Text("Restart"),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  GameOver = false;
                  ballX = screenWidth / 2 - ballRadius;
                  ballY = screenHeight / 2 - ballRadius;
                  ballSpeedX = 4.5;
                  ballSpeedY = 4.5;
                  _createBricks();
                  isGameStarted = false; // Oyun başlangıcına döner
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int aliveHeartCount = context.read<HeartCubit>().getAliveHeartCount();
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: InkWell(
              onTap: () {
                if(context.read<HeartCubit>().getAliveHeartCount()==0){
                  showHeartDialog(context);
                }
              },
              child: Row(
                children: [
                  // Beyaz kalpler
                  for (int i = 0; i < 3 - aliveHeartCount; i++)
                    const Icon(
                      Icons.favorite_border,
                      color: Colors.white, // Boş kalpler beyaz olacak
                    ),
                  // Kırmızı kalpler
                  for (int i = 0; i < aliveHeartCount; i++)
                    const Icon(
                      Icons.favorite,
                      color: Colors.red, // Canlı kalpler kırmızı olacak
                    ),
                ],
              ),
            ),
          ),
        ],
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF0B132B),
        centerTitle: true,
        title: const Text(
          'Brick Breaker',
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: const Color(0xFFd9d9d9),
      body: LayoutBuilder(
        builder: (context, constraints) {
          screenWidth = constraints.maxWidth;
          screenHeight = constraints.maxHeight;
          if (ballX == 0 && ballY == 0) {
            ballX = screenWidth / 2 - ballRadius;
            ballY = screenHeight / 2 - ballRadius;
            _createBricks(); // İlk oluşturulmada blokları oluştur
          }
          return GestureDetector(
            onTap: () {
              if (!isGameStarted) {
                setState(() {
                  isGameStarted = true; // Oyun başlıyor
                  _startGame();
                });
              }
            },
            onHorizontalDragUpdate: (details) {
              if (isGameStarted) {
                setState(() {
                  paddleX += details.delta.dx;
                  if (paddleX < 0) {
                    paddleX = 0;
                  } else if (paddleX + paddleWidth > screenWidth) {
                    paddleX = screenWidth - paddleWidth;
                  }
                });
              }
            },
            child: Stack(
              children: [
                // Platform
                Positioned(
                  bottom: 30,
                  left: paddleX,
                  child: Container(
                    width: 89,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Color(0xFF36a652), // Platform rengi
                      borderRadius: BorderRadius.circular(10), // Sol alt köşe yuvarlaklığı
                    ),
                  ),
                ),

                // Top
                Positioned(
                  left: ballX,
                  top: ballY,
                  child: Container(
                    width: ballRadius * 2,
                    height: ballRadius * 2,
                    decoration: BoxDecoration(
                      color: Color(0xFFe84436),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3), // Gölge rengi
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                  ),
                ),
                // Bloklar
                for (var brick in bricks)
                  if (brick.isVisible)
                    Positioned(
                      left: brick.x,
                      top: brick.y + 20,
                      child: _buildBookBrick(brick.width, brick.height),
                    ),
                // Başlamak için tıklayın metni
                if (!isGameStarted)
                  Center(
                    child: Text(
                      "Başlamak için tıklayın",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,color: Colors.white,),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBookBrick(double width, double height) {
    return Container(
      width: 80,
      height: 20,
      child: Stack(
        children: [
          // Sol taraf
          Positioned(
            left: 6,
            top: 1,
            child: Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                color: Color(0xFF4584f0),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }


}