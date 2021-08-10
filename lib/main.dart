import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:the_zikir_app/data/models/counter.dart';
import 'package:the_zikir_app/screens/home_page.dart';
import 'package:the_zikir_app/theme/colors/light_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: Theme.of(context).textTheme.apply(
            bodyColor: Color(0xff3d7068),
            displayColor: Color(0xff3d7068),
            fontFamily: 'Poppins'),
      ),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
