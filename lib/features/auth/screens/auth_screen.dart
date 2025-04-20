import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ook_chat/constants/app_icons.dart';
import 'package:ook_chat/features/auth/bloc/google_auth/google_auth_event.dart';
import 'package:ook_chat/features/splash/screen/splash_screen.dart';

import '../bloc/google_auth/google_auth_bloc.dart';
import '../bloc/google_auth/google_auth_state.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocConsumer<GoogleAuthBloc, GoogleAuthState>(
          listener: (context, state) {
            if (state is GoogleAuthLoading) {
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) =>
                      Center(
                          child: Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 15, spreadRadius: 5)]),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
                                ),
                                SizedBox(height: 15),
                                Text("Logging in...", style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black87))
                              ],
                            ),
                          )));
            } else if (state is GoogleAuthError) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Login failed: ${state.errorMessage}"),
                  backgroundColor: Colors.redAccent,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            } else if (state is GoogleAuthSignedIn) {
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => SplashScreen()), (predicate) => false);
            }
          },
          builder: (context, state) {
            return Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white,
                    Color(0xFFF5F9FF),
                  ],
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 100),

                    // App Logo
                    Center(
                      child: Hero(
                        tag: 'app-icon',
                        child: Image.asset(
                          AppIcons.appIcon, // Make sure this asset exists
                          height: 150,
                          width: 150,
                        ),
                      ),
                    ),

                    SizedBox(height: 30),

                    // Title and Subtitle
                    Text(
                      "Welcome to Kleanit",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Glad to meet you again!",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.black54,
                      ),
                    ),

                    Spacer(),

                    // Google Login Button with enhanced styling
                    _buildLoginButton(
                      text: "Continue with Google",
                      icon: AppIcons.googleIcon,
                      onPressed: () async {
                        context.read<GoogleAuthBloc>().add(GoogleAuthSignInRequested());
                      },
                      backgroundColor: Colors.white,
                      textColor: Colors.black87,
                    ),

                    SizedBox(height: 20),

                    // Terms of Service text
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "By continuing, you agree to our Terms of Service and Privacy Policy",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black45,
                          height: 1.5,
                        ),
                      ),
                    ),

                    SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoginButton({
    required String text,
    required String icon,
    required VoidCallback onPressed,
    required Color backgroundColor,
    required Color textColor,
  }) {
    return Container(
      width: double.infinity,
      height: 60,
      margin: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 0,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          padding: EdgeInsets.symmetric(horizontal: 20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              icon,
              height: 24,
              width: 24,
            ),
            SizedBox(width: 12),
            Text(
              text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
