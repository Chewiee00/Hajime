import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseUserAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getAllPlayers() {
    return db.collection("player").snapshots();
  }

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

  Future<String> removeLog(String? id, String log) async {
    try {
      await db.collection("player").doc(id).update({
        'logs': FieldValue.arrayRemove([log])
      });
      return "Successfully removed attendance log!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Future<String> editElo(String? id, double elo) async {
    try {
      await db.collection("player").doc(id).update({'elo': elo});
      return "Successfully updated elo!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Future<String> editbeltColor(String? id, String beltcolor) async {
    try {
      await db.collection("player").doc(id).update({'beltcolor': beltcolor});
      return "Successfully updated belt color";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Future<String> editcontactNumber(String? id, String contactnumber) async {
    try {
      await db
          .collection("player")
          .doc(id)
          .update({'contactnumber': contactnumber});
      return "Successfully updated contactnumber!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Future<String> editHeight(String? id, String height) async {
    try {
      await db.collection("player").doc(id).update({'height': height});
      return "Successfully updated height!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Future<String> editWeight(String? id, String weight) async {
    try {
      await db.collection("player").doc(id).update({'weight': weight});
      return "Successfully updated weight!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Future<String> addTeamname(String? id, String teamname, String teamid) async {
    try {
      print("New String: $teamname");
      await db.collection("player").doc(id).update({"teamname": teamname});
      await db.collection("player").doc(id).update({"teamid": teamid});

      return "Successfully added team!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Future<String> addLog(String? id, String log) async {
    try {
      await db.collection("player").doc(id).update({
        'logs': FieldValue.arrayUnion([log])
      });
      return "Successfully added attendance log!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Future<String> addMatchlog(String? id, String matchlog) async {
    try {
      await db.collection("player").doc(id).update({
        'matchlogs': FieldValue.arrayUnion([matchlog])
      });
      return "Successfully added attendance log!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Future<Map<String, dynamic>?> getSpecificPlayer(String? uid) async {
    try {
      final docRef = db.collection("player").doc(uid);
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

  Future<String> removeTeam(String? id) async {
    try {
      await db.collection("player").doc(id).update({"teamname": null});
      await db.collection("player").doc(id).update({"teamid": null});

      return "Successfully removed team!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Future<String> resetElo(String? id) async {
    try {
      await db.collection("player").doc(id).update({"elo": 1200});

      return "Successfully elo reset!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Future<String> removelogs(String? id) async {
    try {
      await db.collection("player").doc(id).update({"logs": []});
      await db.collection("player").doc(id).update({"matchlogs": []});
      return "Successfully removed logs!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }
}
