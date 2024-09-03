import 'dart:math' show sqrt;

import 'package:injectable/injectable.dart';

import '../entities/path_task.dart';
import '../utils/node.dart';
import '../utils/priority_queue.dart';

abstract class FindShortestPathUseCase {
  List<Point> execute(PathTask task);
}

@Singleton(as: FindShortestPathUseCase)
class FindShortestPathUseCaseImpl implements FindShortestPathUseCase {
  @override
  List<Point> execute(PathTask task) {
    return _findShortestPath(task.field, task.start, task.end);
  }

  List<Point> _findShortestPath(List<String> field, Point start, Point end) {
    final rows = field.length;
    final cols = field[0].length;

    final queue = PriorityQueue<Node>((a, b) => a.fCost.compareTo(b.fCost));
    final visited = <Point>{};
    final parent = <Point, Point>{};
    final gScore = <Point, double>{start: 0};
    final fScore = <Point, double>{start: _heuristic(start, end)};

    queue.add(Node(start, fScore[start]!));

    final directions = [
      const Point(x: -1, y: -1),
      const Point(x: -1, y: 0),
      const Point(x: -1, y: 1),
      const Point(x: 0, y: -1),
      const Point(x: 0, y: 1),
      const Point(x: 1, y: -1),
      const Point(x: 1, y: 0),
      const Point(x: 1, y: 1)
    ];

    while (queue.isNotEmpty) {
      final current = queue.removeFirst().point;

      if (current == end) {
        return _reconstructPath(parent, end);
      }

      visited.add(current);

      for (final dir in directions) {
        final next = Point(x: current.x + dir.x, y: current.y + dir.y);

        if (_isValidPoint(next, rows, cols, field) && !visited.contains(next)) {
          final tentativeGScore = gScore[current]! + _distance(current, next);

          if (!gScore.containsKey(next) || tentativeGScore < gScore[next]!) {
            parent[next] = current;
            gScore[next] = tentativeGScore;
            fScore[next] = gScore[next]! + _heuristic(next, end);

            if (!queue.any((node) => node.point == next)) {
              queue.add(Node(next, fScore[next]!));
            }
          }
        }
      }
    }

    return [];
  }

  bool _isValidPoint(Point point, int rows, int cols, List<String> field) {
    return point.x >= 0 &&
        point.x < cols &&
        point.y >= 0 &&
        point.y < rows &&
        field[point.y][point.x] == '.';
  }

  double _distance(Point a, Point b) {
    final dx = (a.x - b.x).abs();
    final dy = (a.y - b.y).abs();
    return dx == dy ? sqrt(2) : 1;
  }

  double _heuristic(Point a, Point b) {
    final dx = (a.x - b.x).abs();
    final dy = (a.y - b.y).abs();
    return sqrt(dx * dx + dy * dy);
  }

  List<Point> _reconstructPath(Map<Point, Point> parent, Point end) {
    final path = <Point>[end];
    var current = end;

    while (parent.containsKey(current)) {
      current = parent[current]!;
      path.add(current);
    }

    return path.reversed.toList();
  }
}
