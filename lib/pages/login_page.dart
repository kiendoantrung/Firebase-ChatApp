import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../constants/color_constants.dart';
import '../providers/auth_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../widgets/widgets.dart';
import 'pages.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    switch (authProvider.status) {
      case Status.authenticateError:
        Fluttertoast.showToast(msg: "Sign in fail");
        break;
      case Status.authenticateCanceled:
        Fluttertoast.showToast(msg: "Sign in canceled");
        break;
      case Status.authenticated:
        Fluttertoast.showToast(msg: "Sign in success");
        break;
      default:
        break;
    }
    return Scaffold(
        body: Stack(
          children: <Widget>[
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Firebase Chat",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: ColorConstants.primaryColor),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Login now to chat with your friends",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: ColorConstants.primaryColor),
                  ),
                  SizedBox(
                    height: 80,
                  ),
                  Image.asset(
                    "images/login.png",
                    width: 300,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 80.0),
                  TextButton(
                  onPressed: () async {
                    authProvider.handleSignIn().then((isSuccess) {
                    if (isSuccess) {
                    Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                    builder: (context) => HomePage(),
                    ),
                    );
                    }
                    }).catchError((error, stackTrace) {
                    Fluttertoast.showToast(msg: error.toString());
                    authProvider.handleException();
                    });
                  },
                    child: Text(
                      'Sign in with Google',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed)) return Color(0xffdd4b39).withOpacity(0.8);
                          return Color(0xffdd4b39);
                        },
                      ),
                      splashFactory: NoSplash.splashFactory,
                      padding: MaterialStateProperty.all<EdgeInsets>(
                        EdgeInsets.fromLTRB(30, 15, 30, 15),
                      ),
                    ),
                  ),
                ],
              )
            ),
            // Loading
            Positioned(
              child: authProvider.status == Status.authenticating ? LoadingView() : SizedBox.shrink(),
            ),
          ],
        ));
  }
}
