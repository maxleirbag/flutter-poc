import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sabia_app/Constants/ColorPalette.dart';

import '../Constants/DbInstances.dart';
import '../Models/UserModel.dart';
import '../Services/DatabaseServices.dart';
import '../Widgets/PomboCorreioContainer.dart';
import 'EditProfileScreen.dart';
import 'SkeletonScreen.dart';

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
  List<dynamic> _allPombosCorreios = [];
  String chosenMemory = DatabaseServices.randomBackgroundImagePicker();

  final Map<int, Widget> _profileTabs = <int, Widget>{
    0: const Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        'Pombos Correios',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: defaultDarkColor,
        ),
      ),
    ),
    1: const Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        'Lembrança: Capa de Perfil Antiga',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: defaultDarkColor,
        ),
      ),
    ),
  };

  getAllPombosCorreios() async {
    List userPombosCorreios =
        await DatabaseServices.getUserPombosCorreios(widget.visitedUserId);
    if (mounted) {
      setState(() {
        _allPombosCorreios = userPombosCorreios;
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

  getFollowingCount() async {
    int followingCount =
        await DatabaseServices.followingNum(widget.visitedUserId);
    if (mounted) {
      setState(() {
        _followingCount = followingCount;
      });
    }
  }

  setupIsFollowing() async {
    bool isFollowingThisUser = await DatabaseServices.isFollowingUser(
        widget.currentUserId, widget.visitedUserId);
    setState(() {
      _isFollowing = isFollowingThisUser;
    });
  }

  @override
  void initState() {
    super.initState();
    getFollowersCount();
    getFollowingCount();
    setupIsFollowing();
    getAllPombosCorreios();
  }

  Widget buildProfileWidgets(UserModel author) {
    switch (_profileSegmentedValue) {
      case 0:
        return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _allPombosCorreios.length,
            itemBuilder: (context, index) {
              return PomboCorreioContainer(
                currentUserId: widget.currentUserId,
                author: author,
                pomboCorreio: _allPombosCorreios[index],
              );
            });
      case 1:
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 50),
          child: Image.asset(chosenMemory),
        );

      default:
        return const Center(
          child: Text(
            'Conteúdo não pôde ser carregado.',
            style: TextStyle(fontSize: 25, color: defaultDarkColor),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: IconButton(
            color: defaultLightColor,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SkeletonScreen(
                            currentUserId: widget.currentUserId,
                          )));
            },
            icon: const Icon(
              CupertinoIcons.arrow_left,
              color: secondaryColor,
            )),
        backgroundColor: defaultLightColor,
        body: FutureBuilder(
          future: usersRef.doc(widget.visitedUserId).get(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(primaryColor)));
            }
            UserModel user = UserModel.fromDoc(snapshot.data);
            return ListView(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              children: [
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: tertiaryColor,
                    image: user.coverImage.isEmpty
                        ? null
                        : DecorationImage(
                            fit: BoxFit.cover,
                            image: Image.asset(user.coverImage).image),
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
                          CircleAvatar(
                            radius: 45,
                            backgroundImage:
                                Image.asset(user.profilePicture).image,
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
                                      color: defaultLightColor,
                                      border: Border.all(color: tertiaryColor),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'Editar',
                                        style: TextStyle(
                                          fontSize: 17,
                                          color: tertiaryColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : GestureDetector(
                                  onTap: followOrUnFollow,
                                  child: Container(
                                    width: 115,
                                    height: 40,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: _isFollowing
                                          ? defaultLightColor
                                          : primaryColor,
                                      border: Border.all(color: primaryColor),
                                    ),
                                    child: Center(
                                      child: Text(
                                        _isFollowing ? 'Following' : 'Follow',
                                        style: TextStyle(
                                          fontSize: 17,
                                          color: _isFollowing
                                              ? primaryColor
                                              : defaultDarkColor,
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
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: defaultDarkColor),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        user.bio,
                        style: const TextStyle(
                            fontSize: 20,
                            color: defaultGrayColor,
                            fontStyle: FontStyle.italic),
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
                                color: defaultDarkColor),
                          ),
                          const SizedBox(width: 20),
                          Text(
                            '$_followersCount Followers',
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 2,
                                color: defaultDarkColor),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: CupertinoSlidingSegmentedControl(
                          groupValue: _profileSegmentedValue,
                          thumbColor: primaryColor,
                          backgroundColor: defaultGrayColor,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 2, vertical: 2),
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
