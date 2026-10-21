import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthServices {
  // for storing data in cloud store
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // for authentication
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

// for signup user

  Future<String> signUpUser(
      {required String email,
      required String password,
      required String name,
      required String phone}) async {
    String res = "Some error occurred";

    try {
      // for register user with email and password
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Default user image
      String profImg = "https://drive.google.com/file/d/1eI2RRkD-JJ7fPeeFCMkw-E3HO1rbBX3R/view?usp=drive_link";

      // for adding user in cloud storage
      await _firestore.collection("users").doc(credential.user!.uid).set({
        'email': email,
        'name': name,
        'phone': phone,
        'profileImage' : profImg,
        'uid': credential.user!.uid,
      });

      res = "Success";
    } catch (e) {
      return e.toString();
    }
    return res;
  }

  // for login user

  Future<String> logInUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "Success";
      } else {
        res = "Please enter all fields";
      }
    } catch (e) {
      return e.toString();
    }

    return res;
  }

  // for signOut
  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut(); // Ensure Google Sign-Out
  }

  // 🔹 **Google Sign-In**
  Future<String> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return "Cancelled by user"; // User canceled sign-in

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        // Check if user exists in Firestore
        DocumentSnapshot userDoc = await _firestore.collection("users").doc(user.uid).get();
        if (!userDoc.exists) {
          await _firestore.collection("users").doc(user.uid).set({
            'email': user.email,
            'name': user.displayName ?? "",
            'profileImage': user.photoURL ?? "",
            'uid': user.uid,
          });
        }
      }
      return "Success";
    } catch (e) {
      return e.toString();
    }
  }


}
