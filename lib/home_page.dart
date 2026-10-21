import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:imtihaan/my_work_page.dart';
import 'package:imtihaan/profile_page.dart';
import 'package:imtihaan/setting_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  TextEditingController nameController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int _selectedIndex = 0; // To track the selected tab
  String _nameSt = "";

  // Function to handle tab switching
  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update selected tab index
    });
  }

  @override
  void initState() {
    super.initState();
    // fetch data from firebase
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      // Get the current user
      User? currentUser = _auth.currentUser;

      if (currentUser != null) {
        String uid = currentUser.uid; // Get user's unique ID
        // Fetch user data from Firestore
        DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
        if (userDoc.exists) {
          // Update controllers with data
          setState(() {
            nameController.text = userDoc['name'] ?? ''; // Name field
            _nameSt = nameController.text;
          });
        } else {
          setState(() {
            nameController.text = "Unknown";
          });
        }
      } else {
        Fluttertoast.showToast(
            msg: "No user is currently logged in.",
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            gravity: ToastGravity.BOTTOM,
            fontSize: 16.0);
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          gravity: ToastGravity.BOTTOM,
          fontSize: 16.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Define screens here to access buildCategoryCard
    final List<Widget> _screens = [
      Column(
        children: [
          // Categories Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Categories",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(height: 20),

          // Categories List
          buildCategoryCard(context,
              color: Colors.amberAccent,
              icon: Icons.edit,
              text: "Hand Writing to notes",
              routeName: '/handwriting_to_notes'),
          SizedBox(height: 10),
          buildCategoryCard(context,
              color: Colors.amberAccent,
              icon: Icons.videocam_outlined,
              text: "Lecture Report",
              routeName: '/lecture_summary'),
          SizedBox(height: 40),
          buildCategoryCard(context,
              color: Colors.blue,
              icon: Icons.assessment,
              text: "Your Performance",
              routeName: '/your_performance'),
          SizedBox(height: 10),
          buildCategoryCard(context,
              color: Colors.red,
              icon: Icons.insert_drive_file_outlined,
              text: "Mock-Exam Simulator",
              routeName: '/mock_exams'),
        ],
      ),

      const ProfilePage(),
      const MyWorkPage(),
      const SettingPage(),
    ];
    return Scaffold(
      appBar: getAppBarWithTitle(),
      body: _screens[_selectedIndex],
      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onTabTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Profile",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work_outline),
            label: "My Work",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
      ),
    );
  }

  // Helper method to create category cards
  Widget buildCategoryCard(BuildContext context,
      {required Color color,
      required IconData icon,
      required String text,
      required String routeName}) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, routeName);
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Card with the icon
          Card(
            color: color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              height: 60, // Card height
              width: 60, // Card width
              alignment: Alignment.center,
              child: Icon(icon, color: Colors.white, size: 30),
            ),
          ),
          SizedBox(width: 16), // Space between card and text
          // Text next to the card
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
  AppBar getAppBarWithTitle() {
    AppBar appBar;
    if(_selectedIndex == 0) {
      appBar = AppBar(
        backgroundColor: Colors.blue, // AppBar background color
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Hello, ",
                    style: TextStyle(color: Colors.white, fontSize: 20)
                ),
                Text(
                  _nameSt,
                    style: TextStyle(color: Colors.white, fontSize: 20)
                )
              ],
            ),
            SizedBox(height: 7),
            Text(
              "What do you want to learn today?",
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/notification_settings'),
            icon: Icon(Icons.notifications_none, color: Colors.white),
          ),
        ],
      );
    } else {
      appBar = AppBar(
        backgroundColor: Colors.white, // AppBar background color
        elevation: 0,
        title: Text(getAppBarTitle(),
        style: TextStyle(color: Colors.black, fontSize: 20),
        ),
      );
    }

    return appBar;
  }

  String getAppBarTitle() {
    String title = "";
    if(_selectedIndex == 1) {
      title = "Profile Settings";
    } else if(_selectedIndex == 2) {
      title = "My Work";
    } else if(_selectedIndex == 3) {
      title = "Settings";
    }

    return title;
  }
}
