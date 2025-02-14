import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart'; // For evaluating expressions

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _expression = "";
  String _result = "";

  // List of buttons
  final List<String> buttons = [
    "C", "DEL", "%", "/",
    "7", "8", "9", "*",
    "4", "5", "6", "-",
    "1", "2", "3", "+",
    "0", ".", "ANS", "="
  ];

  // Function to handle button presses
  void _onButtonPressed(String buttonText) {
    setState(() {
      if (buttonText == "C") {
        _expression = "";
        _result = "";
      } else if (buttonText == "DEL") {
        if (_expression.isNotEmpty) {
          _expression = _expression.substring(0, _expression.length - 1);
        }
      } else if (buttonText == "=") {
        _calculateResult();
      } else if (buttonText == "ANS") {
        _expression += _result;
      } else {
        _expression += buttonText;
      }
    });
  }

  // Function to evaluate the expression
  void _calculateResult() {
    try {
      Parser p = Parser();
      Expression exp = p.parse(_expression);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      _result = eval.toString();
    } catch (e) {
      _result = "Error";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[200],
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              alignment: Alignment.centerRight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(child: Text("Created by Erox 👻 ", style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),)),
                  Text(
                    _expression,
                    style: const TextStyle(fontSize: 32, color: Colors.black),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _result,
                    style: const TextStyle(fontSize: 40, color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: buttons.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
              ),
              itemBuilder: (context, index) {
                return CalculatorButton(
                  text: buttons[index],
                  onPressed: () => _onButtonPressed(buttons[index]),
                  isOperator: _isOperator(buttons[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Function to check if a button is an operator
  bool _isOperator(String x) {
    return ["%", "/", "*", "-", "+", "="].contains(x);
  }
}

// Custom Button Widget
class CalculatorButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isOperator;

  const CalculatorButton({super.key, 
    required this.text,
    required this.onPressed,
    required this.isOperator,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isOperator ? Colors.deepPurple : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 24,
              color: isOperator ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}