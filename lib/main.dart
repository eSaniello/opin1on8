import 'package:firebase_auth/firebase_auth.dart';
import 'package:opin1on8/add_service.dart';
import 'package:opin1on8/service_details.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:opin1on8/home.dart';
import 'package:opin1on8/providers/user.dart';
import 'login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(new MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => User(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        // theme: ThemeData(
        //   primarySwatch: Colors.deepPurple,
        // ),
        home: FutureBuilder<FirebaseUser>(
            future: FirebaseAuth.instance.currentUser(),
            builder:
                (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
              if (snapshot.hasData) {
                // FirebaseUser user = snapshot.data; //this is user data
                return HomeScreen();
              }

              return LoginScreen();
            }),
        onGenerateRoute: (RouteSettings settings) {
          print('build route for ${settings.name}');

          var routes = {
            LoginScreen.id: (context) => LoginScreen(),
            HomeScreen.id: (context) => HomeScreen(),
            AddServiceScreen.id: (context) => AddServiceScreen(),
            ServiceDetails.id: (context) => ServiceDetails(settings.arguments),
          };
          WidgetBuilder builder = routes[settings.name];
          return MaterialPageRoute(builder: (ctx) => builder(ctx));
        },
      ),
    );
  }
}
