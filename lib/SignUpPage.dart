import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _authentication = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  String confirmPassword = "";
  String nickname = "";
  bool isValid = false;
  bool isValidName = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CAU Curriculum"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 300.0,
                      child: TextFormField(
                        decoration: const InputDecoration(
                            hintText: "이메일", border: OutlineInputBorder()),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "이메일을 입력해주세요";
                          } else {
                            return null;
                          }
                        },
                        onSaved: (value) => email = value!,
                      ),
                    ),
                    const SizedBox(width: 20.0),
                    SizedBox(
                      width: 60.0,
                      child: ElevatedButton(
                          onPressed: () {
                            // 아이디 중복 확인
                            _formKey.currentState!.save();
                            FirebaseFirestore.instance
                                .collection("Accounts")
                                .doc(email)
                                .get()
                                .then((DocumentSnapshot doc) {
                              if (email == doc['Email']) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text("중복된 이메일입니다"),
                                  duration: Duration(seconds: 2),
                                ));
                                isValid = false;
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text("사용 가능한 아이디입니다"),
                                  duration: Duration(seconds: 2),
                                ));
                                isValid = true;
                              }
                            });
                          },
                          child: const Text("중복 확인")),
                    )
                  ],
                ),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 300.0,
                      child: TextFormField(
                        decoration: const InputDecoration(
                            hintText: "닉네임", border: OutlineInputBorder()),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "닉네임을 입력해주세요";
                          } else {
                            return null;
                          }
                        },
                        onSaved: (value) => nickname = value!,
                      ),
                    ),
                    const SizedBox(width: 20.0),
                    SizedBox(
                      width: 60.0,
                      child: ElevatedButton(
                          onPressed: () {
                            // 닉네임 중복 확인
                            _formKey.currentState!.save();
                            FirebaseFirestore.instance
                                .collection("Accounts")
                                .doc(email)
                                .get()
                                .then((DocumentSnapshot doc) {
                              if (nickname == doc['UserName']) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text("중복된 닉네임입니다"),
                                  duration: Duration(seconds: 2),
                                ));
                                isValidName = false;
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text("사용 가능한 닉네임입니다"),
                                  duration: Duration(seconds: 2),
                                ));
                                isValidName = true;
                              }
                            });
                          },
                          child: const Text("중복 확인")),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 480.0,
                  child: TextFormField(
                    decoration: const InputDecoration(
                        hintText: "비밀번호", border: OutlineInputBorder()),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "비밀번호를 입력해주세요";
                      } else {
                        password = value;
                        return null;
                      }
                    },
                    onSaved: (value) => password = value!,
                  ),
                ),
                const SizedBox(height: 20.0),
                SizedBox(
                  width: 480.0,
                  child: TextFormField(
                      decoration: const InputDecoration(
                          hintText: "비밀번호 확인", border: OutlineInputBorder()),
                      validator: (value) {
                        if (value! != password) {
                          return "비밀번호가 일치하지 않습니다";
                        } else if (value.isEmpty) {
                          return "비밀번호를 한 번 더 입력해주세요";
                        } else {
                          confirmPassword = value;
                          return null;
                        }
                      },
                      onSaved: (value) => confirmPassword = value!),
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();

                        if ((isValid || isValidName) == false) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("아이디나 닉네임 중복 여부를 확인해주세요"),
                            duration: Duration(seconds: 2),
                          ));
                          return;
                        } else {
                          final newUser = await _authentication
                              .createUserWithEmailAndPassword(
                                  email: email, password: password);
                          await
                              // Add a new document.
                              FirebaseFirestore.instance
                                  .collection("Accounts")
                                  .doc(newUser.user!.uid)
                                  .set({
                            'UserName': nickname,
                            'Email': email,
                            'Password': password,
                          });
                          if (newUser.user != null) {
                            _formKey.currentState!.reset();
                            //async에서 Routing을 하려면 이 아래의 문구를 추가하여야 한다.
                            if (!mounted) return;
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("회원가입이 완료되었습니다"),
                              duration: Duration(seconds: 2),
                            ));
                          }
                        }
                      }
                    },
                    child: const Text("회원가입")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
