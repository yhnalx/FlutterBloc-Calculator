import 'package:cinamoroll_calculator/bloc/calculator/calculator_bloc.dart';
import 'package:cinamoroll_calculator/bloc/calculator/calculator_event.dart';
import 'package:cinamoroll_calculator/bloc/calculator/calculator_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyMelodyThemePage extends StatefulWidget {
  const MyMelodyThemePage({super.key});

  @override
  _MyMelodyThemePageState createState() => _MyMelodyThemePageState();
}

class _MyMelodyThemePageState extends State<MyMelodyThemePage> {
  final Map<String, Color> _buttonColors = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Image.asset(
              'assets/myMelody.jpg',
              fit: BoxFit.cover,
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: BlocBuilder<CalculatorBloc, CalculatorState>(
                builder: (context, state) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Display area
                      Container(
                        height: MediaQuery.of(context).size.height * 0.15,
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              offset: const Offset(0, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Text(
                          state.display,
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 211, 117, 148), 
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
            
                      // Calculator buttons
                      GridView.builder(
                        shrinkWrap: true,
                        itemCount: 20,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 12, 
                          mainAxisSpacing: 12,
                        ),
                        itemBuilder: (context, index) {
                          final buttons = [
                            'AC',
                            '%',
                            "DEL",
                            '÷',
                            '7',
                            '8',
                            '9',
                            'x',
                            '4',
                            '5',
                            '6',
                            '-',
                            '1',
                            '2',
                            '3',
                            '+',
                            '00',
                            '0',
                            '.',
                            '='
                          ];
                          final button = buttons[index];
            
                          final textColor = context
                              .read<CalculatorBloc>()
                              .getButtonTextColor(button);
            
                          final borderColor = context
                              .read<CalculatorBloc>()
                              .getButtonBorderColor(button);
            
                          final buttonColor = context
                              .read<CalculatorBloc>()
                              .getButtonColor(button);
            
                          return GestureDetector(
                            onTap: () {
                              context.read<CalculatorBloc>().add(
                                    _mapButtonToEvent(button),
                                  );
                            },
                            onTapDown: (_) {
                              setState(() {
                                _buttonColors[button] =
                                    buttonColor.withOpacity(0.7);
                              });
                            },
                            onTapUp: (_) {
                              setState(() {
                                _buttonColors[button] = buttonColor;
                              });
                            },
                            onTapCancel: () {
                              setState(() {
                                _buttonColors[button] = buttonColor;
                              });
                            },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                decoration: BoxDecoration(
                                  color: _buttonColors[button] ?? buttonColor,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: borderColor,
                                    width: 2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      offset: const Offset(0, 2),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  button,
                                  style: TextStyle(
                                    fontSize:
                                        28, 
                                    fontWeight: FontWeight.w600,
                                    color: textColor,
                                  ),
                                ),
                              ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  CalculatorEvent _mapButtonToEvent(String button) {
    if (button == 'AC') return ClearPressed();
    if (button == '=') return CalculatePressed();
    if (button == "DEL") return DeletePressed();
    if ('+-x÷'.contains(button)) return OperatorPressed(button);
    return NumberPressed(button);
  }
}
