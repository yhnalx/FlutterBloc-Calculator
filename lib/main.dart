import 'package:cinamoroll_calculator/bloc/calculator/calculator_bloc.dart';
import 'package:cinamoroll_calculator/views/my_melody_theme_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (_) => CalculatorBloc(),
        child: MyMelodyThemePage(),
      ),
    );
  }
}