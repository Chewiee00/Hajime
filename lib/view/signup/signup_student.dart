import 'package:alert_dialog/alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test1/common/color_extension.dart';
import 'package:flutter_test1/common_widgets/round_button.dart';
import 'package:flutter_test1/common_widgets/round_textfield.dart';
import 'package:flutter_test1/provider/auth_provider.dart';
import 'package:flutter_test1/stream.dart';
import 'package:flutter_test1/view/signup/select_user_type_view.dart';
import 'package:provider/provider.dart';

import '../login/login_view.dart';

class SignupStudentView extends StatefulWidget {
  const SignupStudentView({super.key});

  @override
  State<SignupStudentView> createState() => _SignupStudentViewState();
}

class _SignupStudentViewState extends State<SignupStudentView> {
  String? _selectedSex;
  String? _selectedBeltColor;
  String? _selectedBirthDate;
  String? _selectedStartTrainingDate;
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _passwordController;
  late TextEditingController _emailController;
  late TextEditingController _birthDateController;
  late TextEditingController _startTrainingDateController;
  late TextEditingController _sexController;
  late TextEditingController _weightController;
  late TextEditingController _heightController;
  late TextEditingController _beltColorController;
  late TextEditingController _contactNumberController;
  late TextEditingController _classCodeController;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _passwordController = TextEditingController();
    _emailController = TextEditingController();
    _birthDateController = TextEditingController();
    _startTrainingDateController = TextEditingController();
    _sexController = TextEditingController();
    _weightController = TextEditingController();
    _heightController = TextEditingController();
    _contactNumberController = TextEditingController();
    _classCodeController = TextEditingController();
    _beltColorController = TextEditingController();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    _birthDateController.dispose();
    _startTrainingDateController.dispose();
    _sexController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _contactNumberController.dispose();
    _classCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: TColor.white,
      body: Form(
        key: _key,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: [
                  Text("Hello Judoka,",
                      style: TextStyle(color: TColor.gray, fontSize: 20)),
                  Text("Create An Account",
                      style: TextStyle(
                          color: TColor.black,
                          fontSize: 24,
                          fontWeight: FontWeight.w700)),
                  SizedBox(
                    height: media.width * 0.05,
                  ),
                  RoundTextField(
                    hintText: "Email",
                    controller: _emailController,
                    validator: validateEmail,
                    keyboardType: TextInputType.emailAddress,
                    margin: const EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                  ),
                  RoundTextField(
                    hintText: "Password",
                    controller: _passwordController,
                    validator: validatePassword,
                    keyboardType: TextInputType.visiblePassword,
                    margin: const EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    obscureText: true,
                  ),
                  RoundTextField(
                    hintText: "First Name",
                    controller: _firstNameController,
                    validator: validateFirstName,
                    margin: const EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                  ),
                  RoundTextField(
                    hintText: "Last Name",
                    controller: _lastNameController,
                    validator: validateLastName,
                    margin: const EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: TColor.lightGray,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: _sexController,
                            decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 4),
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              hintStyle: TextStyle(
                                color: _selectedSex != null
                                    ? TColor.black
                                    : TColor.gray,
                                fontSize: 16,
                              ),
                              hintText: "Sex",
                            ),
                            readOnly: true, // Make the text field read-only
                            onTap: () {
                              // Show a dialog with the list of options
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Select Sex'),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ...[
                                          "Male",
                                          "Female",
                                        ].map(
                                          (name) => ListTile(
                                            title: Text(name),
                                            onTap: () {
                                              setState(() {
                                                _selectedSex = name;
                                                _sexController.text =
                                                    name; // Update the text field value
                                              });
                                              Navigator.of(context)
                                                  .pop(); // Close the dialog
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            validator: validateDropdownSex,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _selectBirthDate(context);
                    },
                    child: AbsorbPointer(
                      child: RoundTextField(
                        validator: validateBirthDate,
                        controller: _birthDateController,
                        hintText: _selectedBirthDate ?? "Date of Birth",
                        margin: const EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                      ),
                    ),
                  ),
                  RoundTextField(
                    hintText: "Weight (kg)",
                    controller: _weightController,
                    validator: validateWeight,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    margin: const EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                  ),
                  RoundTextField(
                    validator: validateHeight,
                    hintText: "Height (cm)",
                    controller: _heightController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    margin: const EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: TColor.lightGray,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: _beltColorController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: 4),
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              hintStyle: TextStyle(
                                color: _selectedBeltColor != null
                                    ? TColor.black
                                    : TColor.gray,
                                fontSize: 16,
                              ),
                              hintText: "Belt Color",
                            ),
                            readOnly: true, // Make the text field read-only
                            onTap: () {
                              // Show a dialog with the list of options
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Select Belt Color'),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
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
                                          (name) => ListTile(
                                            title: Text(name),
                                            onTap: () {
                                              setState(() {
                                                _selectedBeltColor = name;
                                                _beltColorController.text =
                                                    name; // Update the text field value
                                              });
                                              Navigator.of(context)
                                                  .pop(); // Close the dialog
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            validator: validateDropdownBelt,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _selectStartTrainingDate(context);
                    },
                    child: AbsorbPointer(
                      child: RoundTextField(
                        validator: validateTrainingDate,
                        controller: _startTrainingDateController,
                        hintText: _selectedStartTrainingDate ??
                            "Start of Training Date",
                        margin: const EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                      ),
                    ),
                  ),
                  RoundTextField(
                    hintText: "Contact Number",
                    controller: _contactNumberController,
                    keyboardType: TextInputType.phone,
                    validator: validatePhoneContact,
                    margin: const EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                  ),
                  // RoundTextField(
                  //   controller: _classCodeController,
                  //   hintText: "Class Code",
                  //   validator: validateClassCode,
                  //   margin: const EdgeInsets.symmetric(
                  //     vertical: 10,
                  //   ),
                  // ),
                  SizedBox(
                    height: media.width * 0.1,
                  ),
                  RoundButton(
                      title: "Finish",
                      type: RoundButtonType.bgGradient,
                      onPressed: () async {
                        if (_key.currentState!.validate()) {
                          _key.currentState!.save();

                          final authProvider =
                              context.read<AuthenticationProvider>();
                          final email = _emailController.text.trim();
                          final password = _passwordController.text.trim();
                          final firstname = _firstNameController.text.trim();
                          final lastname = _lastNameController.text.trim();

                          Map<String, dynamic> newPlayer = {
                            "displayname": "$firstname $lastname",
                            "sex": _sexController.text,
                            "birthdate": _birthDateController.text,
                            "trainingdateStart":
                                _startTrainingDateController.text,
                            "beltcolor": _beltColorController.text,
                            "teamname": null,
                            "teamid": null,
                            "contactnumber": _contactNumberController.text,
                            "height": _heightController.text,
                            "weight": _weightController.text,
                          };

                          await authProvider
                              .signUp(email, password, 1, newPlayer)
                              .then((value) => {
                                    if (value ==
                                        "The account already exists for that email.")
                                      {alert(context, title: Text(value))}
                                    else
                                      {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            // Jump to the Login page
                                            builder: (context) =>
                                                const StreamTabView(),
                                          ),
                                        )
                                      }
                                  });
                        }
                      }),
                  SizedBox(
                    height: media.width * 0.1,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          width: double.maxFinite,
                          height: 1,
                          color: TColor.gray.withOpacity(0.5),
                        ),
                      ),
                      Text(
                        "  Or  ",
                        style: TextStyle(color: TColor.black, fontSize: 12),
                      ),
                      Expanded(
                        child: Container(
                          width: double.maxFinite,
                          height: 1,
                          color: TColor.gray.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            // Jump to the Login page
                            builder: (context) => const LoginView(),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Already have an account? ",
                            style: TextStyle(
                              color: TColor.black,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            "Login",
                            style: TextStyle(
                              color: TColor.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectBirthDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        _selectedBirthDate = picked.toString().split(' ')[0];
        _birthDateController.text = _selectedBirthDate!;
      });
    }
  }

  Future<void> _selectStartTrainingDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        _selectedStartTrainingDate = picked.toString().split(' ')[0];
        _startTrainingDateController.text = _selectedStartTrainingDate!;
      });
    }
  }
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

String? validateBirthDate(String? dateString) {
  if (dateString == null || dateString.trim().isEmpty) {
    return 'Date is required.';
  }
  return null;
}

String? validateTrainingDate(String? dateString) {
  if (dateString == null || dateString.trim().isEmpty) {
    return 'Date is required.';
  }
  return null;
}

String? validateDropdownSex(String? selectedItem) {
  if (selectedItem == null || selectedItem.isEmpty) {
    return 'Please select an item.';
  }
  return null;
}

String? validateDropdownBelt(String? selectedItem) {
  if (selectedItem == null || selectedItem.isEmpty) {
    return 'Please select an item.';
  }
  return null;
}

String? validateClassCode(String? heightString) {
  if (heightString == null || heightString.trim().isEmpty) {
    return 'Class code is required.';
  }

  return null;
}

String? validatePhoneContact(String? phoneNumber) {
  if (phoneNumber == null || phoneNumber.trim().isEmpty) {
    return 'Phone number is required.';
  }

  RegExp phoneRegex = RegExp(r'^(09|\+639)\d{9}$');
  if (!phoneRegex.hasMatch(phoneNumber)) {
    return 'Invalid phone number format. Please use 0XXXXXXXXX.';
  }

  return null;
}

String? validateFirstName(String? formfirstname) {
  if (formfirstname == null || formfirstname.trim().isEmpty) {
    return 'First Name is required.';
  }
  return null;
}

String? validateLastName(String? formlastname) {
  if (formlastname == null || formlastname.trim().isEmpty) {
    return 'Last Name is required.';
  }

  return null;
}

String? validateEmail(String? formEmail) {
  if (formEmail == null || formEmail.isEmpty) {
    return 'E-mail address is required.';
  }
  String pattern = r'\w+@\w+\.\w+';
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(formEmail)) return 'Invalid E-mail Address format.';
  return null;
}

String? validatePassword(String? formpassword) {
  if (formpassword == null || formpassword.isEmpty) {
    return 'Password is required.';
  }
  String pattern =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$';
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(formpassword)) {
    return '''
      Password must be at least 6 characters,
      include an uppercase letter, number and symbol.
      ''';
  }

  return null;
}
