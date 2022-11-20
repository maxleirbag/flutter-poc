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

  setupActivities() async {
    List<Activity> activities =
        await DatabaseServices.getActivities(widget.currentUserId);
    if (mounted) {
      setState(() {
        _activities = activities;
      });
    }
  }

  buildActivity(Activity activity) {
    return FutureBuilder(
        future: usersRef.doc(activity.fromUserId).get(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox.shrink();
          } else {
            UserModel user = UserModel.fromDoc(snapshot.data);
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
                          '${user.name} gostou do seu ZipZop. (${activity.timestamp.toDate().toString().substring(0, 19)})'),
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
            child: _activities.isNotEmpty
                ? ListView.builder(
                    itemCount: _activities.length,
                    itemBuilder: (BuildContext context, int index) {
                      Activity activity = _activities[index];
                      return buildActivity(activity);
                    })
                : const Center(
                    child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(primaryColor)))));
  }
}
