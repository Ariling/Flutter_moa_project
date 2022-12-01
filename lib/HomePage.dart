import 'package:flutter/material.dart';
import 'package:project_demo/Styles.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.mainColor,
        title: const Text('Main Page'),
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 200.0,
                height: 30.0,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/LecturePage');
                  },
                  child: Text('강의추가'),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
