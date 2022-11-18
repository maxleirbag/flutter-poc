import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Services/auth_service.dart';
import 'CreateZipZopScreen.dart';
import 'HomeScreen.dart';
import 'NotificationsScreen.dart';
import 'ProfileScreen.dart';
import 'SearchScreen.dart';
import 'WelcomeScreen.dart';

class FeedScreen extends StatefulWidget {
  final String currentUserId;

  const FeedScreen({super.key, required this.currentUserId});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  int selectedTab = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('coisa')), // customizar
      body: [
        HomeScreen(
          currentUserId: widget.currentUserId,
        ),
        SearchScreen(
          currentUserId: widget.currentUserId,
        ),
        NotificationsScreen(
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
                  builder: (context) => CreateZipZopScreen(
                        currentUserId: widget.currentUserId,
                      )));
        },
        child: const Icon(
          Icons.note_add,
          color: Colors.green,
        ),
      ),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Menu'),
            ),
            ListTile(
              leading: const Icon(CupertinoIcons.moon),
              title: const Text('Dark mode'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Log out'),
              onTap: () {
                // Navigator.pop(context);
                AuthService.logout();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const WelcomeScreen()));
              },
            ),
          ],
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
// }
