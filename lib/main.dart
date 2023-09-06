import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:price_tracker_challenge/domain/cubits/home_screen_cubit/home_screen_cubit.dart';
import 'package:price_tracker_challenge/domain/cubits/ticker_cubit/ticker_cubit.dart';
import 'package:price_tracker_challenge/domain/services/deriv_api_service.dart';
import 'package:price_tracker_challenge/ui/screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Price Tracker App',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const MyHomePage(title: 'DerivAPI Price Tracker Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // API service class to be used by cubits
  DerivAPIServiceImpl api = DerivAPIServiceImpl()..setStreamListeners();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/img6.jpeg'),
          opacity: 0.4,
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.center,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(17, 0, 0, 0),
              Color.fromARGB(185, 223, 60, 48),
            ],
          ),
        ),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: Center(child: Text(widget.title)),
              backgroundColor: Color.fromARGB(255, 134, 48, 42),
            ),
            // BlocProvider connects our cubit to our context at the top of the tree, allowing us to access the same cubit instance anywhere in our (context) widget tree
            body: MultiBlocProvider(
              providers: [
                BlocProvider<HomeScreenCubit>(
                  create: (context) => HomeScreenCubit(
                    api,
                  )..init(),
                ),
                BlocProvider<TickerCubit>(
                  create: (context) => TickerCubit(api)..init(),
                ),
              ],
              child: const HomeScreen(),
            )),
      ),
    );
  }
}
