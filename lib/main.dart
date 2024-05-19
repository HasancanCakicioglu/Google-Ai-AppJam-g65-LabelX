import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:labeling/app.dart';
import 'package:labeling/firebase_options.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:labeling/game/brick_breaker.dart';
import 'package:labeling/Onboard/presentation/cubit/onboard_cubit.dart';
import 'package:labeling/provider/cubit_heart/heart_cubit.dart';
import 'package:labeling/services/auth.dart';
import 'package:labeling/services/firestore.dart';
import 'package:labeling/services/image_picker.dart';

import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );

  HydratedBloc.storage = storage;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HeartCubit>(
          create: (context) => HeartCubit(),
        ),
        BlocProvider<OnBoardCubit>(
          create: (context) => OnBoardCubit(), // Access OnBoardCubit from GetIt
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const AppView(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _modelManager = OnDeviceTranslatorModelManager();
  var _sourceLanguage = TranslateLanguage.turkish;
  var _targetLanguage = TranslateLanguage.english;
  var _onDeviceTranslator = OnDeviceTranslator(
      sourceLanguage: TranslateLanguage.turkish,
      targetLanguage: TranslateLanguage.english);

  @override
  void dispose() {
    _onDeviceTranslator.close();
    super.dispose();
  }

  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            ElevatedButton(
                onPressed: () {
                  _modelManager.downloadModel(_sourceLanguage.bcpCode).then(
                      (value) => value ? print("succes") : print("error"));
                },
                child: Text('Download Model')),
            ElevatedButton(
                onPressed: () {
                  _onDeviceTranslator
                      .translateText("Merhaba bu benim etiket uygulamam")
                      .then((value) => print(value));
                },
                child: Text("Translate")),
            ElevatedButton(
                onPressed: () {
                  CameraService().pickImage();
                },
                child: Text("Take photo")),
            ElevatedButton(
                onPressed: () async {
                  var file = await CameraService().pickImage();
                  if (file != null) {
                    StorageService().uploadImage(file, "images");
                  } else {
                    print("file is null");
                  }
                },
                child: Text("Upload image")),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BrickBreakerGame()));
                },
                child: Text("play game")),
            ElevatedButton(
                onPressed: () {
                  HeartCubit heartcubit = HeartCubit();
                  print(heartcubit.getAliveHeartCount());
                  heartcubit.dead();
                  print(heartcubit.getAliveHeartCount());
                },
                child: Text("heart")),
            ElevatedButton(
                onPressed: () {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => OnBoardingPageView()));
                },
                child: Text("onboard")),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
