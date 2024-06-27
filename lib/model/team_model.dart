import 'dart:convert';

class Team {
  String? id;
  String name;
  String code;
  // String address;
  // String contactnumber;
  List<dynamic> players;
  List<dynamic> matchlogs;
  List<dynamic> logs;

  Team(
      {this.id,
      required this.name,
      required this.code,
      // required this.address,
      // required this.contactnumber,
      required this.players,
      required this.matchlogs,
      required this.logs});

  // Factory constructor to instantiate object from json format
  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      // address: json['address'],
      // contactnumber: json['contactnumber'],
      players: json['players'],
      matchlogs: json['matchlogs'],
      logs: json['logs'],
    );
  }

  static List<Team> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<Team>((dynamic d) => Team.fromJson(d)).toList();
  }

  Map<String, dynamic> toJson(Team team) {
    return {
      'name': team.name,
      'code': team.code,
      // 'address': team.address,
      // 'contactnumber': team.contactnumber,
      'players': team.players,
      'matchlogs': team.matchlogs,
      'logs': team.logs
    };
  }
}
