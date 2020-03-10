import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:safejourney/bloc/authentication_bloc.dart';
import 'package:safejourney/bloc/authentication_state.dart';
import 'package:safejourney/bloc/simple_bloc_delegate.dart';
import 'package:safejourney/di/injector.dart';
import 'package:safejourney/repository/user_repository.dart';
import 'package:safejourney/screens/home_view.dart';
import 'package:safejourney/screens/onboarding/onboarding_view.dart';
import 'package:safejourney/screens/splash_screen_view.dart';
import 'bloc/authentication_event.dart';
import 'navigation/router.dart' as router;
import 'package:bloc/bloc.dart';

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  WidgetsFlutterBinding.ensureInitialized();

  final UserRepository userRepository = UserRepository();
  createDependencies();

  runApp(
    BlocProvider(
      builder: (context) => AuthenticationBloc(userRepository: userRepository)
        ..dispatch(AppStarted()),
      child: App(userRepository: userRepository),
    ),
  );
}

final formatCurrency = NumberFormat.simpleCurrency(locale: 'nb');

class App extends StatelessWidget {
  // This widget is the root of your application.
  final UserRepository _userRepository;

  App({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Safe Journey',
      onGenerateRoute: router.generateRoute,
      // initialRoute: SplashScreenRoute,
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            if (state is Authenticated) {
              return HomeView();
            }
            if (state is Uninitialized) {
              return SplashScreenView();
            }

            if (state is Unauthenticated) {
              return OnboardingViewScreen(
                userRepository: _userRepository,
              );
            }

            return HomeView();
          }),
      theme: ThemeData(
        fontFamily: 'Nunito',
        primarySwatch: Colors.blueGrey,
      ),
    );
  }
}






//import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
//
//void main() => runApp(MyApp());
//
//class MyApp extends StatelessWidget {
//  // This widget is the root of your application.
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      title: 'Flutter Demo',
//      theme: ThemeData(
//        primarySwatch: Colors.blue,
//      ),
//      home: MyHomePage(title: 'Flutter Demo Home Page'),
//    );
//  }
//}
//
//class MyHomePage extends StatefulWidget {
//  MyHomePage({Key key, this.title}) : super(key: key);
//  final String title;
//
//  @override
//  _MyHomePageState createState() => _MyHomePageState();
//}
//
//class _MyHomePageState extends State<MyHomePage> {
//  int _counter = 0;
//  static const platform = const MethodChannel('com.startActivity/testChannel');
//
//
//  Future<void> _incrementCounter() async {
//
//    try {
//      final String result = await platform.invokeMethod('StartSecondActivity');
//      debugPrint('Result: $result ');
//    } on PlatformException catch (e) {
//      debugPrint("Error: '${e.message}'.");
//    }
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text(widget.title),
//      ),
//      body: Center(
//        child: Column(
//          mainAxisAlignment: MainAxisAlignment.center,
//          children: <Widget>[
//            Text(
//              'You have pushed the button this many times:',
//            ),
//            Text(
//              '$_counter',
//              style: Theme.of(context).textTheme.display1,
//            ),
//          ],
//        ),
//      ),
//      floatingActionButton: FloatingActionButton(
//        onPressed: _incrementCounter,
//        tooltip: 'Increment',
//        child: Icon(Icons.add),
//      ), // This trailing comma makes auto-formatting nicer for build methods.
//    );
//  }
//}
