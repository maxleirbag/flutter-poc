import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'CreateZopScreen.dart';
import 'HomeScreen.dart';
import 'NotificationScreen.dart';
import 'ProfileScreen.dart';
import 'SearchScreen.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  int selectedTab = 0;
  final List<Widget> _feedScreens = [
    const HomeScreen(),
    const SearchScreen(),
    const NotificationScreen(),
    const ProfileScreen()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _feedScreens.elementAt(selectedTab),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const CreateZopScreen()));
        },
        child: const Icon(
          Icons.note_add,
          color: Colors.green,
        ),
      ),
      bottomNavigationBar: CupertinoTabBar(
        onTap: (index) {
          setState(() {
            selectedTab = index;
          });
        },
        currentIndex: selectedTab,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home, color: Colors.green)),
          BottomNavigationBarItem(
              icon: Icon(Icons.search, color: Colors.green)),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications, color: Colors.green)),
          BottomNavigationBarItem(
              icon: Icon(Icons.person, color: Colors.green)),
        ],
      ),
    );
  }
}
