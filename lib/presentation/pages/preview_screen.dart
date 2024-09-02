import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_finder_app/domain/entities/result.dart';
import 'package:path_finder_app/presentation/cubit/path_finder_cubit.dart';
import 'package:path_finder_app/presentation/widgets/grid_widget.dart';

class PreviewScreen extends StatelessWidget {
  const PreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Result result = ModalRoute.of(context)!.settings.arguments as Result;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview screen'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocBuilder<PathFinderCubit, PathFinderState>(
        builder: (context, state) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Shortest path: ${result.path}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Expanded(
                child: GridWidget(
                  field: result.field,
                  path: result.steps,
                  startPoint: result.start,
                  endPoint: result.end,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
