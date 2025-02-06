/// A simple animation demo application that shows a movable square.
///
/// The application demonstrates basic animation concepts in Flutter,
/// including controlled movement and button state management.
library;

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

/// The root widget of the application.
///
/// Sets up the MaterialApp and the initial home screen.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MovingSquare(),
    );
  }
}

/// A widget that displays an animated square that can move left and right.
///
/// The square can be moved using two buttons and includes:
/// * Animated movement with a 1-second duration
/// * Boundary detection to prevent going off-screen
/// * Button state management based on position
class MovingSquare extends StatefulWidget {
  const MovingSquare({super.key});

  @override
  State<MovingSquare> createState() => _MovingSquareState();
}

/// The state for the [MovingSquare] widget.
///
/// Handles the animation and positioning logic for the moving square.
class _MovingSquareState extends State<MovingSquare>
    with SingleTickerProviderStateMixin {
  /// Controls the square's movement animation.
  late AnimationController _controller;

  /// Defines the square's position animation.
  late Animation<double> _animation;

  /// Indicates whether the square is currently in motion.
  bool _isMoving = false;

  /// The current position of the square (0.0 = left, 0.5 = center, 1.0 = right).
  double _position = 0.5;

  @override
  void initState() {
    super.initState();
    _setupAnimationController();
  }

  /// Initializes the animation controller and sets up status listeners.
  void _setupAnimationController() {
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _controller.addStatusListener(_handleAnimationStatus);
  }

  /// Handles the animation status changes.
  ///
  /// Updates the square's position when animation completes.
  void _handleAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      setState(() {
        _isMoving = false;
        _position = _animation.value;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Initiates the square's movement animation.
  ///
  /// [toRight] determines the direction of movement:
  /// * true moves the square to the right edge
  /// * false moves the square to the left edge
  void _moveSquare(bool toRight) {
    final targetPosition = toRight ? 1.0 : 0.0;

    setState(() {
      _isMoving = true;
      _animation = Tween<double>(
        begin: _position,
        end: targetPosition,
      ).animate(_controller);
    });

    _controller.reset();
    _controller.forward();
  }

  /// Determines if the square can move left.
  ///
  /// Returns true if the square is not at the left edge and not moving.
  bool _canMoveLeft() {
    return _position > 0.0 && !_isMoving;
  }

  /// Determines if the square can move right.
  ///
  /// Returns true if the square is not at the right edge and not moving.
  bool _canMoveRight() {
    return _position < 1.0 && !_isMoving;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 100,
            width: double.infinity,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final currentPosition =
                    _isMoving ? _animation.value : _position;

                return Stack(
                  children: [
                    Positioned(
                      left: (MediaQuery.of(context).size.width - 90) *
                              currentPosition +
                          20,
                      child: Container(
                        width: 50,
                        height: 50,
                        color: Colors.red,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _canMoveLeft() ? () => _moveSquare(false) : null,
                child: const Text('To Left'),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: _canMoveRight() ? () => _moveSquare(true) : null,
                child: const Text('To Right'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
