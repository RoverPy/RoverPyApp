import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  //setting up an instance of Firebase, making it final so no one can override it
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //stream
  Stream<FirebaseUser> get userDetai {
    return _auth.onAuthStateChanged;
  }

  //registering with email and pass
  Future<FirebaseUser> registerWithEmailAndPass(String e, String p) async {
    try {
      AuthResult res =
          await _auth.createUserWithEmailAndPassword(email: e, password: p);
      FirebaseUser user = res.user;
      return user;
    } catch (err) {
      print("Caught an error while signing up! Error: $err");
      return null;
    }
  }

  //setting up sign in with email and pass
  Future<FirebaseUser> signInWithEmailAndPass(String e, String p) async {
    try {
      AuthResult res =
          await _auth.signInWithEmailAndPassword(email: e, password: p);
      FirebaseUser user = res.user;
      return user;
    } catch (err) {
      print("Caught an error: $err");
      return null;
    }
  }

  //Logout function
  void LogOut() async {
    try {
      await _auth.signOut();
    } catch (err) {
      print("Caught an error: $err");
    }
  }
}
