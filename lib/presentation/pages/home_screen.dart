import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../injection.dart';
import '../cubit/path_finder_cubit.dart';

class HomeScreen extends StatelessWidget {
  final TextEditingController _urlController = TextEditingController();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<PathFinderCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home screen'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Set valid API base URL in order to continue'),
              TextField(
                controller: _urlController,
                decoration: const InputDecoration(
                  hintText: 'Enter API URL',
                  prefixIcon: Icon(Icons.link),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                child: const Text('Start counting process'),
                onPressed: () {
                  final url = _urlController.text;
                  if (url.isNotEmpty) {
                    context.read<PathFinderCubit>().setApiUrl(url);
                    Navigator.pushNamed(context, '/process');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
