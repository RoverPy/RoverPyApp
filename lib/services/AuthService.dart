import 'package:firebase_auth/firebase_auth.dart';
import 'package:sign_in/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  //setting up an instance of Firebase, making it final so no one can override it
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;

  //stream
  Stream<FirebaseUser> get userDetail {
    return _auth.onAuthStateChanged;
  }

  User createUser(FirebaseUser user) {
    return user == null? null: User(uid: user.uid);
  }

  //registering with email and pass
  Future registerWithEmailAndPass(String e, String p) async {
    try {
      AuthResult res =
          await _auth.createUserWithEmailAndPassword(email: e.trim(), password: p.trim());
      FirebaseUser user = res.user;
      return createUser(user);
    } catch (err) {
      print("Caught an error while signing up! Error: $err");
      return null;
    }
  }

  //setting up sign in with email and pass
  Future signInWithEmailAndPass(String e, String p, String n) async {
    try {
      AuthResult res =
          await _auth.signInWithEmailAndPassword(email: e.trim(), password: p.trim());
      UserUpdateInfo updateInfo = UserUpdateInfo();
      updateInfo.displayName = n;
      res.user.updateProfile(updateInfo);
      FirebaseUser user = res.user;
      return createUser(user);
    } catch (err) {
      print("Caught an error: $err");
      return null;
    }
  }

  Future getCurrentUserName() async {
    try{
      int counter = 0;
      FirebaseUser user = await _auth.currentUser();
      DocumentReference document = Firestore.instance.document('users/${user.uid}');
      dynamic d = await document.get().then((value) {
        counter = value['completed'];
        return [user.displayName, counter];
      });
      return d;
    }catch (err){
      print("Caught an error: $err");
      return null;
    }
  }


  //Logout function
  void logOut() async {
    try {
      await _auth.signOut();
    } catch (err) {
      print("Caught an error: $err");
    }
  }
}
