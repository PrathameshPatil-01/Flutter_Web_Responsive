import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_auth/blocs/sign_up_bloc/sign_up_bloc.dart';
import 'package:web_auth/components/strings.dart';
import 'package:web_auth/components/textfield.dart';
import 'package:web_auth/data/user_repository/models/my_user.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = '/SignUpScreen';

  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool obscurePassword = true;
  IconData iconPassword = CupertinoIcons.eye_slash_fill;
  bool signUpRequired = false;

  bool showPasswordIndicators = false;
  bool containsUpperCase = false;
  bool containsLowerCase = false;
  bool containsNumber = false;
  bool containsSpecialChar = false;
  bool contains8Length = false;

  String? _selectedCountry;
  String? _selectedState;
  String? _selectedCity;
  String? _countryValidationError;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpBloc, SignUpState>(listener: (context, state) {
      if (state is SignUpSuccess) {
        setState(() {
          signUpRequired = false;
        });
      } else if (state is SignUpProcess) {
        setState(() {
          signUpRequired = true;
        });
      } else if (state is SignUpFailure) {
        return;
      }
    }, child: Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Center(
            child: SingleChildScrollView(
              child: LayoutBuilder(builder: (context, constraints) {
                const maxWidth = 600.0;
                const margin = 20.0;
                final width = constraints.maxWidth > maxWidth
                    ? maxWidth
                    : constraints.maxWidth - (margin * 2);

                return Container(
                  margin: const EdgeInsets.all(margin),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.deepPurple.shade50,
                        Colors.deepPurple.shade200,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset:
                            const Offset(0, 3), // changes the shadow direction
                      ),
                    ],
                  ),
                  child: ClipPath(
                    clipper: ShapeBorderClipper(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(margin),
                      constraints: BoxConstraints(maxWidth: width),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Text(
                                  'SIGN UP',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const Spacer(),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const Text(
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w300,
                                        ),
                                        "Already have an account ?"),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pushReplacementNamed(
                                            context, '/LoginScreen');
                                      },
                                      child: const Text(
                                        'Login',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            MyTextField(
                                controller: _usernameController,
                                hintText: 'Username',
                                obscureText: false,
                                keyboardType: TextInputType.name,
                                prefixIcon:
                                    const Icon(CupertinoIcons.person_fill),
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return 'Please fill in this field';
                                  } else if (val.length > 30) {
                                    return 'Name too long';
                                  }
                                  return null;
                                }),
                            const SizedBox(height: 10.0),
                            Row(
                              children: [
                                Expanded(
                                  child: MyTextField(
                                    controller: _firstNameController,
                                    hintText: "First Name",
                                    obscureText: false,
                                    keyboardType: TextInputType.name,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your first name';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(width: 8.0),
                                Expanded(
                                  child: MyTextField(
                                    controller: _lastNameController,
                                    hintText: "Last Name",
                                    obscureText: false,
                                    keyboardType: TextInputType.name,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your last name';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10.0),
                            MyTextField(
                                controller: _emailController,
                                hintText: 'Email',
                                obscureText: false,
                                keyboardType: TextInputType.emailAddress,
                                prefixIcon:
                                    const Icon(CupertinoIcons.mail_solid),
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return 'Please fill in this field';
                                  } else if (!emailRexExp.hasMatch(val)) {
                                    return 'Please enter a valid email';
                                  }
                                  return null;
                                }),
                            const SizedBox(height: 10.0),
                            Row(
                              children: [
                                Expanded(
                                  child: MyTextField(
                                    controller: _passwordController,
                                    hintText: 'Password',
                                    obscureText: obscurePassword,
                                    keyboardType: TextInputType.visiblePassword,
                                    prefixIcon:
                                        const Icon(CupertinoIcons.lock_fill),
                                    onTap: () {
                                      setState(() {
                                        showPasswordIndicators = true;
                                      });
                                    },
                                    onTapOutSide: (p0) {
                                      setState(() {
                                        showPasswordIndicators = false;
                                      });
                                    },
                                    onChanged: (val) {
                                      if (val!.contains(RegExp(r'[A-Z]'))) {
                                        setState(() {
                                          containsUpperCase = true;
                                        });
                                      } else {
                                        setState(() {
                                          containsUpperCase = false;
                                        });
                                      }
                                      if (val.contains(RegExp(r'[a-z]'))) {
                                        setState(() {
                                          containsLowerCase = true;
                                        });
                                      } else {
                                        setState(() {
                                          containsLowerCase = false;
                                        });
                                      }
                                      if (val.contains(RegExp(r'[0-9]'))) {
                                        setState(() {
                                          containsNumber = true;
                                        });
                                      } else {
                                        setState(() {
                                          containsNumber = false;
                                        });
                                      }
                                      if (val.contains(specialCharRexExp)) {
                                        setState(() {
                                          containsSpecialChar = true;
                                        });
                                      } else {
                                        setState(() {
                                          containsSpecialChar = false;
                                        });
                                      }
                                      if (val.length >= 8) {
                                        setState(() {
                                          contains8Length = true;
                                        });
                                      } else {
                                        setState(() {
                                          contains8Length = false;
                                        });
                                      }
                                      return null;
                                    },
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          obscurePassword = !obscurePassword;
                                          if (obscurePassword) {
                                            iconPassword =
                                                CupertinoIcons.eye_slash_fill;
                                          } else {
                                            iconPassword =
                                                CupertinoIcons.eye_fill;
                                          }
                                        });
                                      },
                                      icon: Icon(iconPassword),
                                    ),
                                    validator: (val) {
                                      if (val!.isEmpty) {
                                        return 'Please fill in this field';
                                      } else if (!passwordRexExp
                                          .hasMatch(val)) {
                                        return 'Please enter a valid password';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(width: 8.0),
                                Expanded(
                                  child: MyTextField(
                                    controller: _confirmPasswordController,
                                    hintText: 'Confirm Password',
                                    obscureText: obscurePassword,
                                    keyboardType: TextInputType.visiblePassword,
                                    validator: (val) {
                                      if (val!.isEmpty) {
                                        return 'Please fill in this field';
                                      } else if (!passwordRexExp
                                          .hasMatch(val)) {
                                        return 'Please enter a valid password';
                                      }
                                      return null;
                                    },
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          obscurePassword = !obscurePassword;
                                          if (obscurePassword) {
                                            iconPassword =
                                                CupertinoIcons.eye_fill;
                                          } else {
                                            iconPassword =
                                                CupertinoIcons.eye_slash_fill;
                                          }
                                        });
                                      },
                                      icon: Icon(iconPassword),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            if (showPasswordIndicators)
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          containsUpperCase
                                              ? "✅   Uppercase  added"
                                              : "⛔   1  uppercase  required ",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: containsUpperCase
                                                ? Colors.green.shade700
                                                : Colors.grey.shade700,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          containsLowerCase
                                              ? "✅   Lowercase  added"
                                              : "⛔   1  lowercase  required ",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: containsLowerCase
                                                ? Colors.green.shade700
                                                : Colors.grey.shade700,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          containsNumber
                                              ? "✅   Number  added"
                                              : "⛔   1  number  required ",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: containsNumber
                                                ? Colors.green.shade700
                                                : Colors.grey.shade700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          contains8Length
                                              ? "✅   8  characters  added"
                                              : "⛔   8  characters  required ",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: contains8Length
                                                ? Colors.green.shade700
                                                : Colors.grey.shade700,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          containsSpecialChar
                                              ? "✅   Special  character  added"
                                              : "⛔   1  special  character  required ",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: containsSpecialChar
                                                ? Colors.green.shade700
                                                : Colors.grey.shade700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            const SizedBox(height: 10.0),
                            CSCPicker(
                              onCountryChanged: (value) {
                                _selectedCountry = value;
                                _countryValidationError = null;
                              },
                              onStateChanged: (value) {
                                _selectedState = value;
                              },
                              onCityChanged: (value) {
                                _selectedCity = value;
                              },
                            ),
                            const SizedBox(height: 10.0),
                            if (_countryValidationError != null)
                              Text(
                                _countryValidationError!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.red),
                              ),
                            const SizedBox(height: 20.0),
                            !signUpRequired
                                ? ElevatedButton(
                                    onPressed: () {
                                      if (_formKey.currentState!.validate() &&
                                              _selectedCountry == null ||
                                          _selectedCountry!.isEmpty) {
                                        setState(() {
                                          _countryValidationError =
                                              'Please select a country.';
                                        });
                                      } else if (_formKey.currentState!
                                          .validate()) {
                                        setState(() {
                                          _countryValidationError = null;
                                        });
                                        MyUser myUser = MyUser.empty;
                                        myUser = myUser.copyWith(
                                            email: _emailController.text,
                                            userName: _usernameController.text,
                                            firstName:
                                                _firstNameController.text,
                                            lastName: _lastNameController.text,
                                            country: _selectedCountry,
                                            state: _selectedState,
                                            city: _selectedCity);

                                        setState(() {
                                          context.read<SignUpBloc>().add(
                                              SignUpRequired(myUser,
                                                  _passwordController.text));
                                        });
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      elevation: 3.0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(60),
                                        side: const BorderSide(
                                            color:
                                                Colors.grey), // Optional border
                                      ),
                                    ),
                                    child: const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: Text(
                                        'SIGN UP',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ))
                                : const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Color.fromARGB(255, 0, 0, 0)),
                                    ),
                                  ),
                            const SizedBox(height: 20.0),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Divider(
                                      color: Colors.black,
                                      thickness: 1,
                                      height: 20,
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Text(
                                      'OR',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Divider(
                                      color: Colors.black,
                                      thickness: 1,
                                      height: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // Implement Google Sign-In functionality here
                                    },
                                    style: ElevatedButton.styleFrom(
                                      elevation: 3.0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(60),
                                        side: const BorderSide(
                                            color:
                                                Colors.grey), // Optional border
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Flexible(
                                            child: Image.network(
                                              'https://cdn1.iconfinder.com/data/icons/google-s-logo/150/Google_Icons-09-512.png', // Replace with your Google logo URL
                                              height: 25,
                                              width: 25,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          const Flexible(
                                            child: Text(
                                              'SIGN IN WITH GOOGLE',
                                              style: TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    ));
  }
}
