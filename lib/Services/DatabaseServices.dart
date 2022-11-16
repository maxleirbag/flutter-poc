import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sabia_app/Constants/Constants.dart';
import 'package:sabia_app/Models/ZipZop.dart';
import '../Models/UserModel.dart';

class DatabaseServices {
  late bool _isFollowing;

  static Future<int> followersNum(String userId) async {
    QuerySnapshot followersSnapshot =
        await followersRef.doc(userId).collection('Followers').get();
    return followersSnapshot.docs.length;
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

    // addActivity(currentUserId, null, true, visitedUserId);
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

  static void updateUserData(UserModel user) {
    usersRef.doc(user.id).update({'name': user.name, 'bio': user.bio});
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
      QuerySnapshot followersSnapshot =
          await followersRef.doc(zipZop.authorId).collection('followers').get();
      for (var docSnapshot in followersSnapshot.docs) {
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
}
