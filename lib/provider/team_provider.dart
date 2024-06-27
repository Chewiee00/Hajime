import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test1/api/firebase_team_api.dart';
import 'package:flutter_test1/model/team_model.dart';

class TeamProvider with ChangeNotifier {
  late FirebaseUserAPI firebaseService;
  late Stream<QuerySnapshot> _teamStream;
  Team? _selectedUser;

  TeamProvider() {
    firebaseService = FirebaseUserAPI();
    fetchTeams();
  }

  // getter
  Stream<QuerySnapshot> get teams => _teamStream;
  Team get selected => _selectedUser!;

  selectUser(Team item) {
    _selectedUser = item;
  }

  void fetchTeams() {
    _teamStream = firebaseService.getAllTeams();
    notifyListeners();
  }

  void addPlayer(String playerid) async {
    String message =
        await firebaseService.addPlayer(_selectedUser!.id, playerid);
    print(message);
    notifyListeners();
  }

  void addMatchlog(String matchlog) async {
    String message =
        await firebaseService.addMatchlog(_selectedUser!.id, matchlog);
    print(message);
    notifyListeners();
  }

  void addLog(String log) async {
    String message = await firebaseService.addLog(_selectedUser!.id, log);
    print(message);
    notifyListeners();
  }

  void removeLog(String log) async {
    String message = await firebaseService.removeLog(_selectedUser!.id, log);
    print(message);
    notifyListeners();
  }

  void removePlayer(String? playerid) async {
    String message =
        await firebaseService.removePlayer(_selectedUser!.id, playerid);
    print(message);
    notifyListeners();
  }

  Future<Map<String, dynamic>?> viewSpecificTeam(String uid) async {
    Map<String, dynamic>? player = await firebaseService.getSpecificTeam(uid);
    return player;
  }
}
