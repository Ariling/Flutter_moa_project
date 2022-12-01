import 'package:flutter/material.dart';
import 'package:project_demo/LecturePage.dart';
import 'package:project_demo/Styles.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lecture_info = ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.mainColor,
        title: Text('${lecture_info[0]["name"]}'),
      ),
      body: ListView(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.4,
            padding: EdgeInsets.all(10),
            child: Text(
              lecture_info[0]["name"],
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.7,
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('영상을 보고 싶으시다면 해당 버튼을 눌러주세요'),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: 200.0,
                  child: ElevatedButton(onPressed: (){
                    final url = Uri.parse( lecture_info[0]["url"]);
                    launchUrl(url);
                  }, child: Text(
                    "link",
                  ),),
                ),
              ],
            )
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.7,
            padding: EdgeInsets.all(10),
            child: Text(
              '${lecture_info[0]['introduce']}'
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.7,
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('난이도 : ' + lecture_info[0]["difficulty"]),
                    Text('분야 : ' + lecture_info[0]["lecture_field"]),
                    Text('${lecture_info[0]['media']}')
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
