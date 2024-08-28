import 'package:canvas_vault/AddSketchbook.dart';
import 'package:canvas_vault/ErrorScreen.dart';
import 'package:canvas_vault/LoadingScreen.dart';
import 'package:canvas_vault/UserProfile.dart';
import 'package:canvas_vault/components/GradientButton.dart';
import 'package:canvas_vault/components/NotebookTile.dart';
import 'package:canvas_vault/components/SearchBarComponent.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  final String uid;
  const HomeScreen({super.key, required this.uid});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  var searchName = "";

  @override
  void dispose() {
    _searchController.dispose(); 
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("users")
          .doc(widget.uid)
          .collection("sketchbooks")
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
            return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .doc(widget.uid)
                  .collection("sketchbooks")
                  .limit(4)
                  .orderBy("time", descending: true)
                  .snapshots(),
              builder: (context, snapshot2) {
                if (snapshot2.hasData) {
                  return GestureDetector(
                    onTap: () =>
                        FocusManager.instance.primaryFocus?.unfocus(),
                    child: Scaffold(
                      floatingActionButton: FloatingActionButton(
                        backgroundColor: Colors.orangeAccent,
                        tooltip: "Add Sketchbook",
                        onPressed: () async {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const AddSketchbook()));
                        },
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                      ),
                      body: CustomScrollView(
                        slivers: [
                          SliverAppBar(
                            expandedHeight: screenHeight * 0.20,
                            pinned: true,
                            backgroundColor: Colors.white,
                            flexibleSpace: FlexibleSpaceBar(
                              titlePadding:
                                  const EdgeInsets.only(left: 16.0, bottom: 16.0),
                              background: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(30.0),
                                  bottomRight: Radius.circular(30.0),
                                ),
                                child: Container(
                                  color: const Color.fromRGBO(236, 183, 102, 0.7),
                                  child: SafeArea(
                                    child: Padding(
                                      padding: const EdgeInsets.all(18.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                "Get Started",
                                                style: GoogleFonts.aBeeZee(
                                                  color: Colors.black,
                                                  fontSize: 26,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),

                                              const Spacer(),
                                              
                                              IconButton(
                                                tooltip: "Profile",
                                                onPressed: () async {
                                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => UserProfile()));
                                              }, icon: const Icon(Icons.settings_outlined, color: Colors.deepOrange, size: 30,))
                                            ],
                                          ),
                                          const SizedBox(height: 15),
                                          SearchInput(
                                            onClick: () {
                                              showSearch(context: context, delegate: CustomSearchDelegate(searchItems: snapshot.data!.docs.map((e) {
                                                return NotebookTile(title: e.get('sketchbookTitle'), description: e.get('sketchbookDescription'), sketchbookID: e.id);
                                              }).toList()));
                                            },
                                            textController: _searchController, 
                                            hintText: "Search your sketchbooks",
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          (snapshot.data!.docs.isNotEmpty) ? 
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 18),
                                  Row(
                                    children: [
                                      Text(
                                        "Your Sketchbooks",
                                        style: GoogleFonts.aBeeZee(
                                          color: Colors.black,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Spacer(),
                                      GestureDetector(
                                        onTap: () {
                                          showSearch(context: context, delegate: CustomSearchDelegate(searchItems: snapshot.data!.docs.map((e) {
                                            return NotebookTile(title: e.get('sketchbookTitle'), description: e.get('sketchbookDescription'), sketchbookID: e.id);
                                          }).toList()));
                                        },
                                        child: Text(
                                          "See All",
                                          style: GoogleFonts.aBeeZee(
                                            color: const Color.fromRGBO(
                                                3, 201, 169, 0.7),
                                            fontSize: 18,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  ListView.builder(
                                    padding: const EdgeInsets.only(top: 12),
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: snapshot2.data?.docs.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(top: 12.0),
                                        child: NotebookTile(
                                          title: snapshot2
                                              .data?.docs[index]
                                              .get('sketchbookTitle'),
                                          description: snapshot2
                                              .data?.docs[index]
                                              .get('sketchbookDescription'),
                                          sketchbookID: snapshot2
                                              .data!.docs[index].id,
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ) : SliverToBoxAdapter(
                            child: Column(
                              children: [
                                const SizedBox(height: 32),
                                const Text(
                                  "You have no sketchbooks",
                                  style: TextStyle(
                                      fontSize: 22, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 25),
                                SvgPicture.asset(
                                  "assets/images/undraw_add_information_j2wg.svg",
                                  width: (screenWidth) * 0.75,
                                  height: (screenWidth) * 0.42,
                                ),
                                const SizedBox(height: 30),
                                GradientButtonFb1(
                                    text: "Create Sketchbook",
                                    onPressed: () async {
                                      Navigator.of(context).push(MaterialPageRoute(
                                          builder: (context) => const AddSketchbook()));
                                    })
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                } else if (snapshot2.connectionState == ConnectionState.waiting){
                  return const LoadingScreen();
                } else {
                  return const ErrorScreen();
                }
              },
            );
        } else if (snapshot.connectionState == ConnectionState.waiting){
          return const LoadingScreen();
        } else {
          return const ErrorScreen();
        }
      },
    );
  }
}


class CustomSearchDelegate extends SearchDelegate {
  final List searchItems; 

  CustomSearchDelegate({required this.searchItems});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(onPressed: () {
        query = ''; 
      }, icon: const Icon(Icons.clear_outlined))
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(onPressed: (){
      close(context, null);
    }, icon: const Icon(Icons.arrow_back_outlined));
  }

  @override
  Widget buildResults(BuildContext context) {
    List matchQuery = [];
    for (var player in searchItems) {
      if (player.title.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(player); 
      }
    }

    return ListView.builder(itemBuilder: (context, index) {
      var result = matchQuery[index];
      return Padding(child: result, padding: const EdgeInsets.fromLTRB(12, 18, 12, 0),); 
    });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List matchQuery = [];
    for (var player in searchItems) {
      if (player.title.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(player); 
      }
    }

    return ListView.builder(itemCount: matchQuery.length, itemBuilder: (context, index) {
      var result = matchQuery[index];
      return Padding(child: result, padding: const EdgeInsets.fromLTRB(12, 18, 12, 0),); 
    });
  }
}