import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sabia_app/Models/PomboCorreio.dart';

import '../Constants/DbInstances.dart';
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

  static void createPomboCorreio(PomboCorreio pomboCorreio) {
    pomboCorreiosRef
        .doc(pomboCorreio.authorId)
        .set({'pomboCorreioTime': pomboCorreio.timestamp});
    pomboCorreiosRef
        .doc(pomboCorreio.authorId)
        .collection('userPombosCorreios')
        .add({
      'text': pomboCorreio.text,
      'authorId': pomboCorreio.authorId,
      'timestamp': pomboCorreio.timestamp,
      'likes': pomboCorreio.likes,
      'shares': pomboCorreio.shares,
    }).then((doc) async {
      QuerySnapshot followerSnapshot = await followersRef
          .doc(pomboCorreio.authorId)
          .collection('Followers')
          .get();
      for (var docSnapshot in followerSnapshot.docs) {
        feedRefs.doc(docSnapshot.id).collection('userFeed').doc(doc.id).set({
          'text': pomboCorreio.text,
          'authorId': pomboCorreio.authorId,
          'timestamp': pomboCorreio.timestamp,
          'likes': pomboCorreio.likes,
          'shares': pomboCorreio.shares,
        });
      }
    });
  }

  static Future<List> getUserPombosCorreios(String userId) async {
    QuerySnapshot userPombosCorreiosSnap = await pomboCorreiosRef
        .doc(userId)
        .collection('userPombosCorreios')
        .orderBy('timestamp', descending: true)
        .get();
    List<PomboCorreio> userPombosCorreios = userPombosCorreiosSnap.docs
        .map((doc) => PomboCorreio.fromDoc(doc))
        .toList();
    return userPombosCorreios;
  }

  static Future<List> getHomePombosCorreios(String currentUserId) async {
    QuerySnapshot homePombosCorreios = await feedRefs
        .doc(currentUserId)
        .collection('userFeed')
        .orderBy('timestamp', descending: true)
        .get();

    List<PomboCorreio> followingPombosCorreios = homePombosCorreios.docs
        .map((doc) => PomboCorreio.fromDoc(doc))
        .toList();
    return followingPombosCorreios;
  }

  static void likePomboCorreio(
      String currentUserId, PomboCorreio pomboCorreio) {
    DocumentReference pomboCorreioDocProfile = pomboCorreiosRef
        .doc(pomboCorreio.authorId)
        .collection('userPombosCorreios')
        .doc(pomboCorreio.id);
    pomboCorreioDocProfile.get().then((doc) {
      final docData = doc.data() as Map<dynamic, dynamic>;
      int likes = docData['likes'];
      pomboCorreioDocProfile.update({'likes': likes + 1});
    });

    DocumentReference pomboCorreioDocFeed =
        feedRefs.doc(currentUserId).collection('userFeed').doc(pomboCorreio.id);
    pomboCorreioDocFeed.get().then((doc) {
      if (doc.exists) {
        final docData = doc.data() as Map<dynamic, dynamic>;
        int likes = docData['likes'];
        pomboCorreioDocFeed.update({'likes': likes + 1});
      }
    });

    likesRef
        .doc(pomboCorreio.id)
        .collection('pomboCorreioLikes')
        .doc(currentUserId)
        .set({});

    addActivity(currentUserId, pomboCorreio, false, null);
  }

  static void unlikePomboCorreio(
      String currentUserId, PomboCorreio pomboCorreio) {
    DocumentReference pomboCorreioDocProfile = pomboCorreiosRef
        .doc(pomboCorreio.authorId)
        .collection('userPombosCorreios')
        .doc(pomboCorreio.id);
    pomboCorreioDocProfile.get().then((doc) {
      final docData = doc.data() as Map<dynamic, dynamic>;
      int likes = docData['likes'];
      pomboCorreioDocProfile.update({'likes': likes - 1});
    });

    DocumentReference pomboCorreioDocFeed =
        feedRefs.doc(currentUserId).collection('userFeed').doc(pomboCorreio.id);
    pomboCorreioDocFeed.get().then((doc) {
      if (doc.exists) {
        final docData = doc.data() as Map<dynamic, dynamic>;
        int likes = docData['likes'];
        pomboCorreioDocFeed.update({'likes': likes - 1});
      }
    });

    likesRef
        .doc(pomboCorreio.id)
        .collection('pomboCorreioLikes')
        .doc(currentUserId)
        .get()
        .then((doc) => doc.reference.delete());
  }

  static Future<bool> isLikePomboCorreio(
      String currentUserId, PomboCorreio pomboCorreio) async {
    DocumentSnapshot userDoc = await likesRef
        .doc(pomboCorreio.id)
        .collection('pomboCorreioLikes')
        .doc(currentUserId)
        .get();

    return userDoc.exists;
  }

  static void addActivity(String currentUserId, PomboCorreio? pomboCorreio,
      bool follow, String? followedUserId) {
    if (follow) {
      activitiesRef.doc(followedUserId).collection('userActivities').add({
        'fromUserId': currentUserId,
        'timestamp': Timestamp.fromDate(DateTime.now()),
        'follow': true,
      });
    } else {
      activitiesRef
          .doc(pomboCorreio!.authorId)
          .collection('userActivities')
          .add({
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

    dynamic activity;
    for (activity in userActivitiesSnapshot.docs) {
      print(activity.data());
      var coisa = Activity(
          fromUserId: activity.data()['fromUserId'],
          timestamp: activity.data()['timestamp'],
          follow: activity.data()['follow']);
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
