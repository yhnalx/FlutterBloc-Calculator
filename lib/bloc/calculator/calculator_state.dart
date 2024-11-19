import 'package:equatable/equatable.dart';

class CalculatorState extends Equatable {
  final String display;
  final bool isSwitchOn;

  const CalculatorState(this.display, {this.isSwitchOn = false});

  CalculatorState copyWith({bool? isSwitchOn}) {
    return CalculatorState(display, isSwitchOn: isSwitchOn ?? this.isSwitchOn);
  }

  @override
  List<Object> get props => [display, isSwitchOn];
}