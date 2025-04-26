import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

class AuthUtils {
  static final Logger logger = Logger();
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Check if user exists in Firestore by phone number
  static Future<bool> doesUserExist(String phoneNumber) async {
    try {
      final querySnapshot =
          await _firestore
              .collection('users')
              .where('mobile_number', isEqualTo: phoneNumber)
              .limit(1)
              .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      logger.e("Error checking if user exists with phone number: $e");
      return false;
    }
  }

  // Get user document by phone number
  static Future<DocumentSnapshot?> getUserByPhone(String phoneNumber) async {
    try {
      final querySnapshot =
          await _firestore
              .collection('users')
              .where('phoneNumber', isEqualTo: phoneNumber)
              .limit(1)
              .get();

      return querySnapshot.docs.isNotEmpty ? querySnapshot.docs.first : null;
    } catch (e) {
      logger.e("Error fetching user by phone number: $e");
      return null;
    }
  }

  // Static method to save user data to Firestore
  static Future<void> saveUserData({
    required String firstName,
    required String lastName,
    required String email,
    required String mobileNumber,
    required DateTime? birthday,
    required String? gender,
  }) async {
    // Reference to the Firestore collection
    CollectionReference users = _firestore.collection('users');

    try {
      // Save data using mobile number as document ID
      await users.doc(mobileNumber).set({
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'mobile_number': mobileNumber,
        'birthday': birthday ?? null, // Set null if no birthday provided
        'gender':
            gender ?? 'Other', // Default gender to 'Other' if not provided
      });
      logger.i("User Saved Successfully: $mobileNumber");
    } catch (e) {
      logger.e("User Save Failed: $e");
      rethrow; // Optionally rethrow the error if you want to handle it further up
    }
  }
}
