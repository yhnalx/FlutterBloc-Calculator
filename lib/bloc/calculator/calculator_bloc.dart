import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'calculator_event.dart';
import 'calculator_state.dart';

class CalculatorBloc extends Bloc<CalculatorEvent, CalculatorState> {
  CalculatorBloc() : super(const CalculatorState('0')) {
    on<NumberPressed>(_numberButtonEvent);

    on<OperatorPressed>(_operatorEvent);

    on<ClearPressed>(_clearEvent);

    on<DeletePressed>(_deleteEvent);

    on<SwitchEvent>(_switchEvent);

    on<CalculatePressed>(_displayCalculate);
  }

  bool isOperator(String currentInput) {
    return ['÷', 'x', '-', '+', '=', '%'].contains(currentInput);
  }

  void _numberButtonEvent(NumberPressed event, Emitter<CalculatorState> emit){
    final currentDisplay = state.display;

      if (currentDisplay == '0' &&
          (event.number == '0' || event.number == '00')) {
        return;
      }

      final updatedDisplay = (currentDisplay == '0')
          ? event.number
          : currentDisplay + event.number;
      emit(CalculatorState(updatedDisplay));
  }

  void _clearEvent(ClearPressed event, Emitter<CalculatorState> emit) {
    emit(const CalculatorState('0'));
  }

  void _operatorEvent(OperatorPressed event, Emitter<CalculatorState> emit) {
    final currentDisplay = state.display;

    if (event.operator == '%') {
      if (currentDisplay != '0') {
        try {
          final currentValue = double.parse(currentDisplay);
          final result = currentValue / 100;
          emit(CalculatorState(result.toStringAsFixed(2)));
        } catch (e) {
          emit(const CalculatorState('Error'));
        }
      }
      return;
    }

    if (currentDisplay.isEmpty ||
        isOperator(currentDisplay.substring(currentDisplay.length - 1))) {
      return;
    }

    if (currentDisplay == '0' &&
        ['+', '-', 'x', '÷', '%'].contains(event.operator)) {
      return;
    }

    emit(CalculatorState(currentDisplay + event.operator));
  }

  void _deleteEvent(DeletePressed event, Emitter<CalculatorState> emit) {
    final currentDisplay = state.display;

    if (currentDisplay.isNotEmpty && currentDisplay != '0') {
      final updatedDisplay =
          currentDisplay.substring(0, currentDisplay.length - 1);
      emit(CalculatorState(updatedDisplay.isEmpty ? '0' : updatedDisplay));
    } else {
      emit(const CalculatorState('0'));
    }
  }

  void _displayCalculate(
      CalculatePressed event, Emitter<CalculatorState> emit) {
    try {
      final result = _calculateResult(state.display);
      emit(CalculatorState(result));
    } catch (_) {
      emit(const CalculatorState('Error'));
    }
  }

  void _switchEvent(SwitchEvent event, Emitter<CalculatorState> emit) {
    emit(state.copyWith(isSwitchOn: !state.isSwitchOn));
  }

  String _calculateResult(String input) {
    try {
      String expression = input.replaceAll('x', '*').replaceAll('÷', '/');
      final result = _evaluateExpression(expression);

      return result
          .toStringAsFixed(result.truncateToDouble() == result ? 0 : 2);
    } catch (e) {
      return 'Error';
    }
  }

  double _evaluateExpression(String expression) {
    final List<String> tokens = _tokenize(expression);
    double result = double.parse(tokens[0]);

    for (int i = 1; i < tokens.length; i += 2) {
      String operator = tokens[i];
      double nextValue = double.parse(tokens[i + 1]);

      switch (operator) {
        case '+':
          result += nextValue;
          break;
        case '-':
          result -= nextValue;
          break;
        case '*':
          result *= nextValue;
          break;
        case '/':
          if (nextValue == 0) throw Exception('Cannot divide by zero');
          result /= nextValue;
          break;
        case '%':
          result = result * (nextValue / 100); // Handle percentage properly
          break;
        default:
          throw Exception('Invalid operator');
      }
    }

    return result;
  }

  List<String> _tokenize(String expression) {
    final regex =
        RegExp(r'(\d+\.?\d*|[-+*/%=])'); // Adjust regex to include '%'
    return regex
        .allMatches(expression)
        .map((match) => match.group(0)!)
        .toList();
  }

  Color getButtonBorderColor(String button) {
    if (['1', '2', '3', '4', '5', '6', '7', '8', '9', '00', '0', '.']
        .contains(button)) {
      return Color(0xFFFFBEBE);
    } else if (['AC', '%', 'DEL'].contains(button)) {
      return Color(0xFFFFCECE);
    } else if (['÷', 'x', '-', '+', '='].contains(button)) {
      return Color.fromARGB(255, 255, 227, 227);
    }
    return Colors.transparent;
  }

  Color getButtonTextColor(String button) {
    if (['AC', '%', 'DEL'].contains(button)) {
      return Color.fromARGB(255, 255, 159, 159);
    } else if (['÷', 'x', '-', '+', '='].contains(button)) {
      return Color.fromARGB(255, 255, 255, 255);
    } else if (['1', '2', '3', '4', '5', '6', '7', '8', '9', '00', '0', '.']
        .contains(button)) {
      return Color.fromARGB(255, 248, 149, 149);
    }
    return Colors.white;
  }

  Color getButtonColor(String button) {
    if (['AC', '%', 'DEL'].contains(button)) {
      return Color(0xFFFCECEC);
    } else if (['÷', 'x', '-', '+', '='].contains(button)) {
      return Color.fromARGB(255, 250, 195, 195);
    }
    return Colors.white;
  }
}