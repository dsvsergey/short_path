import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/path_finder_cubit.dart';

class ProcessScreen extends StatelessWidget {
  const ProcessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Process screen'),
      ),
      body: BlocBuilder<PathFinderCubit, PathFinderState>(
        builder: (context, state) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  state.isCalculationFinished
                      ? 'All calculations has finished, you can send your results to server'
                      : 'Calculating...',
                ),
                const SizedBox(height: 16),
                CircularProgressIndicator(
                  value: state.progress,
                ),
                Text('${(state.progress * 100).toStringAsFixed(0)}%'),
                const SizedBox(height: 16),
                if (state.isCalculationFinished)
                  ElevatedButton(
                    child: const Text('Send results to server'),
                    onPressed: () {
                      context.read<PathFinderCubit>().sendResultsToServer();
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
