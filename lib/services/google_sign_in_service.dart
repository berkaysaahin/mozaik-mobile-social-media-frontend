import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GoogleSignInService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  String? baseUrl = dotenv.env['HOST_URL'];

  Future<String?> signInWithGoogle() async {
    try {
      print('Step 1: Starting sign-in');
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      print('Step 2: Got googleUser');

      if (googleUser == null) {
        print('Step 3: User cancelled sign-in');
        return null;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      print('Step 4: Got authentication');

      final idToken = googleAuth.idToken;
      if (idToken == null) {
        print('Step 5: No ID token');
        throw Exception('No ID Token received from Google');
      }

      print('Step 6: Sending token to backend');
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/google'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'idToken': idToken}),
      );

      print('Step 7: Got response with status ${response.statusCode}');
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Step 8: Backend responded with: $data');
        return data['token'];
      } else {
        print('Step 9: Backend error ${response.body}');
        await _googleSignIn.disconnect();
        throw Exception('This email is not registered as a user');
      }
    } catch (e) {
      print('❌ Exception caught: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (e) {
      throw Exception('Error during Google Sign-Out: $e');
    }
  }
}
