import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test1/api/firebase_player_api.dart';

import '../model/player_model.dart';

class PlayerProvider with ChangeNotifier {
  late FirebaseUserAPI firebaseService;
  late Stream<QuerySnapshot> _playerStream;
  Player? _selectedUser;

  PlayerProvider() {
    firebaseService = FirebaseUserAPI();
    fetchPlayers();
  }

  // getter
  Stream<QuerySnapshot> get players => _playerStream;
  Player get selected => _selectedUser!;

  selectUser(Player item) {
    _selectedUser = item;
  }

  void fetchPlayers() {
    _playerStream = firebaseService.getAllPlayers();
    notifyListeners();
  }

  void addTeamname(String teamname, String teamid) async {
    String message =
        await firebaseService.addTeamname(_selectedUser!.id, teamname, teamid);
    print(message);
    notifyListeners();
  }

  void addLog(String log) async {
    String message = await firebaseService.addLog(_selectedUser!.id, log);
    print(message);
    notifyListeners();
  }

  void editLog(String log) async {
    String message = await firebaseService.addLog(_selectedUser!.id, log);
    print(message);
    notifyListeners();
  }

  void removeLog(String log) async {
    String message = await firebaseService.removeLog(_selectedUser!.id, log);
    print(message);
    notifyListeners();
  }

  void editElo(double elo) async {
    String message = await firebaseService.editElo(_selectedUser!.id, elo);
    print(message);
    notifyListeners();
  }

  void editHeight(String height) async {
    String message =
        await firebaseService.editHeight(_selectedUser!.id, height);
    print(message);
    notifyListeners();
  }

  void editWeight(String weight) async {
    String message =
        await firebaseService.editWeight(_selectedUser!.id, weight);
    print(message);
    notifyListeners();
  }

  void editcontactNumber(String contactnumber) async {
    String message = await firebaseService.editcontactNumber(
        _selectedUser!.id, contactnumber);
    print(message);
    notifyListeners();
  }

  void editBeltcolor(String beltcolor) async {
    String message =
        await firebaseService.editbeltColor(_selectedUser!.id, beltcolor);
    print(message);
    notifyListeners();
  }

  void addMatchlog(String matchlog) async {
    String message =
        await firebaseService.addMatchlog(_selectedUser!.id, matchlog);
    print(message);
    notifyListeners();
  }

  // void addMatchlog(String matchlog) async {
  //   String message =
  //       await firebaseService.addMatchlog(_selectedUser!.id, matchlog);
  //   print(message);
  //   notifyListeners();
  // }

  void removeTeam() async {
    String message = await firebaseService.removeTeam(_selectedUser!.id);
    print(message);
    notifyListeners();
  }

  void resetElo() async {
    String message = await firebaseService.resetElo(_selectedUser!.id);
    print(message);
    notifyListeners();
  }

  void removelogs() async {
    String message = await firebaseService.removelogs(_selectedUser!.id);
    print(message);
    notifyListeners();
  }

  Future<Map<String, dynamic>?> viewSpecificPlayer(String? uid) async {
    Map<String, dynamic>? player = await firebaseService.getSpecificPlayer(uid);
    return player;
  }
}
