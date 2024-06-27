import 'package:flutter/material.dart';
import 'package:flutter_test1/common/color_extension.dart';
import 'package:intl/intl.dart';

class AttendanceTab extends StatefulWidget {
  final Map<String, dynamic>? user;

  const AttendanceTab(this.user, {super.key});

  @override
  State<AttendanceTab> createState() => _AttendanceTabState();
}

class _AttendanceTabState extends State<AttendanceTab> {
  String name = "";
  List<dynamic> filteredLogs = [];
  @override
  void initState() {
    super.initState();
    filteredLogs = widget.user?['logs'].reversed.toList() ??
        []; // Initialize with all logs
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Card(
            child: TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search attendances by date/name/time',
                hintStyle: TextStyle(fontSize: 16.0),
                border: InputBorder.none,
              ),
              onChanged: (val) {
                setState(() {
                  name = val;
                  if (val.isNotEmpty) {
                    filteredLogs = widget.user?['logs']
                        .where((log) => log
                            .toString()
                            .toLowerCase()
                            .contains(val.toLowerCase()))
                        .toList();
                  } else {
                    filteredLogs = widget.user?['logs'].reversed.toList() ??
                        []; // Reset to original logs
                  }
                });
              },
            ),
          )),
      body: filteredLogs.isNotEmpty
          ? ListView.builder(
              itemCount: filteredLogs.length,
              itemBuilder: (context, index) {
                List<String> logs = filteredLogs[index].split("-");
                print(logs);
                String date = logs[0];
                String checkin = logs[1].substring(3);
                String checkout = "";
                if (logs[2] == "null") {
                  checkout = "--:--";
                } else {
                  checkout = logs[2].substring(4);
                }

                String name = logs[3];
                // String name = logs[3];
                // Parse the date string into a DateTime object
                int day = DateFormat('MMMM d, yyyy').parse(date).weekday;
                String dayofdate = "";

                switch (day) {
                  case 1:
                    dayofdate = "Mon";
                    break;
                  case 2:
                    dayofdate = "Teus";
                    break;
                  case 3:
                    dayofdate = "Wed";
                    break;
                  case 4:
                    dayofdate = "Thu";
                    break;
                  case 5:
                    dayofdate = "Fri";
                    break;
                  case 6:
                    dayofdate = "Sat";
                    break;
                  case 7:
                    dayofdate = "Sun";
                    break;

                  default:
                    dayofdate = "";
                }
                print("$date $checkin $checkout $day");

                return ListTile(
                  title: Column(
                    children: [
                      Center(
                        child: Container(
                          height: media.width * 0.2,
                          // padding: const EdgeInsets.symmetric(
                          //     vertical: 25, horizontal: 15),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(colors: TColor.primaryG),
                              boxShadow: [
                                BoxShadow(
                                    offset: Offset(0, 5),
                                    color: TColor.primaryColor1.withOpacity(.2),
                                    spreadRadius: 2,
                                    blurRadius: 10)
                              ]),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: TColor.secondaryColor2,
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Center(
                                          child: Text(dayofdate,
                                              style: TextStyle(
                                                  color: TColor.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700)),
                                        ),
                                        Center(
                                          child: Text(date,
                                              style: TextStyle(
                                                  color: TColor.white
                                                      .withOpacity(0.7),
                                                  fontSize: 16)),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Center(
                                        child: Text("Clock In",
                                            style: TextStyle(
                                                color: TColor.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700)),
                                      ),
                                      Center(
                                        child: Text(checkin,
                                            style: TextStyle(
                                                color: TColor.white
                                                    .withOpacity(0.7),
                                                fontSize: 16)),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Center(
                                        child: Text("Clock Out",
                                            style: TextStyle(
                                                color: TColor.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700)),
                                      ),
                                      Center(
                                        child: Text(checkout,
                                            style: TextStyle(
                                                color: TColor.white
                                                    .withOpacity(0.7),
                                                fontSize: 16)),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: media.width * .01,
                      ),
                      Container(
                        height: media.width * 0.1,
                        // padding: const EdgeInsets.symmetric(
                        //     vertical: 25, horizontal: 15),
                        decoration: BoxDecoration(
                            color: TColor.gray.withOpacity(.2),
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(0, 5),
                                  color: TColor.primaryColor1.withOpacity(.2),
                                  spreadRadius: 2,
                                  blurRadius: 10)
                            ]),
                        child: Center(
                          child: Text(name,
                              style:
                                  TextStyle(color: TColor.white, fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                );
              },
            )
          : const Center(child: Text('No matching logs found')),
    );
  }
}
