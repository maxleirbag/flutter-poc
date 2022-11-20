import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Constants/ColorPalette.dart';
import '../Services/auth_service.dart';
import 'FeedScreen.dart';
import 'NotificationsScreen.dart';
import 'PomboCorreioScreen.dart';
import 'ProfileScreen.dart';
import 'SearchScreen.dart';
import 'WelcomeScreen.dart';

class SkeletonScreen extends StatefulWidget {
  final String currentUserId;

  SkeletonScreen({super.key, required this.currentUserId});

  @override
  State<SkeletonScreen> createState() => _SkeletonScreenState();
}

class _SkeletonScreenState extends State<SkeletonScreen> {
  int selectedTab = 0;
  List<String> possibleTitles = ['Feed', 'Explorar', 'Notificações', 'Perfil'];
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: Builder(
            builder: (context) => IconButton(
                onPressed: () => Scaffold.of(context).openDrawer(),
                icon: Image.asset('assets/pigeon-white.png')),
          ),
          backgroundColor: primaryColor,
          title: Text(
            possibleTitles[selectedTab],
            style: const TextStyle(color: defaultDarkColor),
          )),
      body: [
        FeedScreen(
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
                  builder: (context) => CreatePomboCorreioScreen(
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
