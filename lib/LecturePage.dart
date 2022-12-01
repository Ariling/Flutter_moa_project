import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_demo/HomePage.dart';
import 'package:project_demo/Styles.dart';

class LecturePage extends StatefulWidget {
  const LecturePage({Key? key}) : super(key: key);

  @override
  State<LecturePage> createState() => _LecturePageState();
}

class _LecturePageState extends State<LecturePage> {
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

  String _difficulty = "";
  String _lecture_field = "";
  String _media = "";
  String _nickname = 'User1';
  String _intro = "";
  String _title = '';
  bool _check = true;
  late String uid = _authentication.currentUser!.uid;
  // Future<String?> getNeme() async {
  //   var docSnapshot_name =
  //       await FirebaseFirestore.instance.collection("Accounts").doc(uid).get();
  //   if (docSnapshot_name.exists) {
  //     Map<String, dynamic> data = docSnapshot_name.data()!;
  //     var _result = data['UserName'];
  //     return _result;
  //   }
  // }

  // dynamic getList () {
  //   final Hi = FirebaseFirestore.instance.collection('Accounts').doc(uid).collection('wow');
  //   Hi.get().then((QuerySnapshot snapshot){
  //     snapshot.docs.forEach((DocumentSnapshot doc) {
  //       print(doc.data());
  //     });
  //   });
  // }

  dynamic getName() {
    FirebaseFirestore.instance
        .collection('Accounts')
        .doc(uid)
        .get()
        .then((doc) {
      _nickname = doc.get("UserName");
    });
    return _nickname;
  }

  bool checkName(_checktitle) {
    FirebaseFirestore.instance
        .collection('Accounts')
        .doc(uid)
        .collection(_checktitle)
        .get()
        .then((value) => {
              if (value.docs.isEmpty) {_check = true} else {_check = false}
            });
    return _check;
  }

  void LectureDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: Column(
              children: [
                Text('알림'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '장바구니에 현재 강의가 들어가있습니다',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('확인'),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final _nickname = getName();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.mainColor,
        title: const Text('Lecture Page'),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
      drawer: Drawer(
          child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.mainColor,
          title: const Text('장바구니'),
          actions: [
            IconButton(
              onPressed: () async {
                final _titleEditController = TextEditingController();
                final _introEditController = TextEditingController();
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      final _nickname = getName();
                      return AlertDialog(
                        scrollable: true,
                        title: Text('커리큘럼 제목 설정'),
                        content: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextFormField(
                                controller: _titleEditController,
                                decoration: InputDecoration(
                                    labelText: '제목(단, _name제외)',
                                  border: OutlineInputBorder(),),
                                onChanged: (value) {
                                  _title = value;
                                  _check = checkName(value);
                                  print(_check);
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty || value == "_name") {
                                    return '제목을 입력하시거나 다른 것을 입력하세요';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              SizedBox(
                                width: 250,
                                child: TextFormField(
                                  controller: _introEditController,
                                  decoration: InputDecoration(
                                    labelText: '글을 작성해주세요(5글자 이상)',
                                    border: OutlineInputBorder(),
                                  ),
                                  maxLines: 10,
                                  onChanged: (value){
                                    _intro = value;
                                  },
                                  validator: (value){
                                    if(value == null || value.isEmpty){
                                      return '내용을 넣어주세요';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 50,
                              )
                            ],
                          ),
                        ),
                        actions: [
                          ElevatedButton(
                            onPressed: () async {
                              if (_check == false) {
                                showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        title: Column(
                                          children: [
                                            Text('알림'),
                                          ],
                                        ),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Text(
                                              '이름이 중복됩니다. 이름을 변경해주세요',
                                              style: TextStyle(
                                                fontSize: 20,
                                              ),
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('확인'),
                                          ),
                                        ],
                                      );
                                    });
                              }else if(_intro.length < 5 || _nickname == "_name"){
                                {
                                  showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(10),
                                          ),
                                          title: Column(
                                            children: [
                                              Text('알림'),
                                            ],
                                          ),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              const Text(
                                                '형식에 맞게 지정해주세요',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ],
                                          ),
                                          actions: [
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('확인'),
                                            ),
                                          ],
                                        );
                                      });
                                }
                              }
                              else {
                                try {
                                  await FirebaseFirestore.instance
                                      .collection('Cart')
                                      .doc(_nickname)
                                      .collection('test')
                                      .get()
                                      .then((querySnapshot) {
                                    querySnapshot.docs.forEach((result) {
                                      FirebaseFirestore.instance
                                      .collection('Curriculums').doc('${uid}_${_title}')
                                          // .collection('Lectures')
                                          // .doc(_nickname)
                                          .collection(_title)
                                          .doc()
                                          .set(result.data());
                                    });
                                  });
                                  await FirebaseFirestore.instance.collection('Curriculums')
                                  .doc('${_nickname}_${_title}').set({
                                    "commentsCount" : 0,
                                    "date" : Timestamp.now(),
                                    "intro" : _intro,
                                    "nickname" : _nickname,
                                    "scraps" : 0,
                                    "title" : _title,
                                  });
                                  await FirebaseFirestore.instance
                                      .collection('Cart')
                                      .doc(_nickname)
                                      .collection('test')
                                      .get()
                                      .then((querySnapshot) {
                                    querySnapshot.docs.forEach((result) {
                                      FirebaseFirestore.instance
                                          .collection('Accounts')
                                          .doc(uid)
                                          .collection(_title)
                                          .doc()
                                          .set(result.data());
                                    });
                                  });
                                  await FirebaseFirestore.instance
                                      .collection("Accounts")
                                      .doc(uid)
                                      .collection('_name')
                                      .doc(_title)
                                      .set({
                                    'name': _title,
                                  });
                                  var snapshots = await FirebaseFirestore
                                      .instance
                                      .collection('Cart')
                                      .doc(_nickname)
                                      .collection('test')
                                      .get();
                                  for (var ds in snapshots.docs) {
                                    await ds.reference.delete();
                                  }
                                  ;
                                  //async에서 Routing을 하려면 이 아래의 문구를 추가하여야 한다.
                                  if (!mounted) return;
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => HomePage(),
                                    ),
                                  );
                                } catch (e) {
                                  print(e);
                                }
                              }
                            },
                            child: Text('확인'),
                          ),
                        ],
                      );
                    });
                //타입이 바뀌니깐 async await는 필수다
              },
              icon: const Icon(Icons.add_task),
            ),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Cart')
                      .doc(_nickname)
                      .collection('test')
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
                            trailing: const Icon(Icons.delete),
                            onTap: () {
                              docs[index].reference.delete();
                            },
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(),
                    );
                  }),
            ),
          ],
        ),
      )),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
            //   child: TextField(
            //     onChanged: (value) {
            //       SearchName = value;
            //     },
            //     autofocus: true,
            //     decoration: InputDecoration(
            //       hintText: 'search keyword',
            //       border: InputBorder.none,
            //     ),
            //     cursorColor: Colors.grey,
            //   ),
            // ),
            Container(
              height: 100,
              child: SingleChildScrollView(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              if (_difficulty == "beginner") {
                                _difficulty = "";
                              } else {
                                _difficulty = "beginner";
                              }
                            });
                          },
                          child: const Text('입문'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _difficulty == "beginner"
                                ? AppColor.mainColor
                                : Colors.white,
                            foregroundColor: _difficulty == "beginner"
                                ? Colors.white
                                : AppColor.mainColor,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              if (_difficulty == "easy") {
                                _difficulty = "";
                              } else {
                                _difficulty = "easy";
                              }
                            });
                          },
                          child: const Text('초급'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _difficulty == "easy"
                                ? AppColor.mainColor
                                : Colors.white,
                            foregroundColor: _difficulty == "easy"
                                ? Colors.white
                                : AppColor.mainColor,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              if (_difficulty == "medium") {
                                _difficulty = "";
                              } else {
                                _difficulty = "medium";
                              }
                            });
                          },
                          child: const Text('중급'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _difficulty == "medium"
                                ? AppColor.mainColor
                                : Colors.white,
                            foregroundColor: _difficulty == "medium"
                                ? Colors.white
                                : AppColor.mainColor,
                          ),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              if (_lecture_field == "frontend") {
                                _lecture_field = "";
                              } else {
                                _lecture_field = "frontend";
                              }
                              print(_lecture_field);
                            });
                          },
                          child: const Text('Frontend'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _lecture_field == "frontend"
                                ? AppColor.mainColor
                                : Colors.white,
                            foregroundColor: _lecture_field == "frontend"
                                ? Colors.white
                                : AppColor.mainColor,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              if (_lecture_field == "backend") {
                                _lecture_field = "";
                              } else {
                                _lecture_field = "backend";
                              }
                              print(_lecture_field);
                            });
                          },
                          child: const Text('Backend'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _lecture_field == "backend"
                                ? AppColor.mainColor
                                : Colors.white,
                            foregroundColor: _lecture_field == "backend"
                                ? Colors.white
                                : AppColor.mainColor,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              if (_lecture_field == "java") {
                                _lecture_field = "";
                              } else {
                                _lecture_field = "java";
                              }
                              print(_lecture_field);
                            });
                          },
                          child: const Text('Java'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _lecture_field == "java"
                                ? AppColor.mainColor
                                : Colors.white,
                            foregroundColor: _lecture_field == "java"
                                ? Colors.white
                                : AppColor.mainColor,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              if (_lecture_field == "python") {
                                _lecture_field = "";
                              } else {
                                _lecture_field = "python";
                              }
                              print(_lecture_field);
                            });
                          },
                          child: const Text('Python'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _lecture_field == "python"
                                ? AppColor.mainColor
                                : Colors.white,
                            foregroundColor: _lecture_field == "python"
                                ? Colors.white
                                : AppColor.mainColor,
                          ),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              if (_media == "video") {
                                _media = "";
                              } else {
                                _media = "video";
                              }
                            });
                          },
                          child: const Text('동영상'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _media == "video"
                                ? AppColor.mainColor
                                : Colors.white,
                            foregroundColor: _media == "video"
                                ? Colors.white
                                : AppColor.mainColor,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              if (_media == "book") {
                                _media = "";
                              } else {
                                _media = "book";
                              }
                            });
                          },
                          child: const Text('서적'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _media == "book"
                                ? AppColor.mainColor
                                : Colors.white,
                            foregroundColor: _media == "book"
                                ? Colors.white
                                : AppColor.mainColor,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder(
                //정렬을 하는 방법은 저런식으로 진행해주면 된다! timestamp인 경우 마지막이 젤 아래인 형식!
                stream: (_lecture_field == "" &&
                        _difficulty == "" &&
                        _media == "")
                    ? FirebaseFirestore.instance
                        .collection('Lecture')
                        .snapshots()
                    : (_difficulty != "")
                        ? (_lecture_field != "")
                            ? (_media != "")
                                ? (FirebaseFirestore.instance
                                    .collection('Lecture')
                                    .where('difficulty', isEqualTo: _difficulty)
                                    .where('lecture_field',
                                        isEqualTo: _lecture_field)
                                    .where('media', isEqualTo: _media)
                                    .snapshots())
                                : (FirebaseFirestore.instance
                                    .collection('Lecture')
                                    .where('difficulty', isEqualTo: _difficulty)
                                    .where('lecture_field',
                                        isEqualTo: _lecture_field)
                                    .snapshots())
                            : (_media != "")
                                ? (FirebaseFirestore.instance
                                    .collection('Lecture')
                                    .where('difficulty', isEqualTo: _difficulty)
                                    .where('media', isEqualTo: _media)
                                    .snapshots())
                                : (FirebaseFirestore.instance
                                    .collection('Lecture')
                                    .where('difficulty', isEqualTo: _difficulty)
                                    .snapshots())
                        : (_lecture_field != "")
                            ? (_media != "")
                                ? FirebaseFirestore.instance
                                    .collection('Lecture')
                                    .where('lecture_field',
                                        isEqualTo: _lecture_field)
                                    .where('media', isEqualTo: _media)
                                    .snapshots()
                                : FirebaseFirestore.instance
                                    .collection('Lecture')
                                    .where('lecture_field',
                                        isEqualTo: _lecture_field)
                                    .snapshots()
                            : FirebaseFirestore.instance
                                .collection('Lecture')
                                .where('media', isEqualTo: _media)
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
                              Icons.add_circle,
                            ),
                            onPressed: () async {
                              final QuerySnapshot result =
                                  await FirebaseFirestore.instance
                                      .collection('Cart')
                                      .doc(_nickname)
                                      .collection('test')
                                      .where('name',
                                          isEqualTo: docs[index]['name'])
                                      .get();
                              final List<DocumentSnapshot> document =
                                  result.docs;
                              if (document.isEmpty) {
                                FirebaseFirestore.instance
                                    .collection('Cart')
                                    .doc(_nickname)
                                    .collection('test')
                                    .doc()
                                    .set(docs[index].data());
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text('장바구니에 추가하였습니다'),
                                ));
                              } else {
                                LectureDialog();
                              }
                            },
                          ),
                          title: Text('${docs[index]['name']}'),
                          subtitle: Wrap(children: [
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.book_outlined,
                                    color: AppColor.mainColor,
                                  ),
                                  onPressed: () {
                                  },
                                ),
                                Text('   ${docs[index]['lecture_field']}')
                              ],
                            )
                          ]),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
