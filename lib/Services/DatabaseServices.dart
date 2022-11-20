import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sabia_app/Constants/Constants.dart';
import 'package:sabia_app/Models/ZipZop.dart';

import '../Models/Activity.dart';
import '../Models/UserModel.dart';

class DatabaseServices {
  late bool _isFollowing;

  static Future<QuerySnapshot> getUsersByName(String name) async {
    Future<QuerySnapshot> users = usersRef
        .where('name', isGreaterThanOrEqualTo: name)
        .where('name', isLessThan: '${name}z')
        .get();
    return users;
  }

  static Future<QuerySnapshot> getUsersByEmail(String email) async {
    Future<QuerySnapshot> users = usersRef
        .where('email', isGreaterThanOrEqualTo: email)
        .where('email', isLessThan: '${email}z')
        .get();
    return users;
  }

  static bool updateUserData(UserModel user) {
    if (user.name.isNotEmpty && user.bio.isNotEmpty) {
      usersRef.doc(user.id).update({
        'name': user.name,
        'bio': user.bio,
      });
      return true;
    }
    return false;
  }

  static Future<int> followersNum(String userId) async {
    QuerySnapshot followersSnapshot =
        await followersRef.doc(userId).collection('Followers').get();
    return followersSnapshot.docs.length;
  }

  static Future<int> followingNum(String visitedUserId) async {
    QuerySnapshot followingSnapshot =
        await followingRef.doc(visitedUserId).collection('Following').get();
    return followingSnapshot.docs.length;
  }

  static void followUser(String currentUserId, String visitedUserId) {
    followingRef
        .doc(currentUserId)
        .collection('Following')
        .doc(visitedUserId)
        .set({});
    followersRef
        .doc(visitedUserId)
        .collection('Followers')
        .doc(currentUserId)
        .set({});

    addActivity(currentUserId, null, true, visitedUserId);
  }

  static void unFollowUser(String currentUserId, String visitedUserId) {
    followingRef
        .doc(currentUserId)
        .collection('Following')
        .doc(visitedUserId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });

    followersRef
        .doc(visitedUserId)
        .collection('Followers')
        .doc(currentUserId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }

  static Future<bool> isFollowingUser(
      String currentUserId, String visitedUserId) async {
    DocumentSnapshot followingDoc = await followersRef
        .doc(visitedUserId)
        .collection('Followers')
        .doc(currentUserId)
        .get();
    return followingDoc.exists;
  }

  static void createZipZop(ZipZop zipZop) {
    zipZopsRef.doc(zipZop.authorId).set({'zipZopTime': zipZop.timestamp});
    zipZopsRef.doc(zipZop.authorId).collection('userZipZops').add({
      'text': zipZop.text,
      'authorId': zipZop.authorId,
      'timestamp': zipZop.timestamp,
      'likes': zipZop.likes,
      'shares': zipZop.shares,
    }).then((doc) async {
      QuerySnapshot followerSnapshot =
          await followersRef.doc(zipZop.authorId).collection('Followers').get();
      for (var docSnapshot in followerSnapshot.docs) {
        feedRefs.doc(docSnapshot.id).collection('userFeed').doc(doc.id).set({
          'text': zipZop.text,
          'authorId': zipZop.authorId,
          'timestamp': zipZop.timestamp,
          'likes': zipZop.likes,
          'shares': zipZop.shares,
        });
      }
    });
  }

  static Future<List> getUserZipZops(String userId) async {
    QuerySnapshot userZipZopsSnap = await zipZopsRef
        .doc(userId)
        .collection('userZipZops')
        .orderBy('timestamp', descending: true)
        .get();
    List<ZipZop> userZipZops =
        userZipZopsSnap.docs.map((doc) => ZipZop.fromDoc(doc)).toList();
    return userZipZops;
  }

  static Future<List> getHomeZipZops(String currentUserId) async {
    QuerySnapshot homeZipZops = await feedRefs
        .doc(currentUserId)
        .collection('userFeed')
        .orderBy('timestamp', descending: true)
        .get();

    List<ZipZop> followingZipZops =
        homeZipZops.docs.map((doc) => ZipZop.fromDoc(doc)).toList();
    return followingZipZops;
  }

  static void likeZipZop(String currentUserId, ZipZop zipZop) {
    DocumentReference zipZopDocProfile = zipZopsRef
        .doc(zipZop.authorId)
        .collection('userZipZops')
        .doc(zipZop.id);
    zipZopDocProfile.get().then((doc) {
      final docData = doc.data() as Map<dynamic, dynamic>;
      int likes = docData['likes'];
      zipZopDocProfile.update({'likes': likes + 1});
    });

    DocumentReference zipZopDocFeed =
        feedRefs.doc(currentUserId).collection('userFeed').doc(zipZop.id);
    zipZopDocFeed.get().then((doc) {
      if (doc.exists) {
        final docData = doc.data() as Map<dynamic, dynamic>;
        int likes = docData['likes'];
        zipZopDocFeed.update({'likes': likes + 1});
      }
    });

    likesRef
        .doc(zipZop.id)
        .collection('zipZopLikes')
        .doc(currentUserId)
        .set({});

    addActivity(currentUserId, zipZop, false, null);
  }

  static void unlikeZipZop(String currentUserId, ZipZop zipZop) {
    DocumentReference zipZopDocProfile = zipZopsRef
        .doc(zipZop.authorId)
        .collection('userZipZops')
        .doc(zipZop.id);
    zipZopDocProfile.get().then((doc) {
      final docData = doc.data() as Map<dynamic, dynamic>;
      int likes = docData['likes'];
      zipZopDocProfile.update({'likes': likes - 1});
    });

    DocumentReference zipZopDocFeed =
        feedRefs.doc(currentUserId).collection('userFeed').doc(zipZop.id);
    zipZopDocFeed.get().then((doc) {
      if (doc.exists) {
        final docData = doc.data() as Map<dynamic, dynamic>;
        int likes = docData['likes'];
        zipZopDocFeed.update({'likes': likes - 1});
      }
    });

    likesRef
        .doc(zipZop.id)
        .collection('zipZopLikes')
        .doc(currentUserId)
        .get()
        .then((doc) => doc.reference.delete());
  }

  static Future<bool> isLikeZipZop(String currentUserId, ZipZop zipZop) async {
    DocumentSnapshot userDoc = await likesRef
        .doc(zipZop.id)
        .collection('zipZopLikes')
        .doc(currentUserId)
        .get();

    return userDoc.exists;
  }

  static void addActivity(String currentUserId, ZipZop? zipZop, bool follow,
      String? followedUserId) {
    if (follow) {
      activitiesRef.doc(followedUserId).collection('userActivities').add({
        'fromUserId': currentUserId,
        'timestamp': Timestamp.fromDate(DateTime.now()),
        'follow': true,
      });
    } else {
      activitiesRef.doc(zipZop!.authorId).collection('userActivities').add({
        'fromUserId': currentUserId,
        'timestamp': Timestamp.fromDate(DateTime.now()),
        'follow': false,
      });
    }
  }

  static Future<List<Activity>> getActivities(String userId) async {
    QuerySnapshot userActivitiesSnapshot = await activitiesRef
        .doc(userId)
        .collection('userActivities')
        .orderBy('timestamp', descending: true)
        .get();

    List<Activity> activities = [];

    var activity;
    for (activity in userActivitiesSnapshot.docs) {
      // print(activity.data());
      var coisa = new Activity(
          fromUserId: activity.data()['fromUserId'],
          timestamp: activity.data()['timestamp'],
          follow: activity.data()['follow'].toString().contains('true')
              ? true
              : false);
      activities.add(coisa);
    }

    return activities;
  }

  static String randomImageProfilePicker() {
    String prefixo = 'assets/';
    String sufixo = '.jpeg';

    List<String> fotosDisponiveis = [
      'firstBotImage',
      'secondBotImage',
      'thirdBotImage',
      'fourthBotImage',
      'fifthBotImage',
      'sixthBotImage',
    ];
    Random rng = Random();
    int numAleatorio = rng.nextInt(fotosDisponiveis.length - 1);
    String sorteada = fotosDisponiveis[numAleatorio];
    String selecionada = '$prefixo$sorteada$sufixo';

    return selecionada;
  }

  static String randomBackgroundImagePicker() {
    String prefixo = 'assets/';
    String sufixo = '.png';

    List<String> capasDisponiveis = [
      'firstBg',
      'secondBg',
      'thirdBg',
      'fourthBg',
      'fifthBg',
      'sixthBg',
    ];
    Random rng = Random();
    int numAleatorio = rng.nextInt(capasDisponiveis.length - 1);
    String sorteada = capasDisponiveis[numAleatorio];
    String selecionada = '$prefixo$sorteada$sufixo';

    return selecionada;
  }
}
