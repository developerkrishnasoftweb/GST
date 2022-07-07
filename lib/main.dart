import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gst/constants/app_constants.dart';
import 'package:gst/gst/gst_form_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async{
  /// Ensure initialization
  WidgetsFlutterBinding.ensureInitialized();

  kAppStorage = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (BuildContext context, Widget? child) => const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: GSTFormScreen(),
      ),
    );
  }
}