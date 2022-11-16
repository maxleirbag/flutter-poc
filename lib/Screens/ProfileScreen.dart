import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sabia_app/Constants/Constants.dart';
import 'package:sabia_app/Widgets/ZipZopContainer.dart';

import '../Models/UserModel.dart';
import '../Models/ZipZop.dart';
import '../Services/DatabaseServices.dart';
import '../Services/auth_service.dart';
import 'EditProfileScreen.dart';
import 'WelcomeScreen.dart';

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
  List<dynamic> _allZipZops = [];
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

  getAllZipZops() async {
    List userZipZops =
        await DatabaseServices.getUserZipZops(widget.visitedUserId);
    if (mounted) {
      setState(() {
        _allZipZops = userZipZops;
      });
    }
  }

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

  getFollowersCount() async {
    int followersCount =
        await DatabaseServices.followersNum(widget.visitedUserId);
    if (mounted) {
      setState(() {
        _followersCount = followersCount;
      });
    }
  }

  // getFollowingCount() async {
  //   int followingCount =
  //       await DatabaseServices.followingNum(widget.visitedUserId);
  //   if (mounted) {
  //     setState(() {
  //       _followingCount = followingCount;
  //     });
  //   }
  // }

  Widget buildProfileWidgets(UserModel author) {
    getAllZipZops();
    switch (_profileSegmentedValue) {
      case 0:
        return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _allZipZops.length,
            itemBuilder: (context, index) {
              return ZipZopContainer(
                currentUserId: widget.currentUserId,
                author: author,
                zipZop: _allZipZops[index],
                // currentUserId: 'qzLBDsPaTGcrLK7Cr3cQAv01OAj2',
                // author: author,
                // zipZop: _allZipZops[0],
              );
            });
      // case 1:
      //   return ListView.builder(
      //       shrinkWrap: true,
      //       physics: const NeverScrollableScrollPhysics(),
      //       itemCount: _mediaZipZops.length,
      //       itemBuilder: (context, index) {
      //         return ZipZopContainer(
      //           currentUserId: widget.currentUserId,
      //           author: author,
      //           zipZop: _mediaZipZops[index],
      //         );
      //       });
      default:
        return const Center(
          child: Text('Profile view deu errado'),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: FutureBuilder(
          future: usersRef.doc(widget.visitedUserId).get(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.red)));
            }
            UserModel user = UserModel.fromDoc(snapshot.data);
            return ListView(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              children: [
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: KzipZopColor,
                    image: user.coverImage.isEmpty
                        ? null
                        : const DecorationImage(
                            fit: BoxFit.cover,
                            // image: NetworkImage(user.coverImage),

                            image: AssetImage('assets/tumblr cover.png'),
                          ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox.shrink(),
                        widget.currentUserId == widget.visitedUserId
                            ? PopupMenuButton(
                                icon: const Icon(
                                  Icons.more_horiz,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                itemBuilder: (_) {
                                  return <PopupMenuItem<String>>[
                                    const PopupMenuItem(
                                      value: 'logout',
                                      child: Text('Logout'),
                                    )
                                  ];
                                },
                                onSelected: (selectedItem) {
                                  // Drawer, futuramente
                                  if (selectedItem == 'logout') {
                                    AuthService.logout();
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const WelcomeScreen()));
                                  }
                                },
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ),
                ),
                Container(
                  transform: Matrix4.translationValues(0.0, -40.0, 0.0),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const CircleAvatar(
                            radius: 45,
                            backgroundImage:
                                // const AssetImage('assets/zip zop.png'),
                                NetworkImage(
                                    'https://thispersondoesnotexist.com/image'),
                            // backgroundImage: user.profilePicture.isEmpty
                            //     ? const AssetImage('assets/zip zop.png')
                            //         as ImageProvider
                            //     : const NetworkImage(
                            //         'https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.ufpb.br%2Fcoremu%2Ficons%2Fredes-sociais%2Ftumblr.png%2Fimage_view_fullscreen&psig=AOvVaw2m5Q1-DjL5jWAYlZY5-rXK&ust=1668544185101000&source=images&cd=vfe&ved=0CA8QjRxqFwoTCNDL5czBrvsCFQAAAAAdAAAAABAE'),
                            // : NetworkImage(user.profilePicture),
                          ),
                          widget.currentUserId == widget.visitedUserId
                              ? GestureDetector(
                                  onTap: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditProfileScreen(
                                          user: user,
                                        ),
                                      ),
                                    );
                                    setState(() {});
                                  },
                                  child: Container(
                                    width: 100,
                                    height: 35,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.white,
                                      border: Border.all(color: KzipZopColor),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'Edit',
                                        style: TextStyle(
                                          fontSize: 17,
                                          color: KzipZopColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : GestureDetector(
                                  onTap: followOrUnFollow,
                                  child: Container(
                                    width: 100,
                                    height: 35,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: _isFollowing
                                          ? Colors.white
                                          : KzipZopColor,
                                      border: Border.all(color: KzipZopColor),
                                    ),
                                    child: Center(
                                      child: Text(
                                        _isFollowing ? 'Following' : 'Follow',
                                        style: TextStyle(
                                          fontSize: 17,
                                          color: _isFollowing
                                              ? KzipZopColor
                                              : Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        user.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        user.bio,
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Text(
                            '$_followingCount Following',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Text(
                            '$_followersCount Followers',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
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
                      ),
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
