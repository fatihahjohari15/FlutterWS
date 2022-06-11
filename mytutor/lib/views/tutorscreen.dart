import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../models/tutor.dart';

class TutorScreen extends StatefulWidget {
  const TutorScreen({Key? key}) : super(key: key);

  @override
  State<TutorScreen> createState() => _TutorScreenState();
}

class _TutorScreenState extends State<TutorScreen> {
  List<Tutor>? tutorList = <Tutor>[];
  String titlecenter = "Loading...";
  late double screenHeight, screenWidth, resWidth;
  var numofpage, curpage = 1;
  var color;

  @override
  void initState() {
    super.initState();
    _loadTutors(1);
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
    } else {
      resWidth = screenWidth * 0.75;
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 211, 168, 197),
      appBar: AppBar(
        title: const Text('MY Tutor', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: tutorList!.isEmpty
          ? Center(
              child: Text(titlecenter,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold)))
          : Column(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Text("List of Tutors",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 15),
                Expanded(
                    child: GridView.count(
                        crossAxisCount: 2,
                        childAspectRatio: (1 / 1.8),
                        children: List.generate(tutorList!.length, (index) {
                          return Card(
                              child: Column(
                            children: [
                              Flexible(
                                flex: 6,
                                child: CachedNetworkImage(
                                  imageUrl: CONSTANTS.server +
                                      "/mytutor/mobile/assets/tutors/" +
                                      tutorList![index].tutorID.toString() +
                                      '.jpg',
                                  placeholder: (context, url) =>
                                      const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Flexible(
                                  flex: 4,
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Text(
                                            tutorList![index]
                                                .tutorName
                                                .toString(),
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold)),
                                        const SizedBox(height: 5),
                                        Text(
                                          "Tutor ID : " +
                                              tutorList![index]
                                                  .tutorID
                                                  .toString(),
                                          style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.purple),
                                        ),
                                        const SizedBox(height: 5),
                                        const Text("Email :",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.purple)),
                                        Text(
                                          tutorList![index]
                                              .tutorEmail
                                              .toString(),
                                          style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.purple),
                                        ),
                                        const SizedBox(height: 5),
                                        const Text("Phone Number :",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.purple)),
                                        Text(
                                            tutorList![index]
                                                .tutorPhone
                                                .toString(),
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.purple)),
                                        const SizedBox(height: 5),
                                      ],
                                    ),
                                  ))
                            ],
                          ));
                        }))),
                SizedBox(
                  height: 30,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: numofpage,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      if ((curpage - 1) == index) {
                        color = Colors.white;
                      } else {
                        color = Colors.black;
                      }
                      return SizedBox(
                        width: 40,
                        child: TextButton(
                            onPressed: () => {_loadTutors(index + 1)},
                            child: Text(
                              (index + 1).toString(),
                              style: TextStyle(color: color),
                            )),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  void _loadTutors(int pageno) {
    curpage = pageno;
    numofpage ?? 1;
    http.post(
        Uri.parse(CONSTANTS.server + "/mytutor/mobile/php/load_tutors.php"),
        body: {'pageno': pageno.toString()}).then((response) {
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        var extractdata = jsondata['data'];
        numofpage = int.parse(jsondata['numofpage']);
        if (extractdata['tutors'] != null) {
          tutorList = <Tutor>[];
          extractdata['tutors'].forEach((v) {
            tutorList!.add(Tutor.fromJson(v));
          });
          setState(() {});
        } else {
          titlecenter = "No Tutor Available";
          setState(() {});
        }
      }
    });
  }
}
