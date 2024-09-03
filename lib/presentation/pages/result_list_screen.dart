import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/path_finder_cubit.dart';

class ResultListScreen extends StatelessWidget {
  const ResultListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Result list screen'),
      ),
      body: BlocBuilder<PathFinderCubit, PathFinderState>(
        builder: (context, state) {
          return ListView.builder(
            itemCount: state.results.length,
            itemBuilder: (context, index) {
              final result = state.results[index];
              return ListTile(
                title: Text(result.result.path),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/preview',
                    arguments: result,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
