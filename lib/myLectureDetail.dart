import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_demo/Styles.dart';

class MyLectureDetail extends StatefulWidget {
  const MyLectureDetail({Key? key}) : super(key: key);

  @override
  State<MyLectureDetail> createState() => _MyLectureDetailState();
}

class _MyLectureDetailState extends State<MyLectureDetail> {
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
    final Listname_info =
        ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.mainColor,
        title: Text(Listname_info),
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
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Accounts')
                  .doc(uid)
                  .collection(Listname_info)
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
                        leading: IconButton(
                          icon: const Icon(
                            Icons.my_library_books_sharp,
                          ),
                          onPressed: () {},
                        ),
                        title: Text('${docs[index]['name']}'),
                        subtitle: Wrap(
                          children: [
                            Row(
                              children: [
                                IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.book_outlined)),
                                Text('   ${docs[index]['lecture_field']}')
                              ],
                            )
                          ],
                        ),
                        trailing: const Icon(Icons.navigate_next),
                        onTap: () {
                          List<dynamic> lecture_info = [];
                          lecture_info.add(
                              (docs[index].data()) as Map<String, dynamic>);
                          Navigator.of(context)
                              .pushNamed("/Detail", arguments: lecture_info);
                        },
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(),
                );
              },
            ))
          ],
        ),
      ),
    );
  }
}
