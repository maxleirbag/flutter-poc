import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'CreateZipZopScreen.dart';
import 'HomeScreen.dart';
import 'NotificationScreen.dart';
import 'ProfileScreen.dart';
import 'SearchScreen.dart';

class FeedScreen extends StatefulWidget {
  final String currentUserId;
  const FeedScreen({Key? key, required this.currentUserId}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  int selectedTab = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: [
        HomeScreen(
          currentUserId: widget.currentUserId,
        ),
        SearchScreen(
          currentUserId: widget.currentUserId,
        ),
        NotificationScreen(
          currentUserId: widget.currentUserId,
        ),
        ProfileScreen(
            currentUserId: widget.currentUserId,
            visitedUserId: widget.currentUserId)
      ].elementAt(selectedTab),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const CreateZipZopScreen()));
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
