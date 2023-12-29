import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hepy/app/Utils/common_utils.dart';
import 'package:hepy/app/Utils/preference_utils.dart';
import 'package:hepy/app/enum/sign_in_status.dart';
import 'package:hepy/app/modules/signin/view/signin_view.dart';
import 'package:hepy/app/widgets/widget_helper.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../Utils/app_size.dart';
import '../../welcome/controller/welcome_controller.dart';
import '../../welcome/view/welcome_view.dart';

class SignInController extends GetxController {
  late WelcomeController welcomeController;
  Rx<TextEditingController> emailAddressTextEditor =
      TextEditingController().obs;

  @override
  void onInit() {
    super.onInit();
    welcomeController = Get.put(WelcomeController());
  }

  void initiateGmailLogin(context) async {
    CommonUtils().startLoading(context);
    final GoogleSignIn googleSignIn = GoogleSignIn();

    GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
    if (googleSignInAccount == null) {
      CommonUtils().stopLoading(context);
      return;
    }

    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    AuthCredential authCredential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken);

    var user =
        (await CommonUtils().auth.signInWithCredential(authCredential)).user;
    var googleAuthentication = await googleSignIn.currentUser?.authentication;

    String? idToken = googleAuthentication?.idToken.toString();
    if (idToken != null) {
      PreferenceUtils.setStringValue(PreferenceUtils.ID_TOKEN, idToken);
    }

    // CommonUtils().stopLoading(context);

    if (user?.providerData != null) {
      if (CommonUtils.isLinkedAllAccount()) {
        welcomeController.managesSignupFlow(context: context);
      } else {
        if (CommonUtils.isLinkedPhone()) {
          welcomeController.managesSignupFlow(context: context);
        } else {
          user?.reauthenticateWithCredential(authCredential).then((result) {
            user.delete();
          }).catchError((error) {});

          WidgetHelper().showBottomSheetDialog(
              controller: signupViews(context:context, welcomeController:welcomeController),
              bottomSheetHeight:
                  MediaQuery.of(context).size.height * AppSize.bottomSize);
        }
      }
    }
  }

  Future<Resource?> signInWithFacebook(context) async {
    CommonUtils().startLoading(context);

    final FirebaseAuth auth = FirebaseAuth.instance;

    try {
      final LoginResult mLoginResult = await FacebookAuth.instance.login();
      switch (mLoginResult.status) {
        case LoginStatus.success:
          final AuthCredential facebookCredential =
              FacebookAuthProvider.credential(mLoginResult.accessToken!.token);
          final userCredential =
              await auth.signInWithCredential(facebookCredential);

          if (userCredential.additionalUserInfo != null) {
            String? idToken = mLoginResult.accessToken?.token.toString();
            if (idToken != null) {
              PreferenceUtils.setStringValue(PreferenceUtils.ID_TOKEN, idToken);
            }
            if (CommonUtils.isLinkedAllAccount()) {
              welcomeController.managesSignupFlow(context: context);
            } else {
              if (CommonUtils.isLinkedPhone()) {
                welcomeController.managesSignupFlow(context: context);
              } else {
                await userCredential.user
                    ?.reauthenticateWithCredential(facebookCredential);
                await userCredential.user?.delete();
                WidgetHelper().showBottomSheetDialog(
                    controller: signupViews(context:context, welcomeController:welcomeController),
                    bottomSheetHeight: MediaQuery.of(context).size.height *
                        AppSize.bottomSize);
              }
            }
          }

          return Resource(status: SignInStatus.Success);
        case LoginStatus.cancelled:
          CommonUtils().stopLoading(context);
          return Resource(status: SignInStatus.Cancelled);
        case LoginStatus.failed:
          CommonUtils().stopLoading(context);
          return Resource(status: SignInStatus.Error);
        default:
          return null;
      }
    } on FirebaseAuthException catch (e) {
      CommonUtils().stopLoading(context);
      rethrow;
    }
  }

  /*initiateSignInWithApple(context) async {
    CommonUtils().startLoading(context);
    final rawNonce = generateNonce();
    final nonce = sha2S6ofString(rawNonce);

    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        webAuthenticationOptions: WebAuthenticationOptions(
          // TODO: Set the `clientId` and `redirectUri` arguments to the values you entered in the Apple Developer portal during the setup
          clientId: 'de.lunaone.flutter.signinwithappleexample.service',
          redirectUri:
          // For web your redirect URI needs to be the host of the "current page",
          // while for Android you will be using the API server that redirects back into your app via a deep link
          Uri.parse(
            'https://flutter-sign-in-with-apple-example.glitch.me/callbacks/sign_in_with_apple',
          ),
        ),
        nonce: nonce,
      );

      final oAuthProvider = OAuthProvider("apple.com").credential(
        idToken: credential.identityToken,
        rawNonce: rawNonce,
      );

      // Sign in the user with Firebase. If the nonce we generated earlier does
      // not match the nonce in `appleCredential.identityToken`, sign in will fail.

      final result =
      await CommonUtils().auth.signInWithCredential(oAuthProvider);
      final User? firebaseUser = result.user;
      String? idToken = credential.identityToken;
      if (idToken != null) {
        PreferenceUtils.setStringValue(PreferenceUtils.ID_TOKEN, idToken);
      }
      final fullName = result.user?.displayName;
      await firebaseUser?.updateDisplayName(fullName);
      await result.user?.reauthenticateWithCredential(oAuthProvider);
      await result.user?.delete();

      CommonUtils().startLoading(context);

      WidgetHelper().showBottomSheetDialog(
          controller: signupViews(context, welcomeController),
          bottomSheetHeight:
          MediaQuery.of(context).size.height * AppSize.bottomSize);
    } catch (exception) {
      CommonUtils().stopLoading(context);
      print(exception);
    }
  }*/

  String sha2S6ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  void signInWithApple({required BuildContext context}) async {
    CommonUtils().startLoading(context);

    if (CommonUtils.isLinkedAllAccount()) {
      welcomeController.managesSignupFlow(context: context);
    }else{
        OAuthCredential oAuthCredential = await appleCredential();
        UserCredential? result =
        await CommonUtils().auth.signInWithCredential(oAuthCredential);
        User? user = result.user;
        if (user?.phoneNumber == null) {
          user?.delete();
          CommonUtils().stopLoading(context);
          SignInView signInView = SignInView();
          WidgetHelper().showBottomSheetDialog(
              controller: signInView.userConsent(context),
              enableDrag: false,
              bottomSheetHeight: MediaQuery.of(context).size.height * 0.95);
        }else{
          welcomeController.managesSignupFlow(context: context);
        }
    }
  }

  Future<OAuthCredential> appleCredential() async{
    final rawNonce = generateNonce();
    final nonce = sha2S6ofString(rawNonce);

    AuthorizationCredentialAppleID credential =
    await SignInWithApple.getAppleIDCredential(scopes: [
      AppleIDAuthorizationScopes.email,
      AppleIDAuthorizationScopes.fullName
    ], nonce: nonce);

    OAuthCredential oAuthCredential = OAuthProvider("apple.com")
        .credential(idToken: credential.identityToken, rawNonce: rawNonce);

    return oAuthCredential;
  }

  void reAuthenticateAppleUser(BuildContext context) async{
    OAuthCredential oAuthCredential = await appleCredential();
    UserCredential? results =
        await CommonUtils().auth.currentUser?.reauthenticateWithCredential(oAuthCredential);
    User? newUser = results?.user;
    if (newUser?.phoneNumber == null) {
      newUser?.delete();
      AuthCredential credential = oAuthCredential;

      PreferenceUtils.setStringValue(PreferenceUtils.ID_TOKEN, "123");

      WidgetHelper().showBottomSheetDialog(
          controller: signupViews(context:context, welcomeController:welcomeController,appleLinkCredential: credential),
          bottomSheetHeight:
          MediaQuery.of(context).size.height * AppSize.bottomSize);
    }
  }

  void navigateToEmailScreen(Widget widget, context) {
    WidgetHelper().showBottomSheetDialog(
        controller: widget,
        enableDrag: false,
        bottomSheetHeight: MediaQuery.of(context).size.height * 0.95);
  }

  void navigateToEmailCheckScreen(Widget widget, context) {
    String email = emailAddressTextEditor.value.text.trim().toLowerCase();
    if (email.isEmpty) {
      WidgetHelper().showMessage(msg: "Enter email address");
    } else if (!CommonUtils.isValidEmailAddress(email)) {
      WidgetHelper().showMessage(msg: "Enter valid email address");
    } else {
      CommonUtils.checkEmailExits(email).then((bool result) {
        if (result) {
          _resetPassword(email, context);
        }

        Get.back();
        WidgetHelper().showBottomSheetDialog(
            controller: widget,
            enableDrag: false,
            bottomSheetHeight: MediaQuery.of(context).size.height * 0.95);
        emailAddressTextEditor.value.text = "";
      });
    }
  }

  /// Send user an email for password reset
  Future<void> _resetPassword(String email, context) async {
    // CommonUtils().startLoading(context);
    try {
      await CommonUtils()
          .auth
          .sendPasswordResetEmail(email: email)
          .then((value) {});
      // CommonUtils().stopLoading(context);
    } on FirebaseAuthException catch (e) {
      // CommonUtils().stopLoading(context);
      print(e.code);
      print(e.message);
      // WidgetHelper().showMessage(msg: e.message);
    }
  }
}

class Resource {
  final SignInStatus status;

  Resource({required this.status});
}
