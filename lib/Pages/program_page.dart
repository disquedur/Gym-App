import 'dart:core';

import 'package:flutter/material.dart';

class ProgramPage extends StatefulWidget {
  final bool darkMode;

  const ProgramPage({super.key, required this.darkMode});

  @override
  State<ProgramPage> createState() => _ProgramPageState();
}

@override
class _ProgramPageState extends State<ProgramPage> {
  Map<int, List<String>> topicList = {};
  Map<int, List<String>> textList = {};
  String theme = "white";
  String lang = "en";
  List<String> topicsName = [];
  final List<List<String>> topicImages = [];

  List<List<String>> topicText = [];

  void fillTopicImages() {
    for (int i = 0; i < topicImages.length; i++) {
      topicList[i] = topicImages[i];
      textList[i] = topicText[i];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Program"),
      ),
      body: Scrollbar(
        thickness: 15,
        thumbVisibility: true,
        child: Container(
          color: theme == "dark"
              ? Colors.green[800]
              : Color.fromARGB(255, 207, 241, 207),
          child: ListView.builder(
            itemCount: topicsName.length,
            itemBuilder: (context, index) {
              return Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: 450,
                    width: 450,
                    child: displayHelpTopics(context, topicList[index]!),
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          color: Color.fromARGB(255, 204, 238, 248),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(topicsName[index],
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w700)),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.resolveWith<Color?>(
                            (Set<MaterialState> states) {
                              return Color.fromARGB(255, 231, 227, 221);
                            },
                          ),
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color?>(
                            (Set<MaterialState> states) {
                              return Color.fromARGB(255, 31, 89, 96);
                            },
                          ),
                        ),
                        onPressed: () => {},
                        child: Icon(Icons.info),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  displayHelpTopics(BuildContext context, List<String> imagePath) {
    return Padding(
        padding: const EdgeInsets.all(50.0),
        child: Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            child: Image.asset(
              imagePath[0],
            ),
          ),
        ));
  }
}
