import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class FacebookProvider {
  FacebookProvider._();

  static final FacebookAuth _facebookauth = FacebookAuth.instance;

  static Future<AccessToken?> signIn() async {
    try {
      LoginResult result = await _facebookauth.login(
          permissions: const ['email', 'public_profile', 'user_birthday'],
          loginBehavior: LoginBehavior.dialogOnly);
      return result.accessToken;
      // ignore: empty_catches
    } catch (e) {}
    return null;
  }

  static Future<Map<String, dynamic>?> fetchUser() async {
    try {
      return await _facebookauth.getUserData(
          fields: "name,email,birthday,picture.width(500)");
      // ignore: empty_catches
    } catch (e) {}
    return null;
  }
}
