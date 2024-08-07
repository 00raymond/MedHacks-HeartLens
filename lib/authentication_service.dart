
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthenticationService(FirebaseAuth instance);

  get authStateChanges => null;

  /// Use to sign in, will check for patient status. Only patients can sign into the mobile app.
  /// Checks if the user is a patient and only allows patients to sign in.
  /// throw [FirebaseAuthException] if invalid user type
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
          return null;
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

  Future<String> getCurrentUserName() async {
  if (_auth.currentUser == null) return 'Guest'; // Handle the case where there's no user
  try {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .get();
    if (userDoc.exists) {
      return (userDoc.data() as Map<String, dynamic>)['name'] ?? 'No Name';
    } else {
      return 'No Name';
    }
  } catch (e) {
    return 'Error';
  }
}

  void uploadPatientData(List<double> data, String uploadDate, int pulse) async {
    // add the list of strings to another array thats in: users/{uid}/data[] list of uploadDate's mapped to a list of strings.
    await FirebaseFirestore.instance.collection('users').doc(_auth.currentUser!.uid).update({
      'data': FieldValue.arrayUnion([{
        'date': uploadDate,
        'data': data,
        'pulse': pulse
      }])
    });
  }
}
