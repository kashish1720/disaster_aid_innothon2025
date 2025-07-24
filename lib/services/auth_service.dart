import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Check if user is logged in
  bool get isLoggedIn => currentUser != null;

  // Login with email and password
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      // Sign in with email and password
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        return {
          'success': false,
          'errorMessage': 'Login failed, please try again',
        };
      }

      // Fetch user data from Firestore to get user type
      final DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (!userDoc.exists) {
        // User record doesn't exist in Firestore
        return {
          'success': true,
          'userType': 'citizen', // Default to citizen if no record exists
        };
      }

      final userData = userDoc.data() as Map<String, dynamic>;
      
      return {
        'success': true,
        'userType': userData['userType'] ?? 'citizen',
      };
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found with this email.';
          break;
        case 'wrong-password':
          errorMessage = 'Incorrect password.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is not valid.';
          break;
        case 'user-disabled':
          errorMessage = 'This user account has been disabled.';
          break;
        case 'too-many-requests':
          errorMessage = 'Too many login attempts. Please try again later.';
          break;
        default:
          errorMessage = 'Login failed: ${e.message}';
      }
      
      return {
        'success': false,
        'errorMessage': errorMessage,
      };
    } catch (e) {
      return {
        'success': false,
        'errorMessage': 'Login error: $e',
      };
    }
  }

  // Register with email and password
  Future<Map<String, dynamic>> register(String email, String password, String userType, {Map<String, dynamic>? userData}) async {
    try {
      // Create user with email and password
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        return {
          'success': false,
          'errorMessage': 'Registration failed, please try again',
        };
      }

      // Prepare user data for Firestore
      final Map<String, dynamic> userDataMap = userData ?? {};
      userDataMap['email'] = email;
      userDataMap['userType'] = userType;
      userDataMap['createdAt'] = FieldValue.serverTimestamp();

      // Save user data to Firestore
      await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(userDataMap);

      return {
        'success': true,
        'userType': userType,
      };
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'This email is already registered.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is not valid.';
          break;
        case 'weak-password':
          errorMessage = 'The password is too weak.';
          break;
        case 'operation-not-allowed':
          errorMessage = 'Email/password accounts are not enabled.';
          break;
        default:
          errorMessage = 'Registration failed: ${e.message}';
      }
      
      return {
        'success': false,
        'errorMessage': errorMessage,
      };
    } catch (e) {
      return {
        'success': false,
        'errorMessage': 'Registration error: $e',
      };
    }
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
  }

  // Password reset
  Future<Map<String, dynamic>> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return {
        'success': true,
      };
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      
      switch (e.code) {
        case 'invalid-email':
          errorMessage = 'The email address is not valid.';
          break;
        case 'user-not-found':
          errorMessage = 'No user found with this email.';
          break;
        default:
          errorMessage = 'Password reset failed: ${e.message}';
      }
      
      return {
        'success': false,
        'errorMessage': errorMessage,
      };
    } catch (e) {
      return {
        'success': false,
        'errorMessage': 'Password reset error: $e',
      };
    }
  }

  // Get user type
  Future<String> getUserType() async {
    try {
      if (currentUser == null) {
        return 'guest';
      }

      final DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .get();

      if (!userDoc.exists) {
        return 'citizen'; // Default
      }

      final userData = userDoc.data() as Map<String, dynamic>;
      return userData['userType'] ?? 'citizen';
    } catch (e) {
      print('Error getting user type: $e');
      return 'citizen'; // Default in case of error
    }
  }
}