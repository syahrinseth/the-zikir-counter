import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:the_zikir_app/bloc/profile_bloc.dart';
import 'package:the_zikir_app/data/models/counter.dart';
import 'package:the_zikir_app/event/profile_event.dart';
import 'package:the_zikir_app/screens/home_page.dart';
import 'package:the_zikir_app/screens/welcome_screen.dart';
import 'package:the_zikir_app/state/profile_state.dart';
import 'package:the_zikir_app/theme/colors/light_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: LightColors.kLightYellow, // navigation bar color
    statusBarColor: Color(0xff43c59e), // status bar color
  ));
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final document = await getApplicationDocumentsDirectory();
  Hive.init(document.path);
  Hive.registerAdapter(CounterAdapter());
  Hive.registerAdapter(CounterHistoryAdapter());
  await Hive.openBox<Counter>('myZikirCountersBox');
  await Hive.openBox<String>('myProfileBox');
  // Box<Counter> countersBox = Hive.box<Counter>('myZikirCountersBox');
  // countersBox.clear();
  return runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ProfileBloc profileBloc = ProfileBloc();

  @override
  void initState() {
    super.initState();
    profileBloc.add(ProfileGet());
  }

  @override
  void dispose() {
    profileBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      bloc: profileBloc,
      builder: (context, state) {
        return MaterialApp(
          title: 'Smart Dhikr',
          theme: ThemeData(
            primarySwatch: Colors.green,
            textTheme: Theme.of(context).textTheme.apply(
                bodyColor: Color(0xff3d7068),
                displayColor: Color(0xff3d7068),
                fontFamily: 'Poppins'),
          ),
          home: state is ProfileLoaded
              ? (state.isDoneWelcomeScreen == 'yes'
                  ? HomePage()
                  : WelcomeScreen())
              : HomePage(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
