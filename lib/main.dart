import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'injection.dart';
import 'presentation/cubit/path_finder_cubit.dart';
import 'presentation/pages/home_screen.dart';
import 'presentation/pages/preview_screen.dart';
import 'presentation/pages/process_screen.dart';
import 'presentation/pages/result_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PathFinderCubit>(
          create: (context) => GetIt.I<PathFinderCubit>(),
        ),
      ],
      child: MaterialApp(
        title: 'Path Finder App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => HomeScreen(),
          '/process': (context) => const ProcessScreen(),
          '/result_list': (context) => const ResultListScreen(),
          '/preview': (context) => const PreviewScreen(),
        },
      ),
    );
  }
}
