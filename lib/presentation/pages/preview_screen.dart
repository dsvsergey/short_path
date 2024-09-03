import 'package:flutter/material.dart';
import 'package:path_finder_app/domain/entities/path_result.dart';
import 'package:path_finder_app/presentation/widgets/grid_widget.dart';

class PreviewScreen extends StatelessWidget {
  const PreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PathResult pathResult =
        ModalRoute.of(context)!.settings.arguments as PathResult;

    final steps = pathResult.result.steps;
    final path = pathResult.result.path;

    final startPoint = steps.first;
    final endPoint = steps.last;

    final fieldSize = steps
            .map((p) => p.x > p.y ? p.x : p.y)
            .reduce((a, b) => a > b ? a : b) +
        1;
    final field = List.generate(fieldSize, (_) => List.filled(fieldSize, '.'));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview screen'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Shortest path: $path',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Expanded(
            child: GridWidget(
              field: field,
              path: steps.map((point) => [point.x, point.y]).toList(),
              startPoint: [startPoint.x, startPoint.y],
              endPoint: [endPoint.x, endPoint.y],
            ),
          ),
        ],
      ),
    );
  }
}
