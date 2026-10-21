
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:imtihaan/Services/auth_services.dart';
import 'package:imtihaan/home_page.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  bool isPasswordVisible = false;
  bool isLoading = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final AuthServices _auth = AuthServices();


  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void signin() async {
    String res = await AuthServices().logInUser(
        email: emailController.text,
        password: passwordController.text
    );
    // navigate user or show error based on signup
    if(res == "Success"){
      setState(() {
        isLoading = true;
      });
      // navigate user
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
            (route) => false,
      );

    } else {
      setState(() {
        isLoading = false;
      });
      // show error
      Fluttertoast.showToast(
          msg: res,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
  }

  void _handleGoogleSignIn() async {
    String res = await _auth.signInWithGoogle();
    if (res == "Success") {
      print("Google Sign-In Successful!");
      // Navigate to Home Screen
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
            (route) => false,
      );
    } else {
      print("Error: $res");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
            "Hello.",
          style: TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Padding(
              padding: const EdgeInsets.only(left: 16, top: 40),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Email",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 2),
            child: TextField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: "Enter email",
                prefixIcon: Icon(Icons.email_outlined),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8)
                )
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Password",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
            child: TextField(
              controller: passwordController,
              obscureText: !isPasswordVisible,
              decoration: InputDecoration(
                  hintText: "Enter password",
                  prefixIcon: Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isPasswordVisible = !isPasswordVisible;
                        });
                      },
                      icon: Icon(
                          isPasswordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined
                      )
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)
                  )
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
                onPressed: (){
                  // add forgot password logic here
                  Fluttertoast.showToast(
                      msg: "Forgot password is clicked",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: 16.0
                  );
                },
                child: Text(
                  "Forgot password?",
                  style: TextStyle(color: Colors.blue),
                ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {
                    // add sign in logic here
                    signin();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text(
                    "Sign In",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  )
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Center(
            child: Text(
              "OR CONTINUE WITH",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 3),
          // social media buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Google
              IconButton(
                  onPressed: () {
                    // Add logic here
                    _handleGoogleSignIn();
                  },
                  icon: Image.asset(
                      'assets/google_icon.png',
                    height: 50,
                  )
              ),
              SizedBox(width: 10),
              IconButton(
                  onPressed: () {
                    // Add logic here
                  },
                  icon: Image.asset(
                    'assets/fb_icon.png',
                    height: 35,
                  )
              ),
              SizedBox(width: 10),
              IconButton(
                  onPressed: () {
                    // Add logic here
                  },
                  icon: Image.asset(
                    'assets/apple_icon.png',
                    height: 40,
                  )
              )
            ],
          ),
          const Spacer(),
          // Don't have an account
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Don't have an account?"),
              TextButton(
                  onPressed: () {
                    // Add logic here
                    Navigator.pushNamed(context, '/signup');
                  },
                  child: const Text(
                    "Sign up",
                    style: TextStyle(color: Colors.blue),
                  )
              )
            ],
          ),
          const SizedBox(height: 20)
        ],
      ),
    );
  }
}