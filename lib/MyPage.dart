import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_demo/Styles.dart';

class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final _authentication = FirebaseAuth.instance;
  User? loggedUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final user = _authentication.currentUser;
      if (user != null) {
        loggedUser = user;
      }
    } catch (e) {
      print(e);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.mainColor,
          title: const Text('MyPage'),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.account_circle_rounded,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed('/MyPage');
              },
            )
          ],
        ),
        body: Column(
          children: [
            Container(
              child: IconButton(
                onPressed: () {
                  //로그아웃 방법
                  FirebaseAuth.instance.signOut();
                },
                icon: const Icon(Icons.logout),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(onPressed: (){
              Navigator.of(context).pushNamed('/Mypage_Lecture');
            }, child: const Text('내 강의리스트'),),
          ],
        ),
      ),
    );
  }
}
