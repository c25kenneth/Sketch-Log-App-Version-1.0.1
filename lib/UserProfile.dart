import 'package:canvas_vault/FirestoreFuncs.dart';
import 'package:canvas_vault/LoadingScreen.dart';
import 'package:canvas_vault/auth/Welcome.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('sketchbooks')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    automaticallyImplyLeading: false,
                    expandedHeight: screenHeight * 0.10,
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
                          color: Colors.orange,
                          child: SafeArea(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          icon: Icon(
                                            Icons.chevron_left_outlined,
                                            size: 35,
                                            color: Colors.white,
                                          )),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Text(
                                        "Profile",
                                        style: GoogleFonts.aBeeZee(
                                          color: Colors.white,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Account Info",
                            style: GoogleFonts.aBeeZee(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            snapshot.data!.docs.length.toString(),
                            style: GoogleFonts.aBeeZee(fontSize: 25),
                          ),
                          Text(
                            "Sketchbook(s)",
                            style: GoogleFonts.aBeeZee(
                                color: Colors.orange, fontSize: 16),
                          ),
                          SizedBox(height: 30),
                          Text(
                            "Details",
                            style: GoogleFonts.aBeeZee(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          ListView(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            children: [
                              ListTile(
                                onTap: () async {
                                  try {
                                    var url = Uri.https('getsketchlog.com');
                                    if (await canLaunchUrl(url)) {
                                      await launchUrl(url);
                                    }
                                  } catch (e) {}
                                },
                                leading: Icon(
                                  Icons.info_outline,
                                  color: Colors.orange,
                                ),
                                title: Text(
                                  "App Website",
                                  style: GoogleFonts.aBeeZee(fontSize: 17),
                                ),
                              ),
                              ListTile(
                                onTap: () async {
                                  try {
                                    var url = Uri.https('getsketchlog.com',
                                        '/terms-of-service');
                                    if (await canLaunchUrl(url)) {
                                      await launchUrl(url);
                                    }
                                  } catch (e) {
                                    setState(() {});
                                  }
                                },
                                leading: Icon(
                                  Icons.gavel_outlined,
                                  color: Colors.orange,
                                ),
                                title: Text(
                                  "Terms & Conditions",
                                  style: GoogleFonts.aBeeZee(fontSize: 17),
                                ),
                              ),
                              ListTile(
                                onTap: () async {
                                  try {
                                    var url = Uri.https('www.termsfeed.com',
                                        '/live/01e3ee3e-fe26-479e-9d10-3690dea9310c');
                                    if (await canLaunchUrl(url)) {
                                      await launchUrl(url);
                                    }
                                  } catch (e) {
                                    setState(() {});
                                  }
                                },
                                leading: Icon(
                                  Icons.policy_outlined,
                                  color: Colors.orange,
                                ),
                                title: Text(
                                  "Privacy Policy",
                                  style: GoogleFonts.aBeeZee(fontSize: 17),
                                ),
                              ),
                              ListTile(
                                onTap: () async {
                                  await FirebaseAuth.instance.signOut();
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  prefs.setBool("isLoggedIn", false);

                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) => Welcome()),
                                      (route) => false);
                                },
                                leading: Icon(
                                  Icons.logout_outlined,
                                  color: Colors.orange,
                                ),
                                title: Text(
                                  "Log Out",
                                  style: GoogleFonts.aBeeZee(fontSize: 17),
                                ),
                              ),
                              ListTile(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          surfaceTintColor: Colors.white,
                                          backgroundColor: Colors.white,
                                          title: Text("Delete Account?"),
                                          content: Text("This action will permanently delete all info stored on your account. This action is irreversible."),
                                          actions: [
                                            TextButton(onPressed: () async {
                                              await deleteAccount();
                                              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Welcome()), (route) => false);
                                            }, child: Text("Delete Account", style: TextStyle(color: Colors.red),)),
                                            TextButton(onPressed: (){
                                              Navigator.of(context).pop();
                                            }, child: Text("Cancel", style: TextStyle(color: Colors.grey)))
                                          ],
                                          actionsAlignment: MainAxisAlignment.start,
                                        );
                                      });
                                },
                                leading: const Icon(
                                  Icons.person_remove_alt_1_outlined,
                                  color: Colors.red,
                                ),
                                title: Text(
                                  "Delete Account",
                                  style: GoogleFonts.aBeeZee(fontSize: 17),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              );
            } else {
              return LoadingScreen();
            }
          }),
    );
  }
}
