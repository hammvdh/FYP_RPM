// import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vitalrpm/models/user_model.dart';

class UserProvider extends ChangeNotifier {
  late UserModel loginUser;
  late final FirebaseAuth firebaseAuth;

  // initialize(userId) async {
  //   await loadUser(userId);
  // }

  Future<void> createUser(userId, email, firstname, lastname, userType) async {
    DocumentReference userMasterDocument;
    final user = UserModel();
    FirebaseFirestore.instance.runTransaction((transaction) async {
      try {
        userMasterDocument =
            FirebaseFirestore.instance.collection('usermaster').doc();
        user.documentId = userMasterDocument.id;
        user.userId = userId;
        user.email = email!;
        user.firstName = firstname!;
        user.lastName = lastname!;
        user.userType = userType!;
        transaction.set(userMasterDocument, {
          'docId': user.documentId,
          'userId': user.userId,
          'emailAddress': user.email,
          'firstName': user.firstName,
          'lastName': user.lastName,
          'country': 'Sri Lanka',
          'mobileNo': user.mobileNo,
          'address': user.address,
          'dateOfReg': Timestamp.now(),
          'lastUpdated': Timestamp.now(),
          'usertype': user.userType,
          'genderId': user.genderId
        });
      } catch (e) {
        print("RegisterAPI - Create User Error - $e");
      }
    });
    print(user);
  }

  Future<void> login(emailController, passwordController) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      print("LoginAPI - Login Error Occurred - $e");
    }
  }

  Future logout() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<void> loadUser(String userID) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('usermaster')
        .where('userId', isEqualTo: userID)
        .get();

    DocumentSnapshot userDoc = snapshot.docs.first;
    final user = UserModel();
    user.userId = userID;
    user.documentId = userDoc.get('docId');
    user.email = userDoc.get('emailAddress');
    user.firstName = userDoc.get('firstName');
    user.lastName = userDoc.get('lastName');
    user.address = userDoc.get('address');
    user.country = userDoc.get('country');
    user.mobileNo = userDoc.get('mobileNo');
    user.userType = userDoc.get('usertype');
    print('User Logged In - ${user.userType.trim()}');
    loginUser = user;
    notifyListeners();
  }

  void nextScreen() {}
}
