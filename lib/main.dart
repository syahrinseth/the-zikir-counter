import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:the_zikir_app/bloc/profile_bloc.dart';
import 'package:the_zikir_app/data/models/counter.dart';
import 'package:the_zikir_app/event/profile_event.dart';
import 'package:the_zikir_app/screens/home_page.dart';
import 'package:the_zikir_app/screens/welcome_screen.dart';
import 'package:the_zikir_app/state/profile_state.dart';
import 'package:the_zikir_app/theme/colors/light_colors.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // MobileAds.instance.initialize();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Firebase.initializeApp();

  if (kDebugMode) {
    // Force disable Crashlytics collection while doing every day development.
    // Temporarily toggle this to true if you want to test crash reporting in your app.
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  } else {
    // Handle Crashlytics enabled status when not in Debug,
    // e.g. allow your users to opt-in to crash reporting.
  }

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
    // FirebaseCrashlytics.instance.crash();
    profileBloc.add(ProfileGet());
  }

  @override
  void dispose() {
    profileBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => profileBloc,
      child: BlocBuilder<ProfileBloc, ProfileState>(
        bloc: profileBloc,
        builder: (context, state) {
          SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
            systemNavigationBarColor: LightColors.getThemeColor(
                state: profileBloc.state,
                contrast: 'dark',
                isBackgroundColor: true,
                colorName: 'green'), // navigation bar color
            statusBarColor: LightColors.getThemeColor(
                state: profileBloc.state,
                contrast: 'light',
                isBackgroundColor: true,
                colorName: 'green'), // status bar color
          ));
          return MaterialApp(
            title: 'Smart Dhikr',
            theme: ThemeData(
              backgroundColor: LightColors.kLightYellow2,
              brightness: Brightness.light,
              primarySwatch: Colors.green,
              textTheme: Theme.of(context).textTheme.apply(
                  bodyColor: Color(0xff3d7068),
                  displayColor: Color(0xff3d7068),
                  fontFamily: 'Poppins'),
            ),
            darkTheme: ThemeData(
              backgroundColor: Colors.black,
              primaryColor: Colors.white,
              brightness: Brightness.dark,
              primarySwatch: Colors.green,
              textTheme: Theme.of(context).textTheme.apply(
                  bodyColor: Colors.white70,
                  displayColor: Colors.white70,
                  fontFamily: 'Poppins'),
            ),
            themeMode: state is ProfileLoaded
                ? (state.themeMode == 'system'
                    ? ThemeMode.system
                    : (state.themeMode == 'dark'
                        ? ThemeMode.dark
                        : ThemeMode.light))
                : ThemeMode.system,
            home: state is ProfileLoaded
                ? (state.isDoneWelcomeScreen == 'yes'
                    ? HomePage()
                    : WelcomeScreen())
                : HomePage(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
