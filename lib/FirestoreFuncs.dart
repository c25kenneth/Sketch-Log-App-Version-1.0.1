

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

FirebaseFirestore _db = FirebaseFirestore.instance;
FirebaseAuth _auth = FirebaseAuth.instance;
FirebaseStorage storage = FirebaseStorage.instance;

dynamic createSketchbook(String uid, String sketchbookTitle, String sketchbookDescription) async {
  try {
    await _db.collection("users").doc(uid).collection("sketchbooks").doc().set({"sketchbookTitle": sketchbookTitle, "sketchbookDescription": sketchbookDescription, "imageList": FieldValue.arrayUnion([]), "notes": [{"insert" : "\n"}], "time": Timestamp.fromDate(DateTime.now()), "elapsedTime": 0});
    return "Success!";
  } catch (e) {
    return e;
  }
}

dynamic deleteSketchbook(String uid, String sketchbookID) async {
  try {
    await _db.runTransaction((transaction) async {
      Reference folderRef = storage.ref().child("${_auth.currentUser!.uid}/$sketchbookID");
      ListResult result = await folderRef.listAll();

      for (Reference fileRef in result.items) {
        await fileRef.delete();
      }

      Future<void> deleteSubcollection(DocumentReference docRef, String subcollectionName) async {
        CollectionReference subcollectionRef = docRef.collection(subcollectionName);
        QuerySnapshot subcollectionSnapshot = await subcollectionRef.get();

        for (QueryDocumentSnapshot doc in subcollectionSnapshot.docs) {
          await deleteSubcollection(doc.reference, subcollectionName);
          await doc.reference.delete();
        }
      }

      DocumentReference sketchbookDocRef = _db.collection("users").doc(uid).collection("sketchbooks").doc(sketchbookID);

      await deleteSubcollection(sketchbookDocRef, "sessions");

      await sketchbookDocRef.delete();
    });

    return "Success!";
  } catch (e) {
    print(e.toString());
    return e;
  }
}


dynamic updateSketchbookSettings(String sketchbookID, String newTitle, String newDescription) async {
  try { 
    await _db.collection("users").doc(_auth.currentUser!.uid).collection("sketchbooks").doc(sketchbookID).update({"sketchbookTitle": newTitle, "sketchbookDescription": newDescription, "time": Timestamp.fromDate(DateTime.now()),});
    return "Success!";
  } catch (e) {
    return e; 
  }
}

dynamic addImage(String sketchbookID, File image) async {
  try {
    final storageRef = FirebaseStorage.instance.ref();
    final imageRef = storageRef.child("${_auth.currentUser!.uid}/$sketchbookID/${DateTime.now()}.jpg");
    await imageRef.putFile(image);

    String downloadURl = await imageRef.getDownloadURL();
    _db.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).collection("sketchbooks").doc(sketchbookID).update({"imageList": FieldValue.arrayUnion([downloadURl])});
    return "Success!";
  } catch (e) {
    return e; 
  }
}

dynamic updateSketchbookNotes (String sketchbookID, List<Map<String, dynamic>> text) async {
  try {
    await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).collection("sketchbooks").doc(sketchbookID).update({"notes": text, "time": Timestamp.fromDate(DateTime.now()),});
    return "Success!";
  } catch (e) {
    return e; 
  }

}

Future<DocumentSnapshot> getNotesJson(String sketchbookID) async {
  try {
    DocumentSnapshot notesDoc = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("sketchbooks")
        .doc(sketchbookID)
        .get();
    return notesDoc;
  } catch (e) {
    throw e;
  }
}

dynamic deleteImage(String sketchbookID, String imageURL) async {
  try {
    await _db.runTransaction((transaction) async {
      Reference imageRef = storage.refFromURL(imageURL);
      await imageRef.delete();

      DocumentReference docRef = FirebaseFirestore.instance.collection('users').doc(_auth.currentUser!.uid).collection("sketchbooks").doc(sketchbookID);
      await docRef.update({
        "imageList": FieldValue.arrayRemove([imageURL])
      });
    });
    return "Success"; 
  } catch (e) {
    return e; 
  }
}

dynamic signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      
      UserCredential cred = await FirebaseAuth.instance.signInWithCredential(credential);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool("isLoggedIn", true);
      prefs.setString("uid", cred.user!.uid);
      
      return cred;
    } catch (e) {
      return "Error signing in with Google. Please try again.";
    }
  }

dynamic signInWithApple() async {
  try {
    final appleProvider = AppleAuthProvider();

    UserCredential cred = await FirebaseAuth.instance.signInWithProvider(appleProvider);
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setBool("isLoggedIn", true);
    prefs.setString("uid", cred.user!.uid);
      
    return cred;
  } catch (e) {
    return "Error signing in with Apple. Please try again.";
  }
}

dynamic createSession(String sketchbookID, String sessionTitle, DateTime timeStamp) async {
  try {
    await _db.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).collection('sketchbooks').doc(sketchbookID).collection("sessions").add({'elapsedTime': 0, 'sessionTitle': sessionTitle, "status": "incomplete", "time":FieldValue.serverTimestamp(),});
    return "Success!"; 
  } catch (e) {
    return e; 
  }
}

dynamic updateSessionTime(String sketchbookID, String sessionID, Duration elapsed, String sessionTitle) async {
  try {
    await _db.runTransaction((transaction) async {
      await _db.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('sketchbooks').doc(sketchbookID).collection('sessions').doc(sessionID).update({'elapsedTime': elapsed.inSeconds, "sessionTitle" : sessionTitle, 'status': "complete"});
      await _db.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('sketchbooks').doc(sketchbookID).update({'elapsedTime': FieldValue.increment(elapsed.inSeconds)});
    });
    return "Success!";
  } catch (e) {
    return e; 
  } 
}

dynamic updateSessionTitle(String sketchbookID, String sessionID, String title) async {
  try {
    await _db.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('sketchbooks').doc(sketchbookID).collection('sessions').doc(sessionID).update({"sessionTitle": title});
    return "Success!";
  } catch (e) {
    return e; 
  }
}

dynamic deleteSession(String sketchbookID, int elapsed, String sessionID) async {
  try {
    await _db.runTransaction((transaction) async {
      await _db.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('sketchbooks').doc(sketchbookID).collection('sessions').doc(sessionID).delete(); 
      await _db.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('sketchbooks').doc(sketchbookID).update({'elapsedTime': FieldValue.increment(elapsed * -1)});
    });
    return "Success!";
  } catch (e) {
    return e; 
  }
}

dynamic deleteSessionIncomplete(String sketchbookID, String sessionID) async {
  try {
    await _db.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('sketchbooks').doc(sketchbookID).collection('sessions').doc(sessionID).delete(); 
    return "Success!";
  } catch (e) {
    return e; 
  }
}

Future<void> deleteAllImages(String mainFolder) async {
    try {
      Reference mainFolderRef = storage.ref().child(mainFolder);

      await _deleteFilesRecursively(mainFolderRef);


    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _deleteFilesRecursively(Reference ref) async {
    ListResult result = await ref.listAll();

    for (Reference fileRef in result.items) {
      await fileRef.delete();
    }

    for (Reference folderRef in result.prefixes) {
      await _deleteFilesRecursively(folderRef);
    }
  }



Future<void> deleteAllImagesAccount(String uid) async {
  Reference folderRef = storage.ref().child(uid);
  ListResult result = await folderRef.listAll();

  for (Reference fileRef in result.items) {
    await fileRef.delete();
  }
}

Future<void> deleteSubcollectionDocuments(CollectionReference collectionRef) async {
  var subcollectionSnapshot = await collectionRef.get();
  for (QueryDocumentSnapshot doc in subcollectionSnapshot.docs) {
    await deleteSubcollections(doc.reference);
    await doc.reference.delete();
  }
}

Future<void> deleteSketchbooks(DocumentReference userDocRef) async {
  CollectionReference sketchbooksRef = userDocRef.collection('sketchbooks');
  await deleteSubcollectionDocuments(sketchbooksRef);
}

Future<void> deleteSubcollections(DocumentReference docRef) async {
  List<String> subcollectionNames = ['sessions']; 

  for (String subcollectionName in subcollectionNames) {
    CollectionReference subcollectionRef = docRef.collection(subcollectionName);
    await deleteSubcollectionDocuments(subcollectionRef);
  }
}

Future<dynamic> deleteAccount() async {
  try {
    final providerData = FirebaseAuth.instance.currentUser?.providerData.first;
    _db.runTransaction((transaction) async {
      if (AppleAuthProvider().providerId == providerData!.providerId) {
      await FirebaseAuth.instance.currentUser!
          .reauthenticateWithProvider(AppleAuthProvider());
    } else if (GoogleAuthProvider().providerId == providerData.providerId) {
      await FirebaseAuth.instance.currentUser!
          .reauthenticateWithProvider(GoogleAuthProvider());
    }
      String uid = FirebaseAuth.instance.currentUser!.uid;

      await deleteAllImages(uid);

      DocumentReference userDocRef = _db.collection('users').doc(uid);
      await deleteSketchbooks(userDocRef);

      await userDocRef.delete();

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove("isLoggedIn");
      prefs.remove("uid");
      await FirebaseAuth.instance.currentUser!.delete();
    });

    return "Success!";
  } catch (e) {

    return e;
  }
}


dynamic _reauthenticateAndDelete() async {
  try {
    final providerData = FirebaseAuth.instance.currentUser?.providerData.first;

    if (AppleAuthProvider().providerId == providerData!.providerId) {
      await FirebaseAuth.instance.currentUser!
          .reauthenticateWithProvider(AppleAuthProvider());
    } else if (GoogleAuthProvider().providerId == providerData.providerId) {
      await FirebaseAuth.instance.currentUser!
          .reauthenticateWithProvider(GoogleAuthProvider());
    }
    _db.runTransaction((transaction) async {
      String uid = FirebaseAuth.instance.currentUser!.uid;

      await deleteAllImages(uid);

      DocumentReference userDocRef = _db.collection('users').doc(uid);
      await deleteSketchbooks(userDocRef);

      await userDocRef.delete();

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove("isLoggedIn");
      prefs.remove("uid");
      await FirebaseAuth.instance.currentUser!.delete();
    });

    return "Success"; 
  } catch (e) {

  }
}