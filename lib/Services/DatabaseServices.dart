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

    //   DocumentReference zipZopDocFeed =
    //       feedRefs.doc(currentUserId).collection('userFeed').doc(zipZop.id);
    //   zipZopDocFeed.get().then((doc) {
    //     if (doc.exists) {
    //       int likes = doc.data()['likes'];
    //       zipZopDocFeed.update({'likes': likes + 1});
    //     }
    //   });
    //
    likesRef
        .doc(zipZop.id)
        .collection('zipZopLikes')
        .doc(currentUserId)
        .set({});
    //
    //   addActivity(currentUserId, zipZop, false, null);
  }

  static Future<bool> isLikeZipZop(String currentUserId, ZipZop zipZop) async {
    DocumentSnapshot userDoc = await likesRef
        .doc(zipZop.id)
        .collection('zipZopLikes')
        .doc(currentUserId)
        .get();

    return userDoc.exists;
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
}
