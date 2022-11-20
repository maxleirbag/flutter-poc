import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Constants/Constants.dart';
import '../Services/auth_service.dart';
import 'CreateZipZopScreen.dart';
import 'FeedScreen.dart';
import 'NotificationsScreen.dart';
import 'ProfileScreen.dart';
import 'SearchScreen.dart';
import 'WelcomeScreen.dart';

class FeedScreen extends StatefulWidget {
  final String currentUserId;
  final String novoTitulo;

  const FeedScreen(
      {super.key, required this.currentUserId, required this.novoTitulo});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  int selectedTab = 0;
  String titleScreen = 'coisa';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: primaryColor,
          title: Text(
            titleScreen,
            style: const TextStyle(color: defaultDarkColor),
          )), // customizar
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
        backgroundColor: defaultLightColor,
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
          color: secondaryColor,
        ),
      ),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: primaryColor,
              ),
              child: Text(
                'Pombo App',
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: defaultDarkColor),
              ),
            ),
            ListTile(
              leading: const Icon(
                CupertinoIcons.question_circle,
                color: defaultGrayColor,
              ),
              title: const Text('Perguntas Frequentes'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(
                CupertinoIcons.info,
                color: defaultGrayColor,
              ),
              title: const Text('Informações da conta'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.logout,
                color: defaultGrayColor,
              ),
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
          BottomNavigationBarItem(
              icon: Icon(Icons.home, color: secondaryColor)),
          BottomNavigationBarItem(
              icon: Icon(Icons.search, color: secondaryColor)),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications, color: secondaryColor)),
          BottomNavigationBarItem(
              icon: Icon(Icons.person, color: secondaryColor)),
        ],
      ),
    );
  }
}
// }
