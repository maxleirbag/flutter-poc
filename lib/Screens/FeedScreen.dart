import 'package:flutter/material.dart';
import 'package:sabia_app/Constants/ColorPalette.dart';
import 'package:sabia_app/Constants/DbInstances.dart';

import '../Models/PomboCorreio.dart';
import '../Models/UserModel.dart';
import '../Services/DatabaseServices.dart';
import '../Widgets/PomboCorreioContainer.dart';

class FeedScreen extends StatefulWidget {
  final String currentUserId;

  const FeedScreen({super.key, required this.currentUserId});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  List _followingPombosCorreios = [];
  bool _loading = false;

  buildPombosCorreios(PomboCorreio pomboCorreio, UserModel author) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: PomboCorreioContainer(
        pomboCorreio: pomboCorreio,
        author: author,
        currentUserId: widget.currentUserId,
      ),
    );
  }

  showFollowingPombosCorreios(String currentUserId) {
    List<Widget> followingPombosCorreiosList = [];
    for (PomboCorreio pomboCorreio in _followingPombosCorreios) {
      followingPombosCorreiosList.add(FutureBuilder(
          future: usersRef.doc(pomboCorreio.authorId).get(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              UserModel author = UserModel.fromDoc(snapshot.data);
              return buildPombosCorreios(pomboCorreio, author);
            } else {
              return const SizedBox.shrink();
            }
          }));
    }
    return followingPombosCorreiosList;
  }

  setupFollowingPombosCorreios() async {
    setState(() {
      _loading = true;
    });
    List followingPombosCorreios =
        await DatabaseServices.getHomePombosCorreios(widget.currentUserId);
    if (mounted) {
      setState(() {
        _followingPombosCorreios = followingPombosCorreios;
        _loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    setupFollowingPombosCorreios();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: defaultLightColor,
        body: RefreshIndicator(
          onRefresh: () => setupFollowingPombosCorreios(),
          child: ListView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            children: [
              _loading
                  ? const LinearProgressIndicator()
                  : Column(
                      children: _followingPombosCorreios.isEmpty &&
                              _loading == false
                          ? [
                              const Center(
                                child: Text(
                                  'Não existem novos Pombos Correios',
                                  style: TextStyle(
                                      fontSize: 20, color: defaultDarkColor),
                                ),
                              ),
                            ]
                          : showFollowingPombosCorreios(widget.currentUserId),
                    )
            ],
          ),
        ));
  }
}
