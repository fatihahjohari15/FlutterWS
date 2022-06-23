import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//import 'package:mytutor/models/subject.dart';
import '../constants.dart';
import '../models/tutor.dart';

class TutorScreen extends StatefulWidget {
  const TutorScreen({Key? key}) : super(key: key);

  @override
  State<TutorScreen> createState() => _TutorScreenState();
}

class _TutorScreenState extends State<TutorScreen> {
  List<Tutor>? tutorList = <Tutor>[];
  //List<Subject> subjectList = <Subject>[];

  String titlecenter = "Loading...";
  late double screenHeight, screenWidth, resWidth;
  var numofpage, curpage = 1;
  var color;

  TextEditingController searchController = TextEditingController();
  String search = "";

  @override
  void initState() {
    super.initState();
    _loadTutors(1, search);
    //_loadSubjects(1, search);
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
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              _loadSearchDialog();
            },
          )
        ],
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
                  child: Text("List of Tutors Available",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 15),
                Expanded(
                    child: GridView.count(
                        crossAxisCount: 2,
                        childAspectRatio: (1 / 1.8),
                        children: List.generate(tutorList!.length, (index) {
                          return InkWell(
                              onTap: () => {_loadTutorDetails(index)},
                              child: Card(
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      color:
                                          Theme.of(context).colorScheme.outline,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                  ),
                                  color:
                                      const Color.fromARGB(255, 242, 238, 238),
                                  child: Column(
                                    children: [
                                      Flexible(
                                        flex: 6,
                                        child: CachedNetworkImage(
                                          imageUrl: CONSTANTS.server +
                                              "/mytutor/mobile/assets/tutors/" +
                                              tutorList![index]
                                                  .tutorID
                                                  .toString() +
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
                                                        fontWeight:
                                                            FontWeight.bold)),
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
                                  )));
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
                            onPressed: () => {_loadTutors(index + 1, "")},
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

  void _loadTutors(int pageno, String _search) {
    curpage = pageno;
    numofpage ?? 1;
    http.post(
        Uri.parse(CONSTANTS.server + "/mytutor/mobile/php/load_tutors.php"),
        body: {'pageno': pageno.toString(), 'search': _search}).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        return http.Response('Error', 408);
      },
    ).then((response) {
      var jsondata = jsonDecode(response.body);

      print(jsondata);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        var extractdata = jsondata['data'];
        numofpage = int.parse(jsondata['numofpage']);

        if (extractdata['tutors'] != null) {
          tutorList = <Tutor>[];
          extractdata['tutors'].forEach((v) {
            tutorList!.add(Tutor.fromJson(v));
          });
          titlecenter = tutorList!.length.toString() + " Products Available";
        } else {
          titlecenter = "No Tutor Available";
          tutorList!.clear();
        }

        setState(() {});
      } else {
        titlecenter = "No Tutor Available";
        tutorList!.clear();
        setState(() {});
      }
    });
  }

  void _loadSearchDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return StatefulBuilder(
            builder: (context, StateSetter setState) {
              return AlertDialog(
                backgroundColor: const Color.fromARGB(255, 228, 188, 235),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0))),
                title: const Text(
                  "Search ",
                ),
                content: SizedBox(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                            labelText: 'Search Tutor Name',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                      ),
                    ],
                  ),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      search = searchController.text;
                      Navigator.of(context).pop();
                      _loadTutors(1, search);
                    },
                    child: const Text("Search"),
                  )
                ],
              );
            },
          );
        });
  }

  _loadTutorDetails(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: const Color.fromARGB(255, 228, 188, 235),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0))),
            title: const Text(
              ">> Tutor Details <<",
            ),
            content: SingleChildScrollView(
                child: Column(
              children: [
                CachedNetworkImage(
                  imageUrl: CONSTANTS.server +
                      "/mytutor/mobile/assets/tutors/" +
                      tutorList![index].tutorID.toString() +
                      '.jpg',
                  fit: BoxFit.cover,
                  width: resWidth,
                  placeholder: (context, url) =>
                      const LinearProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
                const SizedBox(height: 20),
                Text(
                  tutorList![index].tutorName.toString(),
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const SizedBox(height: 30),
                  Text("Description: \n\n" +
                      tutorList![index].tutorDescription.toString()),
                  const SizedBox(height: 20),
                  Text("Tutor ID: " + tutorList![index].tutorID.toString()),
                  const SizedBox(height: 20),
                  Text("Email: " + (tutorList![index].tutorEmail.toString())),
                  const SizedBox(height: 20),
                  Text("Phone Number: " +
                      tutorList![index].tutorPhone.toString()),
                  const SizedBox(height: 20),
                  Text("Subject Owned: " +
                      tutorList![index].subjectName.toString()),
                ]),
              ],
            )),
          );
        });
  }
}
