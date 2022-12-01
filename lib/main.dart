import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_demo/HomePage.dart';
import 'package:project_demo/LecturePage.dart';
import 'package:project_demo/LogInPage.dart';
import 'package:project_demo/MyPage.dart';
import 'package:project_demo/SignUpPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:project_demo/detail.dart';
import 'package:project_demo/material.dart';
import 'package:project_demo/myLectureDetail.dart';
import 'package:project_demo/myLecturePage.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        title: "CAU Curriculum",
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routes: {
          "/LogInPage": (BuildContext context) => const LoginPage(),
          "/SignUpPage": (BuildContext context) => const SignUpPage(),
          "/HomePage" : (context) => const HomePage(),
          "/LecturePage" : (context) => const LecturePage(),
          "/MyPage" : (context) => const MyPage(),
          "/Mypage_Lecture" : (context) => const MyLecturePage(),
          "/Mypage_detail" : (context) => const MyLectureDetail(),
          "/Detail" : (context) => const DetailScreen(),
        },
        //initialRoute: "/HomePage",
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot){
            if(snapshot.hasData){
              return const HomePage();
            }else{
              return const LoginPage();
            }
          },
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}