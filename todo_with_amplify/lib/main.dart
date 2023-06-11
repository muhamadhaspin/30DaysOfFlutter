import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'data/repositories/todo_repository.dart';
import 'logic/bloc/todo/todo_bloc.dart';
import 'views/pages/home_page.dart';

// Amplify Flutter Packages
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
// import 'package:amplify_api/amplify_api.dart'; // UNCOMMENT this line after backend is deployed

// Generated in previous step
import 'data/models/ModelProvider.dart';
import 'amplifyconfiguration.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _amplifyConfigured = false;

  @override
  void initState() {
    super.initState();
    _configureAmplify();
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => TodoRepository(),
      child: BlocProvider(
        create: (context) => TodoBloc(
          todoRepository: RepositoryProvider.of<TodoRepository>(context),
        ),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Todo Amplify',
          theme: ThemeData.dark(),
          home: _amplifyConfigured
              ? const HomePage()
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        ),
      ),
    );
  }

  void _configureAmplify() async {
    // await Amplify.addPlugin(AmplifyAPI()); // UNCOMMENT this line after backend is deployed
    await Amplify.addPlugin(
        AmplifyDataStore(modelProvider: ModelProvider.instance));

    try {
      // Once Plugins are added, configure Amplify
      await Amplify.configure(amplifyconfig);
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }

    setState(() {
      _amplifyConfigured = true;
    });
  }
}
