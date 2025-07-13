import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign in with email and password
  Future<UserCredential?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'Đã xảy ra lỗi không xác định';
    }
  }

  
  Future<String> getUserRole() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return 'user';

      final authService = AuthService();
      final userModel = await authService.getUserData(user.uid);

      return userModel?.role ?? 'user';
    } catch (e) {
      return 'default!';
    }
  }
  // Register with email and password
  Future<UserCredential?> registerWithEmailAndPassword(String email,
      String password, String firstName, String phoneNumber, String role) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create user document in Firestore
      if (result.user != null) {
        UserModel userModel = UserModel(
          uid: result.user!.uid,
          email: email,
          firstName: firstName,
          phoneNumber: phoneNumber,
          createdAt: DateTime.now(),
          role: role,
        );

        await _firestore
            .collection('users')
            .doc(result.user!.uid)
            .set(userModel.toMap());

        // Update display name in Firebase Auth
        await result.user!.updateDisplayName(firstName);
      }

      return result;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'Đã xảy ra lỗi không xác định';
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      throw 'Đăng xuất thất bại';
    }
  }

  // Get user data from Firestore
  Future<UserModel?> getUserData(String uid) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw 'Không thể lấy thông tin người dùng';
    }
  }

  // Update user data in Firestore
  Future<void> updateUserData(UserModel userModel) async {
    try {
      await _firestore
          .collection('users')
          .doc(userModel.uid)
          .update(userModel.toMap());
    } catch (e) {
      throw 'Không thể cập nhật thông tin người dùng';
    }
  }

  // Handle Firebase Auth exceptions
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'Không tìm thấy tài khoản với email này';
      case 'wrong-password':
        return 'Mật khẩu không chính xác';
      case 'email-already-in-use':
        return 'Email này đã được sử dụng';
      case 'weak-password':
        return 'Mật khẩu quá yếu';
      case 'invalid-email':
        return 'Email không hợp lệ';
      case 'too-many-requests':
        return 'Quá nhiều yêu cầu. Vui lòng thử lại sau';
      case 'network-request-failed':
        return 'Lỗi kết nối mạng';
      default:
        return e.message ?? 'Đã xảy ra lỗi không xác định';
    }
  }

  Future<void> signInWithPhoneNumber(String input, String password) async {
    try {
      String normalizedPhone = input.trim();
      if (normalizedPhone.startsWith('0')) {
        normalizedPhone = '+84' + normalizedPhone.substring(1);
      }
      print('[DEBUG] Đăng nhập với số điện thoại: $normalizedPhone');
      final query = await _firestore
          .collection('users')
          .where('phoneNumber', isEqualTo: normalizedPhone)
          .limit(1)
          .get();
      if (query.docs.isNotEmpty) {
        final userData = query.docs.first.data();
        final email = userData['email'] as String?;
        print('[DEBUG] Email lấy được từ Firestore: $email');
        if (email == null || email.isEmpty) {
          throw Exception('Tài khoản không có email.');
        }
        await signInWithEmailAndPassword(email, password);
        return;
      }
      // Nếu không tìm thấy user theo phoneNumber, thử tìm user có email trùng với số điện thoại nhập vào
      print('[DEBUG] Không tìm thấy user với số: $normalizedPhone, thử tìm user có email trùng với số này');
      final emailQuery = await _firestore
          .collection('users')
          .where('email', isEqualTo: input)
          .limit(1)
          .get();
      if (emailQuery.docs.isNotEmpty) {
        final userData = emailQuery.docs.first.data();
        final email = userData['email'] as String?;
        print('[DEBUG] Đăng nhập bằng email trùng với số điện thoại: $email');
        await signInWithEmailAndPassword(email!, password);
        return;
      }
      throw Exception('Không tìm thấy tài khoản với số điện thoại này.');
    } catch (e) {
      rethrow;
    }
  }
}
