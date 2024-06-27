import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test1/common/color_extension.dart';
import 'package:flutter_test1/common_widgets/round_textfield.dart';
import 'package:flutter_test1/model/player_model.dart';
import 'package:flutter_test1/provider/auth_provider.dart';
import 'package:flutter_test1/provider/player_provider.dart';
import 'package:provider/provider.dart';

// Temporary
// https://github.com/ahadhashmii/flutter_profile_tutorial/blob/master/lib/main.dart
class ProfileData extends StatefulWidget {
  final Map<String, dynamic>? user;
  final int type;
  const ProfileData(this.user, this.type, {super.key});

  @override
  State<ProfileData> createState() => _ProfileDataState();
}

class _ProfileDataState extends State<ProfileData> {
  String? _selectedBeltColor;
  late TextEditingController _heightController;
  late TextEditingController _weightController;
  late TextEditingController _contactnumberController;
  late TextEditingController _beltcolorController;
  final GlobalKey<FormState> _heightkey = GlobalKey<FormState>();
  final GlobalKey<FormState> _weightkey = GlobalKey<FormState>();
  final GlobalKey<FormState> _contactkey = GlobalKey<FormState>();
  final GlobalKey<FormState> _beltkey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _heightController = TextEditingController();
    _weightController = TextEditingController();
    _contactnumberController = TextEditingController();
    _beltcolorController = TextEditingController();
  }

  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    _contactnumberController.dispose();
    _beltcolorController.dispose();
    super.dispose();
  }

  itemProfile(String title, String subtitle, IconData iconData) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                offset: Offset(0, 5),
                color: TColor.primaryColor1.withOpacity(.2),
                spreadRadius: 2,
                blurRadius: 5)
          ]),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        leading: Icon(iconData),
        tileColor: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String displayname = widget.user?["displayname"];
    String contactnumber = widget.user?["contactnumber"];
    String email = widget.user?["email"];
    String beltcolor = widget.user?["beltcolor"];
    String height = widget.user?["height"];
    String weight = widget.user?["weight"];
    String sex = widget.user?["sex"];
    String birthdate = widget.user?["birthdate"];
    String trainingdateStart = widget.user?["trainingdateStart"];
    String teamname = widget.user?["teamname"] ?? "null";
    _heightController.text = height;
    _weightController.text = weight;

    _contactnumberController.text = contactnumber;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (widget.type == 0)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
                        context.read<AuthenticationProvider>().signOut();
                        Navigator.pushNamed(context, '/');
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(15),
                      ),
                      child: const Text('Sign Out')),
                ),
              const SizedBox(height: 20),
              itemProfile('Email', email, CupertinoIcons.mail),
              const SizedBox(
                height: 20,
              ),
              itemProfile('Sex', sex, CupertinoIcons.person),
              const SizedBox(
                height: 20,
              ),
              itemProfile('Birthdate', birthdate, Icons.celebration),
              const SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          offset: Offset(0, 5),
                          color: TColor.primaryColor1.withOpacity(.2),
                          spreadRadius: 2,
                          blurRadius: 5)
                    ]),
                child: widget.type == 0
                    ? ListTile(
                        title: Text("Phone Number"),
                        subtitle: Text(contactnumber),
                        leading: Icon(CupertinoIcons.phone),
                        tileColor: Colors.white,
                        trailing: ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return Form(
                                  key: _contactkey,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  child: AlertDialog(
                                      backgroundColor: TColor.white,
                                      title: const Text('Edit Contact Number'),
                                      content: RoundTextField(
                                        validator: validatePhoneContact,
                                        hintText: "Contact Number",
                                        controller: _contactnumberController,
                                        keyboardType: const TextInputType
                                            .numberWithOptions(decimal: true),
                                        margin: const EdgeInsets.symmetric(
                                          vertical: 10,
                                        ),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text("Submit"),
                                          style: TextButton.styleFrom(
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .bodyText1,
                                          ),
                                          onPressed: () async {
                                            if (_contactkey.currentState!
                                                .validate()) {
                                              context
                                                  .read<PlayerProvider>()
                                                  .selectUser(Player.fromJson(
                                                      widget.user!));
                                              context
                                                  .read<PlayerProvider>()
                                                  .editcontactNumber(
                                                      _contactnumberController
                                                          .text);
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                      content: Text(
                                                          'Phone number successfully edited!')));
                                              Navigator.of(context).pop();
                                            }
                                          },
                                        ),
                                        TextButton(
                                          child: Text("Cancel"),
                                          style: TextButton.styleFrom(
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .bodyText1,
                                          ),
                                          onPressed: () async {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ]),
                                );
                              },
                            );
                          },
                          child: const Text("Edit"), // Button text
                        ),
                      )
                    : ListTile(
                        title: Text("Phone Number"),
                        subtitle: Text(contactnumber),
                        leading: Icon(CupertinoIcons.phone),
                        tileColor: Colors.white,
                      ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          offset: Offset(0, 5),
                          color: TColor.primaryColor1.withOpacity(.2),
                          spreadRadius: 2,
                          blurRadius: 5)
                    ]),
                child: widget.type == 0
                    ? ListTile(
                        title: Text("Height"),
                        subtitle: Text("$height CM"),
                        leading: Icon(Icons.height),
                        tileColor: Colors.white,
                        trailing: ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return Form(
                                  key: _heightkey,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  child: AlertDialog(
                                      backgroundColor: TColor.white,
                                      title: const Text('Edit Height'),
                                      content: RoundTextField(
                                        validator: validateHeight,
                                        hintText: "Height (cm)",
                                        controller: _heightController,
                                        keyboardType: const TextInputType
                                            .numberWithOptions(decimal: true),
                                        margin: const EdgeInsets.symmetric(
                                          vertical: 10,
                                        ),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text("Submit"),
                                          style: TextButton.styleFrom(
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .bodyText1,
                                          ),
                                          onPressed: () async {
                                            if (_heightkey.currentState!
                                                .validate()) {
                                              context
                                                  .read<PlayerProvider>()
                                                  .selectUser(Player.fromJson(
                                                      widget.user!));
                                              context
                                                  .read<PlayerProvider>()
                                                  .editHeight(
                                                      _heightController.text);
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                      content: Text(
                                                          'Height successfully edited!')));
                                              Navigator.of(context).pop();
                                            }
                                          },
                                        ),
                                        TextButton(
                                          child: Text("Cancel"),
                                          style: TextButton.styleFrom(
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .bodyText1,
                                          ),
                                          onPressed: () async {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ]),
                                );
                              },
                            );
                          },
                          child: const Text("Edit"), // Button text
                        ),
                      )
                    : ListTile(
                        title: Text("Height"),
                        subtitle: Text("$height CM"),
                        leading: Icon(Icons.height),
                        tileColor: Colors.white,
                      ),
              ),
              const SizedBox(height: 20),
              Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(0, 5),
                            color: TColor.primaryColor1.withOpacity(.2),
                            spreadRadius: 2,
                            blurRadius: 5)
                      ]),
                  child: widget.type == 0
                      ? ListTile(
                          title: Text("Belt Color"),
                          subtitle: Text(beltcolor),
                          leading: Icon(Icons.sports_martial_arts),
                          tileColor: Colors.white,
                          trailing: ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return Form(
                                    key: _beltkey,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    child: AlertDialog(
                                        backgroundColor: TColor.white,
                                        title: const Text('Edit Belt Color'),
                                        content: Container(
                                          margin: const EdgeInsets.symmetric(
                                            vertical: 10,
                                          ),
                                          decoration: BoxDecoration(
                                            color: TColor.lightGray,
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: Row(
                                            children: [
                                              const SizedBox(
                                                width: 15,
                                              ),
                                              Expanded(
                                                child: TextFormField(
                                                  controller:
                                                      _beltcolorController,
                                                  decoration: InputDecoration(
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 4),
                                                    enabledBorder:
                                                        InputBorder.none,
                                                    focusedBorder:
                                                        InputBorder.none,
                                                    hintStyle: TextStyle(
                                                      color:
                                                          _selectedBeltColor !=
                                                                  null
                                                              ? TColor.black
                                                              : TColor.gray,
                                                      fontSize: 16,
                                                    ),
                                                    hintText: beltcolor,
                                                  ),
                                                  readOnly:
                                                      true, // Make the text field read-only
                                                  onTap: () {
                                                    Future.delayed(
                                                        Duration.zero, () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) =>
                                                            AlertDialog(
                                                          title: Text(
                                                              'Select Belt Color'),
                                                          content:
                                                              SingleChildScrollView(
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                ...[
                                                                  "White Belt",
                                                                  "Yellow Belt",
                                                                  "Orange Belt",
                                                                  "Green Belt",
                                                                  "Blue Belt",
                                                                  "Purple Belt",
                                                                  "Brown Belt",
                                                                  "Black Belt"
                                                                ].map(
                                                                  (name) =>
                                                                      ListTile(
                                                                    title: Text(
                                                                        name),
                                                                    onTap: () {
                                                                      setState(
                                                                          () {
                                                                        _selectedBeltColor =
                                                                            name;
                                                                        _beltcolorController.text =
                                                                            name; // Update the text field value
                                                                      });
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop(); // Close the dialog
                                                                    },
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    });
                                                  },
                                                  validator:
                                                      validateDropdownBelt,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text("Submit"),
                                            style: TextButton.styleFrom(
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1,
                                            ),
                                            onPressed: () async {
                                              if (_beltkey.currentState!
                                                  .validate()) {
                                                context
                                                    .read<PlayerProvider>()
                                                    .selectUser(Player.fromJson(
                                                        widget.user!));
                                                context
                                                    .read<PlayerProvider>()
                                                    .editBeltcolor(
                                                        _beltcolorController
                                                            .text);
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(const SnackBar(
                                                        content: Text(
                                                            'Belt color successfully edited!')));
                                                Navigator.of(context).pop();
                                              }
                                            },
                                          ),
                                          TextButton(
                                            child: Text("Cancel"),
                                            style: TextButton.styleFrom(
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1,
                                            ),
                                            onPressed: () async {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ]),
                                  );
                                },
                              );
                            },
                            child: const Text("Edit"), // Button text
                          ),
                        )
                      : ListTile(
                          title: Text("Belt Color"),
                          subtitle: Text(beltcolor),
                          leading: Icon(Icons.sports_martial_arts),
                          tileColor: Colors.white)),
              const SizedBox(
                height: 20,
              ),
              Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(0, 5),
                            color: TColor.primaryColor1.withOpacity(.2),
                            spreadRadius: 2,
                            blurRadius: 5)
                      ]),
                  child: widget.type == 0
                      ? ListTile(
                          title: Text("Weight"),
                          subtitle: Text("$weight KG"),
                          leading: Icon(Icons.monitor_weight),
                          tileColor: Colors.white,
                          trailing: ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return Form(
                                    key: _weightkey,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    child: AlertDialog(
                                        backgroundColor: TColor.white,
                                        title: const Text('Edit Weight'),
                                        content: RoundTextField(
                                          validator: validateWeight,
                                          hintText: "Weight (kg)",
                                          controller: _weightController,
                                          keyboardType: const TextInputType
                                              .numberWithOptions(decimal: true),
                                          margin: const EdgeInsets.symmetric(
                                            vertical: 10,
                                          ),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text("Submit"),
                                            style: TextButton.styleFrom(
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1,
                                            ),
                                            onPressed: () async {
                                              if (_weightkey.currentState!
                                                  .validate()) {
                                                context
                                                    .read<PlayerProvider>()
                                                    .selectUser(Player.fromJson(
                                                        widget.user!));
                                                context
                                                    .read<PlayerProvider>()
                                                    .editWeight(
                                                        _weightController.text);
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(const SnackBar(
                                                        content: Text(
                                                            'Weight successfully edited!')));
                                                Navigator.of(context).pop();
                                              }
                                            },
                                          ),
                                          TextButton(
                                            child: Text("Cancel"),
                                            style: TextButton.styleFrom(
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1,
                                            ),
                                            onPressed: () async {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ]),
                                  );
                                },
                              );
                            },
                            child: const Text("Edit"), // Button text
                          ),
                        )
                      : ListTile(
                          title: Text("Weight"),
                          subtitle: Text("$weight KG"),
                          leading: Icon(Icons.monitor_weight),
                          tileColor: Colors.white)),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? validateHeight(String? heightString) {
    if (heightString == null || heightString.trim().isEmpty) {
      return 'Height is required. (e.g 163)';
    }

    return null;
  }

  String? validateWeight(String? weightString) {
    if (weightString == null || weightString.trim().isEmpty) {
      return 'Weight is required. (e.g 55)';
    }

    return null;
  }

  String? validatePhoneContact(String? phoneNumber) {
    if (phoneNumber == null || phoneNumber.trim().isEmpty) {
      return 'Phone number is required.';
    }

    RegExp phoneRegex = RegExp(r'^(09|\+639)\d{9}$');
    if (!phoneRegex.hasMatch(phoneNumber)) {
      return 'Please use 0XXXXXXXXX.';
    }

    return null;
  }

  String? validateDropdownBelt(String? selectedItem) {
    if (selectedItem == null || selectedItem.isEmpty) {
      return 'Please select an item.';
    }
    return null;
  }
}
