import 'package:flutter/material.dart';

abstract class Piece {
  final String name;
  int xAxis;
  int yAxis;

  Color color;
  List<int> get position => <int>[yAxis, xAxis];
  bool isSelected = false;

  /// return map of positions Like:{'const':[[x,y],]],'xAxis':bool,'yAxis':bool,'diagonally':bool/// }
  Map movements(List board);

  Piece({
    required this.name,
    required this.xAxis,
    required this.yAxis,
    required this.color,
  });
  bool positionChecker(List point) {
    if (point[0] >= 1 && point[0] <= 8 && point[1] >= 1 && point[1] <= 8) {
      return true;
    }
    return false;
  }
}
