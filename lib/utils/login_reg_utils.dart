// lib/utils/login_reg_utils.dart
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
              .where('phoneNumber', isEqualTo: phoneNumber)
              .limit(1)
              .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      logger.e("Error with fetch mobile number: $e");
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
      logger.e("Error with register mobile number: $e");
      return null;
    }
  }
}
