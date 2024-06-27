import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseUserAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getAllTeams() {
    return db.collection("team").snapshots();
  }

  //FOR GETTING OUT OF THE TEAM
  Future<String> deleteTeam(String? id, String? teamid) async {
    try {
      await db.collection("users").doc(id).update({'team': null});
      return "Successfully deleted team!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Future<String> acceptFriend(String? id, String? addeduserid) async {
    try {
      await db.collection("users").doc(id).update({
        'friends': FieldValue.arrayUnion([addeduserid])
      });
      await db.collection("users").doc(addeduserid).update({
        'friends': FieldValue.arrayUnion([id])
      });
      await db.collection("users").doc(id).update({
        'receivedFriendRequests': FieldValue.arrayRemove([addeduserid])
      });
      await db.collection("users").doc(addeduserid).update({
        'sentFriendRequests': FieldValue.arrayRemove([id])
      });
      return "Successfully Accepted Friend Request!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Future<String> rejectFriend(String? id, String? rejecteduserid) async {
    try {
      await db.collection("users").doc(id).update({
        'receivedFriendRequests': FieldValue.arrayRemove([rejecteduserid])
      });
      await db.collection("users").doc(rejecteduserid).update({
        'sentFriendRequests': FieldValue.arrayRemove([id])
      });
      return "Successfully Rejected Friend Request!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Future<String> addPlayer(String? id, String playerid) async {
    try {
      await db.collection("team").doc(id).update({
        'players': FieldValue.arrayUnion([playerid])
      });
      return "Successfully added player!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Future<String> addMatchlog(String? id, String matchlog) async {
    try {
      await db.collection("team").doc(id).update({
        'matchlogs': FieldValue.arrayUnion([matchlog])
      });
      return "Successfully added attendance log!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Future<String> addLog(String? id, String log) async {
    try {
      await db.collection("team").doc(id).update({
        'logs': FieldValue.arrayUnion([log])
      });
      return "Successfully added attendance log!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Future<String> removeLog(String? id, String log) async {
    try {
      await db.collection("team").doc(id).update({
        'logs': FieldValue.arrayRemove([log])
      });
      return "Successfully removed attendance log!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Future<String> removePlayer(String? id, String? playerid) async {
    try {
      await db.collection("team").doc(id).update({
        'players': FieldValue.arrayRemove([playerid])
      });
      return "Successfully removed player!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Future<Map<String, dynamic>?> getSpecificTeam(String uid) async {
    try {
      final docRef = db.collection("team").doc(uid);
      final docSnapshot = await docRef.get();
      if (docSnapshot.exists) {
        return docSnapshot.data() as Map<String, dynamic>;
      } else {
        return null;
      }
    } catch (e) {
      throw e;
    }
  }
}
