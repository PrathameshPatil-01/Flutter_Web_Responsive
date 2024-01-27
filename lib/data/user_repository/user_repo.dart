import 'package:firebase_auth/firebase_auth.dart';
import 'package:universal_html/html.dart' as html;
import 'package:web_auth/data/user_repository/models/my_user.dart';

abstract class UserRepository {
  Stream<User?> get user;

  Future<void> login(String email, String password);

  Future<void> logOut();

  Future<MyUser> signUp(MyUser myUser, String password);

  Future<void> resetPassword(String email);

  Future<void> setUserData(MyUser user);

  Future<MyUser> getMyUser(String myUserId);

  Future<String> uploadPicture(html.File file, String userId);

  Future<MyUser> getOnlyUser(String myUserId);
}
