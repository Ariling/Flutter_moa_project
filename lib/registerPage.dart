// import 'package:flutter/material.dart';
//
// void _submit() {
//   _userProvider.email = _emailConroller.text;
//   Navigator.push(context,
//       MaterialPageRoute(builder: ((context) => EnrollPasswordWidget())));
// }
//
// void _checkEmail() async {
//   // 정규표현식
//   String pattern =
//       r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
//   RegExp regExp = new RegExp(pattern);
//
//   // 중복 이메일 검사
//   bool duplicate = false;
//   try {
//     var duplicate_email =
//     await _firestore.get().then((QuerySnapshot snapshot) {
//       snapshot.docs.forEach((doc) {
//         print(doc["email"]);
//         if (_emailConroller.text == doc["email"]) {
//           duplicate = true;
//         }
//       });
//     });
//   } catch (e) {
//     print(e);
//     duplicate = false;
//   }
//   if (duplicate) {
//     setState(() {
//       _errorMsg = "이미 이메일이 존재합니다.";
//     });
//   } else if (!regExp.hasMatch(_emailConroller.text)) {
//     setState(() {
//       _errorMsg = "올바르게 이메일을 입력하세요";
//     });
//   } else {
//     setState(() {
//       _errorMsg = "";
//     });
//     _userProvider.email = _emailConroller.text;
//     _submit();
//   }
// }