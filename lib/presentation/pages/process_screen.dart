import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/path_finder_cubit.dart';

class ProcessScreen extends StatelessWidget {
  const ProcessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<PathFinderCubit, PathFinderState>(
      listenWhen: (previous, current) =>
          !previous.isResultsSent && current.isResultsSent,
      listener: (context, state) {
        Navigator.of(context).pushReplacementNamed('/result_list');
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Process screen'),
        ),
        body: BlocBuilder<PathFinderCubit, PathFinderState>(
          builder: (context, state) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    Text(
                      state.isCalculationFinished
                          ? 'All calculations have finished, you can send your results to server'
                          : 'Calculating...',
                      textAlign: TextAlign.center,
                      maxLines: null,
                      softWrap: true,
                    ),
                    const SizedBox(height: 16),
                    Text('${(state.progress * 100).toStringAsFixed(0)}%'),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: CircularProgressIndicator(
                        value: state.progress,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                        'Tasks completed: ${state.results.length}/${state.tasks.length}'),
                    if (state.isCalculationFinished &&
                        !state.isResultsSent) ...[
                      const Spacer(),
                      ElevatedButton(
                        child: const Text('Send results to server'),
                        onPressed: () {
                          context.read<PathFinderCubit>().sendResultsToServer();
                        },
                      )
                    ],
                    if (state.isResultsSent) ...[
                      const Spacer(),
                      const Text('Results sent successfully!'),
                    ],
                    if (state.error != null)
                      Text('Error: ${state.error}',
                          style: const TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
