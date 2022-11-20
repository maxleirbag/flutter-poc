import 'package:flutter/material.dart';

import '../Constants/Constants.dart';
import '../Models/Activity.dart';
import '../Models/UserModel.dart';
import '../Services/DatabaseServices.dart';

class NotificationsScreen extends StatefulWidget {
  final String currentUserId;

  const NotificationsScreen({super.key, required this.currentUserId});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<Activity> _activities = [];
  bool loading = false;

  setupActivities() async {
    List<Activity> activities =
        await DatabaseServices.getActivities(widget.currentUserId);
    if (mounted) {
      setState(() {
        _activities = activities;
        loading = false;
      });
    }
  }

  buildActivity(Activity activity) {
    return FutureBuilder(
        future: usersRef.doc(activity.fromUserId).get(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox.shrink();
            loading = false;
          } else {
            loading = true;
            UserModel user = UserModel.fromDoc(snapshot.data);
            loading = false;
            return Column(
              children: [
                ListTile(
                  leading: CircleAvatar(
                      radius: 20,
                      backgroundImage: Image.asset(user.profilePicture).image),
                  title: activity.follow == true
                      ? Text(
                          '${user.name} te segue. (${activity.timestamp.toDate().toString().substring(0, 19)})')
                      : Text(
                          '${user.name} gostou do seu Pombo Correio. (${activity.timestamp.toDate().toString().substring(0, 19)})'),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Divider(
                    color: primaryColor,
                    thickness: 1,
                  ),
                )
              ],
            );
          }
        });
  }

  @override
  void initState() {
    super.initState();
    setupActivities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: RefreshIndicator(
            onRefresh: () => setupActivities(),
            child: _activities.isEmpty && loading == false
                ? const Center(
                    child: Text(
                      'Não existem novas atividades',
                      style: TextStyle(fontSize: 20, color: defaultDarkColor),
                    ),
                  )
                : _activities.isNotEmpty
                    ? ListView.builder(
                        itemCount: _activities.length,
                        itemBuilder: (BuildContext context, int index) {
                          Activity activity = _activities[index];
                          return buildActivity(activity);
                        })
                    : const Center(
                        child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation(primaryColor)))));
  }
}
