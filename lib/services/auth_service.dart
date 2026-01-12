import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthService extends GetxController {
  static AuthService get instance => Get.find();
  
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // Observable user
  Rx<User?> firebaseUser = Rx<User?>(null);
  
  @override
  void onReady() {
    super.onReady();
    firebaseUser.bindStream(_auth.authStateChanges());
  }
  
  // Sign up with email and password
  Future<UserCredential?> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        'Error',
        e.message ?? 'An error occurred during sign up',
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    }
  }
  
  // Sign in with email and password
  Future<UserCredential?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'No user found with this email';
          break;
        case 'wrong-password':
          message = 'Incorrect password';
          break;
        case 'invalid-email':
          message = 'Invalid email address';
          break;
        case 'user-disabled':
          message = 'This account has been disabled';
          break;
        default:
          message = e.message ?? 'An error occurred during sign in';
      }
      Get.snackbar(
        'Error',
        message,
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    }
  }
  
  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      Get.snackbar(
        'Success',
        'Logged out successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred during sign out',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
  
  // Get current user
  User? get currentUser => _auth.currentUser;
  
  // Check if user is logged in
  bool get isLoggedIn => _auth.currentUser != null;
}
