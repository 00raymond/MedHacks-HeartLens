import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthenticationService(FirebaseAuth instance);

  get authStateChanges => null;

  /// Use to sign in, will check for patient status. Only patients can sign into the mobile app.
  Future signIn({
    required String email,
    required String password
  }) async {
    try {
      UserCredential user = await _auth.signInWithEmailAndPassword(email: email, password: password);
      
      // Check if user is patient. users/{uid}/userType === 'patient'? if so, continue, else sign out, throw invalid user type error.
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.user!.uid).get();
      if (userDoc.exists) {
        if ((userDoc.data() as Map<String, dynamic>)['userType'] == 'patient') {
          return "success";
        } else {
          await _auth.signOut();
          throw 'Invalid user type';
        }
      } else {
        await _auth.signOut();
        throw 'Invalid user type';
      }
    }
    on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  /// Use to sign out of firebase auth service
  Future signOut() async {
    await _auth.signOut();
  }

  /// Get current authentiacted user signed into platform
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}