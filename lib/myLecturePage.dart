import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_demo/Styles.dart';

class MyLecturePage extends StatefulWidget {
  const MyLecturePage({Key? key}) : super(key: key);

  @override
  State<MyLecturePage> createState() => _MyLecturePageState();
}

class _MyLecturePageState extends State<MyLecturePage> {
  final _authentication = FirebaseAuth.instance;
  User? loggedUser;
  late String uid = _authentication.currentUser!.uid;

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.mainColor,
        title: const Text('MyPage'),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.home,
            ),
            onPressed: () {
              Navigator.of(context).pushNamed('/HomePage');
            },
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Accounts')
                  .doc(uid)
                  .collection('_name')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final docs = snapshot.data!.docs;
                return ListView.separated(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text('${docs[index]['name']}'),
                        trailing: const Icon(Icons.navigate_next),
                        onTap: () {
                          String Listname_info = docs[index]['name'];
                          Navigator.of(context)
                              .pushNamed("/Mypage_detail", arguments: Listname_info);
                        },
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
