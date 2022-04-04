import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'colors.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SimpleCalculator(),
    );
  }
}

class SimpleCalculator extends StatefulWidget {
  @override
  _SimpleCalculatorState createState() => _SimpleCalculatorState();
}

class _SimpleCalculatorState extends State<SimpleCalculator> {

  bool daySelected = true;
  bool nightSelected = false;
  Color dayIconColor = Colors.black;
  Color nightIconColor = Colors.grey;

  Color backgroundColor = Colors.white;
  Color fontColor = Colors.black;
  Color panelColor = Colors.white;
  Color buttonColor = Colors.white;
  Color switchBackgroundColor = Colors.white;
  Color switchBorderColor = Colors.white;

  String equation = "0";
  String expression = "";
  String result = "0";
  double equationFontSize = 38.0;
  double resultFontSize = 48.0;

  buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'C') {
        equation = '0';
        result = '0';
        equationFontSize = 38.0;
        resultFontSize = 48.0;
      } else if (buttonText == '⁺∕₋') {
        if (equation.substring(0, 1) == '-') {
          equation = equation.substring(1, equation.length);
        } else {
          equation = '-' + equation;
        }
      } else if (buttonText == '⌫') {
        equationFontSize = 48.0;
        resultFontSize = 38.0;
        equation = equation.substring(0, equation.length - 1);
        if (equation == '') {
          equation = '0';
          equationFontSize = 38.0;
          resultFontSize = 48.0;
        }
      } else if (buttonText == '=') {
        equationFontSize = 38.0;
        resultFontSize = 48.0;

        expression = equation;

        expression = expression.replaceAll('×', '*');
        expression = expression.replaceAll('÷', '/');
        expression = expression.replaceAll('%', '* 0.01');

        try {
          Parser p = Parser();
          Expression exp = p.parse(expression);

          ContextModel cm = ContextModel();
          result = '${exp.evaluate(EvaluationType.REAL, cm)}';
          if (result.substring(result.length - 2, result.length) == '.0') {
            result = result.substring(0, result.length - 2);
          }
        } catch (e) {
          result = 'Error!';
        }
      } else {
        equationFontSize = 48.0;
        resultFontSize = 38.0;
        if (equation == '0') {
          equation = buttonText;
        } else {
          equation = equation + buttonText;
        }
      }
    });
  }

  Widget buildButton(
      String buttonText, double buttonHeight, Color fontColor) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.1 * buttonHeight,
      padding: EdgeInsets.all(0.0),
      margin: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
          color: buttonColor, borderRadius: BorderRadius.circular(28.0)),
      child: FlatButton(
        onPressed: () => buttonPressed(buttonText),
        child: Text(
          buttonText,
          style: TextStyle(
            fontSize: 30.0,
            fontWeight: FontWeight.w500,
            color: fontColor,
          ),
        ),
        padding: EdgeInsets.all(16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text("Simple Calculator", style: TextStyle(color: fontColor),),
      ),
      body: SafeArea(
        // left: false,
        // bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: GestureDetector(
                        child: Icon(
                          Icons.wb_sunny,
                          color: dayIconColor,
                        ),
                        onTap: () {
                          setState(() {
                            daySelected = true;
                            dayIconColor = daySelected ? Colors.black : Colors.grey;
                            nightIconColor = Colors.grey;

                            backgroundColor = BrightTheme().backgroundColor;
                            panelColor = BrightTheme().panelColor;
                            fontColor = BrightTheme().fontColor;
                            buttonColor = BrightTheme().buttonColor;
                            switchBorderColor = BrightTheme().switchBorderColor;
                            switchBackgroundColor = BrightTheme().switchBackgroundColor;
                          });
                        },
                      ),
                    ),
                    height: 40,
                    decoration: BoxDecoration(
                      color: switchBackgroundColor,
                      border: Border.all(
                        color: switchBorderColor,
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        bottomLeft: Radius.circular(30),
                      ),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: GestureDetector(
                        child: Icon(
                          Icons.nightlight_round,
                          color: nightIconColor,
                        ),
                        onTap: () {
                          setState(() {
                            nightSelected = true;
                            dayIconColor = Colors.grey;
                            nightIconColor = Colors.black;

                            backgroundColor = DarkTheme().backgroundColor;
                            panelColor = DarkTheme().panelColor;
                            fontColor = DarkTheme().fontColor;
                            buttonColor = DarkTheme().buttonColor;
                            switchBorderColor = DarkTheme().switchBorderColor;
                            switchBackgroundColor = DarkTheme().switchBackgroundColor;
                          });
                        },
                      ),
                    ),
                    height: 40,
                    decoration: BoxDecoration(
                      color: switchBackgroundColor,
                      border: Border.all(
                        color: switchBorderColor,
                      ),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded( //            Equation field
              child: Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
                child: AutoSizeText(
                  equation,
                  style: TextStyle(
                    fontSize: equationFontSize,
                    color: fontColor,
                  ),
                ),
              ),
            ),
            Container( //           Results field
              color: backgroundColor,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
              child: AutoSizeText(
                result,
                style: TextStyle(
                  fontSize: resultFontSize,
                  color: fontColor,
                ),
              ),
            ),
            Expanded(
              child: Divider(),
            ),
            Container(
              decoration: BoxDecoration(
                color: panelColor,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: Table(
                      children: [
                        TableRow(
                          children: [
                            buildButton('C', 1, Color(0xff275654)),
                            buildButton('⁺∕₋', 1, Color(0xff275654)),
                            buildButton('%', 1, Color(0xff275654)),
                          ],
                        ),
                        TableRow(
                          children: [
                            buildButton('7', 1, fontColor),
                            buildButton('8', 1, fontColor),
                            buildButton('9', 1, fontColor),
                          ],
                        ),
                        TableRow(
                          children: [
                            buildButton('4', 1, fontColor),
                            buildButton('5', 1, fontColor),
                            buildButton('6', 1, fontColor),
                          ],
                        ),
                        TableRow(
                          children: [
                            buildButton('1', 1, fontColor),
                            buildButton('2', 1, fontColor),
                            buildButton('3', 1, fontColor),
                          ],
                        ),
                        TableRow(
                          children: [
                            buildButton('⌫', 1, fontColor),
                            buildButton('0', 1, fontColor),
                            buildButton('.', 1, fontColor),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: Table(
                      children: [
                        TableRow(children: [
                          buildButton('÷', 1, Colors.red),
                        ]),
                        TableRow(children: [
                          buildButton('×', 1, Colors.red),
                        ]),
                        TableRow(children: [
                          buildButton('-', 1, Colors.red),
                        ]),
                        TableRow(children: [
                          buildButton('+', 1, Colors.red),
                        ]),
                        TableRow(children: [
                          buildButton('=', 1, Colors.red),
                        ]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
