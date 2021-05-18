import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:google_fonts/google_fonts.dart';
import 'userSide/screens/screens.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'userSide/services/services.dart';
import 'userSide/shared/shared.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return StreamProvider<TheUser?>.value(
      value: AuthService().user,
      initialData: null,
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          textTheme:
              GoogleFonts.josefinSansTextTheme(Theme.of(context).textTheme),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Wrapper(),
      ),
    );
  }
}
