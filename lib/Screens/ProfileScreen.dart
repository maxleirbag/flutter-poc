import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sabia_app/Constants/Constants.dart';
import 'package:sabia_app/Widgets/ZipZopContainer.dart';

import '../Models/User.dart';
import '../Models/ZipZop.dart';
import '../Services/DatabaseServices.dart';
import '../Services/auth_service.dart';
import 'WelcomeScreen.dart';
// import '../Services/DatabaseServices.dart';

class ProfileScreen extends StatefulWidget {
  final String currentUserId;
  final String visitedUserId;

  const ProfileScreen(
      {Key? key, required this.currentUserId, required this.visitedUserId})
      : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _followersCount = 0;
  int _followingCount = 0;
  bool _isFollowing = false;
  int _profileSegmentedValue = 0;
  List<ZipZop> _allZipZops = [];
  List<ZipZop> _mediaZipZops = [];

  final Map<int, Widget> _profileTabs = <int, Widget>{
    0: const Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        'ZipZops',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    ),
    1: const Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        'Media',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    ),
  };

  followOrUnFollow() {
    if (_isFollowing) {
      unFollowUser();
    } else {
      followUser();
    }
  }

  unFollowUser() {
    DatabaseServices.unFollowUser(widget.currentUserId, widget.visitedUserId);
    setState(() {
      _isFollowing = false;
      _followersCount--;
    });
  }

  followUser() {
    DatabaseServices.followUser(widget.currentUserId, widget.visitedUserId);
    setState(() {
      _isFollowing = true;
      _followersCount++;
    });
  }

  Widget buildProfileWidgets(User author) {
    switch (_profileSegmentedValue) {
      case 0:
        return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _allZipZops.length,
            itemBuilder: (context, index) {
              return ZipZopContainer(
                currentUserId: widget.currentUserId,
                author: author,
                zipZop: _allZipZops[index],
              );
            });
        break;
      case 1:
        return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _mediaZipZops.length,
            itemBuilder: (context, index) {
              return ZipZopContainer(
                currentUserId: widget.currentUserId,
                author: author,
                zipZop: _mediaZipZops[index],
              );
            });
      default:
        return const Center(
          child: Text('Profile view deu errado'),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.purple,
        body: FutureBuilder(
          future: usersRef.doc(widget.visitedUserId).get(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.red)));
            }
            // return Center();
            User user = User.fromDoc(snapshot.data);
            return ListView(
              physics: BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              children: [
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: KzipZopColor,
                    image: user.coverImage.isEmpty
                        ? null
                        : DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(user.coverImage),
                          ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox.shrink(),
                        widget.currentUserId == widget.visitedUserId
                            ? PopupMenuButton(
                                icon: Icon(
                                  Icons.more_horiz,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                itemBuilder: (_) {
                                  return <PopupMenuItem<String>>[
                                    new PopupMenuItem(
                                      child: Text('Logout'),
                                      value: 'logout',
                                    )
                                  ];
                                },
                                onSelected: (selectedItem) {
                                  if (selectedItem == 'logout') {
                                    AuthService.logout();
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                WelcomeScreen()));
                                  }
                                },
                              )
                            : SizedBox(),
                      ],
                    ),
                  ),
                ),
                Container(
                  transform: Matrix4.translationValues(0.0, -40.0, 0.0),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   crossAxisAlignment: CrossAxisAlignment.end,
                      //   children: [
                      //     CircleAvatar(
                      //       radius: 45,
                      //       backgroundImage: user.profilePicture.isEmpty
                      //           ? AssetImage('assets/zip zop.png')
                      //           : NetworkImage(user.profilePicture),
                      //     ),
                      //     widget.currentUserId == widget.visitedUserId
                      //         ? GestureDetector(
                      //             onTap: () async {
                      //               await Navigator.push(
                      //                 context,
                      //                 MaterialPageRoute(
                      //                   builder: (context) => EditProfileScreen(
                      //                     user: user,
                      //                   ),
                      //                 ),
                      //               );
                      //               setState(() {});
                      //             },
                      //             child: Container(
                      //               width: 100,
                      //               height: 35,
                      //               padding:
                      //                   EdgeInsets.symmetric(horizontal: 10),
                      //               decoration: BoxDecoration(
                      //                 borderRadius: BorderRadius.circular(20),
                      //                 color: Colors.white,
                      //                 border: Border.all(color: KzipZopColor),
                      //               ),
                      //               child: Center(
                      //                 child: Text(
                      //                   'Edit',
                      //                   style: TextStyle(
                      //                     fontSize: 17,
                      //                     color: KzipZopColor,
                      //                     fontWeight: FontWeight.bold,
                      //                   ),
                      //                 ),
                      //               ),
                      //             ),
                      //           )
                      //         : GestureDetector(
                      //             onTap: followOrUnFollow,
                      //             child: Container(
                      //               width: 100,
                      //               height: 35,
                      //               padding:
                      //                   EdgeInsets.symmetric(horizontal: 10),
                      //               decoration: BoxDecoration(
                      //                 borderRadius: BorderRadius.circular(20),
                      //                 color: _isFollowing
                      //                     ? Colors.white
                      //                     : KzipZopColor,
                      //                 border: Border.all(color: KzipZopColor),
                      //               ),
                      //               child: Center(
                      //                 child: Text(
                      //                   _isFollowing ? 'Following' : 'Follow',
                      //                   style: TextStyle(
                      //                     fontSize: 17,
                      //                     color: _isFollowing
                      //                         ? KzipZopColor
                      //                         : Colors.white,
                      //                     fontWeight: FontWeight.bold,
                      //                   ),
                      //                 ),
                      //               ),
                      //             ),
                      //           ),
                      //   ],
                      // ),
                      // SizedBox(height: 10),
                      // Text(
                      //   user.name,
                      //   style: TextStyle(
                      //     fontSize: 20,
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),
                      SizedBox(height: 10),
                      Text(
                        user.bio,
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(height: 15),
                      Row(
                        children: [
                          Text(
                            '$_followingCount Following',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 2,
                            ),
                          ),
                          SizedBox(width: 20),
                          Text(
                            '$_followersCount Followers',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: CupertinoSlidingSegmentedControl(
                          groupValue: _profileSegmentedValue,
                          thumbColor: KzipZopColor,
                          backgroundColor: Colors.blueGrey,
                          children: _profileTabs,
                          onValueChanged: (i) {
                            setState(() {
                              _profileSegmentedValue = i!;
                            });
                          },
                        ),
                      )
                    ],
                  ),
                ),
                buildProfileWidgets(user),
              ],
            );
          },
        ));
  }
}
