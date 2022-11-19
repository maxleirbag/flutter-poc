import 'package:flutter/material.dart';
import 'package:sabia_app/Constants/Constants.dart';

import '../Models/UserModel.dart';
import '../Models/ZipZop.dart';
import '../Services/DatabaseServices.dart';
import '../Widgets/ZipZopContainer.dart';

class HomeScreen extends StatefulWidget {
  final String currentUserId;

  const HomeScreen({super.key, required this.currentUserId});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List _followingZipZops = [];
  bool _loading = false;

  buildZipZops(ZipZop zipZop, UserModel author) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: ZipZopContainer(
        zipZop: zipZop,
        author: author,
        currentUserId: widget.currentUserId,
      ),
    );
  }

  showFollowingZipZops(String currentUserId) {
    List<Widget> followingZipZopsList = [];
    for (ZipZop zipZop in _followingZipZops) {
      followingZipZopsList.add(FutureBuilder(
          future: usersRef.doc(zipZop.authorId).get(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              UserModel author = UserModel.fromDoc(snapshot.data);
              return buildZipZops(zipZop, author);
            } else {
              return const SizedBox.shrink();
            }
          }));
    }
    return followingZipZopsList;
  }

  setupFollowingZipZops() async {
    setState(() {
      _loading = true;
    });
    List followingZipZops =
        await DatabaseServices.getHomeZipZops(widget.currentUserId);
    if (mounted) {
      setState(() {
        _followingZipZops = followingZipZops;
        _loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    setupFollowingZipZops();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: RefreshIndicator(
          onRefresh: () => setupFollowingZipZops(),
          child: ListView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            children: [
              _loading
                  ? const LinearProgressIndicator()
                  : const SizedBox.shrink(),
              const SizedBox(height: 5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 5),
                  Column(
                    children: _followingZipZops.isEmpty && _loading == false
                        ? [
                            const SizedBox(height: 5),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 25),
                              child: Text(
                                'Não existem novos ZipZops',
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            )
                          ]
                        : showFollowingZipZops(widget.currentUserId),
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
