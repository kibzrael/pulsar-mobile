import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleProvider {
  GoogleProvider._();

  static final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: [
    'https://www.googleapis.com/auth/userinfo.email',
    'https://www.googleapis.com/auth/userinfo.profile',
    'https://www.googleapis.com/auth/user.birthday.read'
  ]);

  static Future<GoogleSignInAccount?> signin() async {
    GoogleSignInAccount? account;
    try {
      try {
        await _googleSignIn.disconnect();
        // ignore: empty_catches
      } catch (e) {}
      account = await _googleSignIn.signIn();
    } catch (e) {
      Fluttertoast.showToast(msg: "Signin Error $e");
    }
    return account;
  }
}
