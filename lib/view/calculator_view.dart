import 'package:flutter/material.dart';

class CalculatorView extends StatefulWidget {
  const CalculatorView({super.key});

  @override
  State<CalculatorView> createState() => _CalculatorViewState();
}

class _CalculatorViewState extends State<CalculatorView> {
  final _controller = TextEditingController();
  List<String> lstSymbols = [
    "C",
    "*",
    "/",
    "<-",
    "1",
    "2",
    "3",
    "+",
    "4",
    "5",
    "6",
    "-",
    "7",
    "8",
    "9",
    "*",
    "%",
    "0",
    ".",
    "=",
  ];

  final _key = GlobalKey<FormState>();
  int _num1 = 0;
  int _num2 = 0;
  String _operator = "";
  bool _isNewCalculation =
      false; // Flag to check if a new calculation has been performed

  // Function to handle button presses
  void _buttonPressed(String value) {
    setState(() {
      // Clear button
      if (value == "C") {
        _controller.text = "0";
        _num1 = 0;
        _num2 = 0;
        _operator = "";
        _isNewCalculation = false;
      }
      // Backspace button
      else if (value == "<-") {
        if (_controller.text.isNotEmpty && _controller.text != "0") {
          _controller.text =
              _controller.text.substring(0, _controller.text.length - 1);
          if (_controller.text.isEmpty) {
            _controller.text = "0";
          }
        }
      }
      // Operator buttons (+, -, *, /)
      else if (value == "+" || value == "-" || value == "*" || value == "/") {
        if (_controller.text.isNotEmpty && _controller.text != "0") {
          _num1 = int.parse(_controller.text);
          _operator = value;
          _controller.text = "0";
          _isNewCalculation = false; // Prepare for next number
        }
      }
      // Equal button
      else if (value == "=") {
        if (_operator.isNotEmpty && _controller.text.isNotEmpty) {
          _num2 = int.parse(_controller.text);

          switch (_operator) {
            case "+":
              _controller.text = (_num1 + _num2).toString();
              break;
            case "-":
              _controller.text = (_num1 - _num2).toString();
              break;
            case "*":
              _controller.text = (_num1 * _num2).toString();
              break;
            case "/":
              _controller.text =
                  _num2 != 0 ? (_num1 / _num2).toString() : "Error";
              break;
            case "%":
              _controller.text = (_num1 % _num2).toString();
              break;
          }

          // After calculating, the next number entered will be considered as the start of a new operation.
          _num1 = 0;
          _num2 = 0;
          _operator = "";
          _isNewCalculation =
              true; // Flag to indicate that a new calculation should start
        }
      }
      // Other buttons (numbers, dot, etc.)
      else {
        if (_controller.text == "0" || _isNewCalculation) {
          _controller.text =
              value; // Reset the display if it's a new calculation
          _isNewCalculation =
              false; // Reset the flag after entering the new number
        } else {
          _controller.text += value; // Append the value to the current input
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calculator App"),
      ),
      body: Column(
        children: [
          // Display area (using controller)
          Container(
            padding: const EdgeInsets.all(12.0),
            alignment: Alignment.centerRight,
            child: TextField(
              controller: _controller,
              enabled: false,
              style: const TextStyle(
                fontSize: 36.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.right,
              decoration: const InputDecoration(border: InputBorder.none),
            ),
          ),
          const SizedBox(height: 10),
          // Buttons grid
          Expanded(
            child: GridView.count(
              crossAxisCount: 4, // 4 buttons per row
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              children: lstSymbols.map((String button) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(20.0),
                    backgroundColor: Colors.grey[300],
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    _buttonPressed(button);
                  },
                  child: Text(
                    button,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
