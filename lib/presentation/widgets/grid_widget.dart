import 'package:flutter/material.dart';

class GridWidget extends StatelessWidget {
  final List<List<String>> field;
  final List<List<int>> path;
  final List<int> startPoint;
  final List<int> endPoint;

  const GridWidget({
    Key? key,
    required this.field,
    required this.path,
    required this.startPoint,
    required this.endPoint,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: field.length,
      ),
      itemCount: field.length * field[0].length,
      itemBuilder: (context, index) {
        int row = index ~/ field.length;
        int col = index % field.length;
        return _buildGridItem(context, row, col);
      },
    );
  }

  Widget _buildGridItem(BuildContext context, int row, int col) {
    Color cellColor = Colors.white;
    if (field[row][col] == 'X') {
      cellColor = Colors.black;
    } else if (row == startPoint[0] && col == startPoint[1]) {
      cellColor = Colors.teal[200]!;
    } else if (row == endPoint[0] && col == endPoint[1]) {
      cellColor = Colors.teal[800]!;
    } else if (path.any((point) => point[0] == row && point[1] == col)) {
      cellColor = Colors.green;
    }

    return Container(
      decoration: BoxDecoration(
        color: cellColor,
        border: Border.all(color: Colors.grey),
      ),
      child: Center(
        child: Text(
          '($col,$row)',
          style: TextStyle(
            color: cellColor == Colors.black ? Colors.white : Colors.black,
            fontSize: 10,
          ),
        ),
      ),
    );
  }
}
