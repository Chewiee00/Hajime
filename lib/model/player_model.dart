import 'dart:convert';

class Player {
  String? id;
  String? teamid;
  String displayname;
  String email;
  String sex;
  String birthdate;
  String trainingdateStart;
  String? teamname;
  String beltcolor;
  String contactnumber;
  String height;
  String weight;
  double elo;
  List<dynamic> logs;
  List<dynamic> matchlogs;

  Player(
      {this.id,
      this.teamid,
      required this.displayname,
      required this.email,
      required this.sex,
      required this.birthdate,
      required this.trainingdateStart,
      required this.teamname,
      required this.beltcolor,
      required this.contactnumber,
      required this.height,
      required this.weight,
      required this.elo,
      required this.logs,
      required this.matchlogs});

  // Factory constructor to instantiate object from json format
  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
        id: json['id'],
        teamid: json['teamid'],
        displayname: json['displayname'],
        email: json['email'],
        sex: json['sex'],
        birthdate: json['birthdate'],
        trainingdateStart: json['trainingdateStart'],
        beltcolor: json['beltcolor'],
        teamname: json['teamname'],
        contactnumber: json['contactnumber'],
        height: json['height'],
        weight: json['weight'],
        elo: json['elo'].toDouble(),
        logs: json['logs'],
        matchlogs: json['matchlogs']);
  }

  static List<Player> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<Player>((dynamic d) => Player.fromJson(d)).toList();
  }

  Map<String, dynamic> toJson(Player player) {
    return {
      'displayname': player.displayname,
      'teamid': player.teamid,
      'email': player.email,
      'sex': player.sex,
      'birthdate': player.birthdate,
      'trainingdateStart': player.trainingdateStart,
      'beltcolor': player.beltcolor,
      'teamname': player.teamname,
      'contactnumber': player.contactnumber,
      'height': player.height,
      'weight': player.weight,
      'elo': player.elo,
      'logs': player.logs,
      'matchlogs': player.matchlogs,
    };
  }
}
