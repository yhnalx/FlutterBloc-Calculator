import 'package:equatable/equatable.dart';

abstract class CalculatorEvent extends Equatable {
  const CalculatorEvent();
}

class NumberPressed extends CalculatorEvent {
  final String number;

  const NumberPressed(this.number);

  @override
  List<Object> get props => [number];
}

class OperatorPressed extends CalculatorEvent {
  final String operator;

  const OperatorPressed(this.operator);

  @override
  List<Object> get props => [operator];
}

class ToggleMode extends CalculatorEvent {
  @override
  List<Object> get props => [];

}

class ClearPressed extends CalculatorEvent {
  @override
  List<Object> get props => [];
}

class DeletePressed extends CalculatorEvent {
  @override
  List<Object> get props => [];
}

class CalculatePressed extends CalculatorEvent {
  @override
  List<Object> get props => [];
}

abstract class SwitchEvent extends CalculatorEvent {}