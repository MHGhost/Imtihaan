
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:imtihaan/Services/auth_services.dart';
import 'package:imtihaan/sign_in.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});


  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  bool isChecked = false; // For the checkbox state
  bool isLoading = false; // For the checkbox state
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  final AuthServices _auth = AuthServices();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    phoneController.dispose();
  }

  void signupUser() async {
    if (!isChecked) {
      Fluttertoast.showToast(
        msg: 'Please review and accept the Privacy Policy.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }

    String res = await AuthServices().signUpUser(
        email: emailController.text,
        password: passwordController.text,
        name: nameController.text,
        phone: phoneController.text
    );
    // navigate user or show error based on signup
    if(res == "Success"){
      setState(() {
        isLoading = true;
      });
      // navigate user
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => SignIn()),
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

  void _handleGoogleSignUp() async {
    String res = await _auth.signInWithGoogle(); // Same function for login & sign-up
    if (res == "Success") {
      print("Google Sign-Up Successful!");
      // Navigate to Home Screen
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => SignIn()),
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
        elevation: 0,
        title: Text(
          "Welcome.",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Padding(
              padding: const EdgeInsets.only(top: 8, left: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Create an account",
                style: TextStyle(color: Colors.grey, fontSize: 20),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Email",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
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
            padding: const EdgeInsets.only(left: 16, top: 5),
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
              decoration: InputDecoration(
                  hintText: "Enter password",
                  prefixIcon: Icon(Icons.lock_outline),
                  suffixIcon: Icon(Icons.visibility_off_outlined),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)
                  )
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 5),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Name",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
            child: TextField(
              controller: nameController,
              decoration: InputDecoration(
                  hintText: "Enter Name",
                  prefixIcon: Icon(Icons.person),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)
                  )
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 5),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Phone",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
            child: TextField(
              controller: phoneController,
              decoration: InputDecoration(
                  hintText: "Enter Phone",
                  prefixIcon: Icon(Icons.phone_android),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)
                  )
              ),
            ),
          ),
          const SizedBox(height: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Checkbox(
                  value: isChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      isChecked = value!;
                    });
                  },
              ),
              const Text('I agree to the'),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/privacy'),
                child: const Text('Privacy Policy'),
              ),
            ],
          ),
          Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 4),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {
                    signupUser();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),

                    ),
                    backgroundColor: Colors.blue
                  ),
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  )
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Center(
            child: Text(
              "OR SIGNUP WITH",
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
                    _handleGoogleSignUp();
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Already have an account?"),
              TextButton(
                  onPressed: () {
                    // route to sign in page
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => SignIn()),
                      (route) => false,
                    );
                  },
                  child: const Text(
                    "Sign in",
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
