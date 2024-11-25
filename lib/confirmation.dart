import 'package:flutter/material.dart';

class ConfirmationScreen extends StatelessWidget {
  final String destination;
  final String category;
  final String option;

  const ConfirmationScreen({required this.destination, required this.category, required this.option});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Confirmation')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Fade-in animation for confirmation text
            AnimatedOpacity(
              opacity: 1.0,
              duration: Duration(milliseconds: 500),
              child: Text('You have selected:', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 20),

            // Animated fade-in text for destination, category, and option
            AnimatedOpacity(
              opacity: 1.0,
              duration: Duration(milliseconds: 800),
              child: Column(
                children: [
                  Text('Destination: $destination', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 10),
                  Text('Category: $category', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 10),
                  Text('Option: $option', style: TextStyle(fontSize: 18)),
                ],
              ),
            ),
            SizedBox(height: 30),

            // Confirm Selection Button with scaling effect
            GestureDetector(
              onTapDown: (_) {
                // Trigger scale effect on button press
                _scaleButton(context, true);
              },
              onTapUp: (_) {
                // Reset scale effect after button press
                _scaleButton(context, false);
              },
              child: AnimatedScale(
                scale: 1.0,
                duration: Duration(milliseconds: 100),
                curve: Curves.easeInOut,
                child: ElevatedButton(
                  onPressed: () {
                    // Implement further confirmation logic if needed
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: Text('Confirmation'),
                        content: Text('Your selection has been confirmed!'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('OK'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Text('Confirm Selection'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Method to scale button on press for feedback
  void _scaleButton(BuildContext context, bool isPressed) {
    // You can use a stateful widget to manage button state if needed.
    // For now, this effect is just to show a visual feedback.
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(isPressed ? 'Button Pressed' : 'Button Released')));
  }
}