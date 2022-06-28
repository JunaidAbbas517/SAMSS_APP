import 'package:firebase_auth/firebase_auth.dart';

import 'package:samss/consumer/services/user_model.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //create user  obj based on firebase
  Users? _userFromFirebase(User user) {
    return user != null ? Users(uid: user.uid) : null;
  }

  //auth change user sign
  Stream<Users?> get user {
    return _auth
        .authStateChanges()
        .map((User? user) => _userFromFirebase(user!));
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
