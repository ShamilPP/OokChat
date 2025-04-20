// user_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ook_chat/constants/firebase_constants.dart';

import '../../../model/user.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch user data from Firestore using the user ID
  Future<User?> getUserData(String userId) async {
    try {
      // Get the user document from Firestore
      DocumentSnapshot userDoc = await _firestore.collection(FirebaseConstants.userCollection).doc(userId).get();

      // If the document exists, return the mapped user data
      if (userDoc.exists) {
        return User.fromFirestore(userDoc.data() as Map<String, dynamic>, userDoc.id);
      } else {
        return null; // Return null if user doesn't exist
      }
    } catch (e) {
      print("Error fetching user data: $e");
      return null; // Return null if an error occurs
    }
  }

  // Create a new user in Firestore
  Future<User?> createUser(User user) async {
    try {
      var sameUidUsers = await _firestore.collection(FirebaseConstants.userCollection).where('uid', isEqualTo: user.uid).get();

      if (sameUidUsers.docs.isEmpty) {
        // Add a new user document to the 'users' collection
        DocumentReference userRef = await _firestore.collection(FirebaseConstants.userCollection).add(user.toJson());
        user.id = userRef.id;
      } else {
        user.id = sameUidUsers.docs.first.id;
      }
      return user;
    } catch (e) {
      print("Error creating user: $e");
      return null; // Return null if an error occurs during creation
    }
  }
}
