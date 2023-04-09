import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_group_chat/services/database_service.dart';
import 'package:my_group_chat/helper/helper_function.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  //login
  Future logInWithEmailandPassword(
      String email, String password) async {
    try {
      User user = (await firebaseAuth.signInWithEmailAndPassword(email: email, password: password))
          .user!;
      if (user != null) {
        //call our database service to update user data
        return true;
      }
    } on FirebaseAuthException catch (e) {
      // print(e);
      return e.message;
    }
  }

  //register
  Future registerUserWithEmailandPassword(
      String fullName, String email, String password) async {
    try {
      User user = (await firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user!;
      if (user != null) {
        //call our database service to update user data
        DatabaseService(uid: user.uid).updateUserData(fullName, email);
        return true;
      }
    } on FirebaseAuthException catch (e) {
      // print(e);
      return e.message;
    }
  }

  //sign-out
  Future signOut() async {

      try {
        await HelperFunction.saveUserLoggedInStatus(false);
        await HelperFunction.saveUserNameSF("");
        await HelperFunction.saveUserEmailSF("");
        await firebaseAuth.signOut();
      }
      catch(e){
        return null;
      }

  }
}
