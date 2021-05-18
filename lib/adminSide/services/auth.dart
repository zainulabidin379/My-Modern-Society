import 'package:firebase_auth/firebase_auth.dart';
import '../shared/user.dart';
import 'services.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String getCurrentUser() {
    final User user = _auth.currentUser!;
    final uid = user.uid;
    return uid;
  }

  // create user obj based on firebase user
  TheUser? _userFromFirebaseUser(User? user) {
    return user != null ? TheUser(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<TheUser?> get user {
    return _auth
        .authStateChanges()
        // .map((User user) => _userFromFirebaseUser(user));
        .map(_userFromFirebaseUser);
  }

  // sign in anon
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

// sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return user;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

// register with email and password
  Future registerWithEmailAndPassword(String name, String email, String cnic, String address, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User user = result.user!;

      //create a new document for the user with the uid
      await DatabaseService(uid: user.uid).addUserData(name, email,cnic, address);

      return _userFromFirebaseUser(user);
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    return _auth.sendPasswordResetEmail(email: email);
  }
  
// sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
