import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/login_bloc/login_bloc.dart';
import '../../components/strings.dart';
import '../../components/textfield.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/LoginScreen';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _errorMsg;
  bool obscurePassword = true;
  IconData iconPassword = CupertinoIcons.eye_slash_fill;
  bool loginRequired = false;

  bool showPasswordIndicators = false;
  bool containsUpperCase = false;
  bool containsLowerCase = false;
  bool containsNumber = false;
  bool containsSpecialChar = false;
  bool contains8Length = false;


  @override
  void initState() {
    super.initState();
    // Pre-fill the email and password
    _emailController.text = "user@example.com"; // Pre-filled email
    _passwordController.text = "Password@123";    // Pre-filled password
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(listener: (context, state) {
      if (state is LoginSuccess) {
        setState(() {
          loginRequired = false;
        });
      } else if (state is LoginProcess) {
        setState(() {
          loginRequired = true;
        });
      } else if (state is LoginFailure) {
        setState(() {
          loginRequired = false;
          _errorMsg = 'Invalid email or password';
        });
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
                  constraints: BoxConstraints(maxWidth: width),
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
                      child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Text(
                                    'LOGIN',
                                    textAlign: TextAlign.start,
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
                                          "Don't have an account  ?"),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pushReplacementNamed(
                                              context, '/SignUpScreen');
                                        },
                                        child: const Text(
                                          'Sign Up',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              const SizedBox(height: 20),
                              MyTextField(
                                  controller: _emailController,
                                  hintText: 'Email',
                                  obscureText: false,
                                  keyboardType: TextInputType.emailAddress,
                                  prefixIcon:
                                      const Icon(CupertinoIcons.mail_solid),
                                  errorMsg: _errorMsg,
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return 'Please fill in this field';
                                    } else if (!emailRexExp.hasMatch(val)) {
                                      return 'Please enter a valid email';
                                    }
                                    return null;
                                  }),
                              const SizedBox(height: 10),
                              MyTextField(
                                  controller: _passwordController,
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
                                  hintText: 'Password',
                                  obscureText: obscurePassword,
                                  keyboardType: TextInputType.visiblePassword,
                                  errorMsg: _errorMsg,
                                  prefixIcon:
                                      const Icon(CupertinoIcons.lock_fill),
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
                                    } else if (!passwordRexExp.hasMatch(val)) {
                                      return 'Please enter a valid password';
                                    }
                                    return null;
                                  }),
                              const SizedBox(height: 5),
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
                              const SizedBox(height: 5.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Flexible(
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, '/ForgotPasswordScreen');
                                      },
                                      child: const Text(
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.blue,
                                          ),
                                          'Forgot Password ?'),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12.0),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          context.read<LoginBloc>().add(
                                                LoginRequired(
                                                  _emailController.text,
                                                  _passwordController.text,
                                                ),
                                              );
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        elevation: 3.0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(60),
                                          side: const BorderSide(
                                              color: Colors
                                                  .grey), // Optional border
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            AnimatedSwitcher(
                                              duration: const Duration(
                                                  milliseconds: 200),
                                              child: !loginRequired
                                                  ? const Text(
                                                      'Login',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    )
                                                  : const SizedBox(
                                                      height: 20,
                                                      width: 20,
                                                      child:
                                                          CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                        valueColor:
                                                            AlwaysStoppedAnimation<
                                                                    Color>(
                                                                Color.fromARGB(
                                                                    255,
                                                                    0,
                                                                    0,
                                                                    0)),
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
                              const SizedBox(height: 20.0),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  children: [
                                    const Expanded(
                                      child: Divider(
                                        color: Colors.black,
                                        thickness: 1,
                                        height: 20,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Text(
                                        'Or',
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Divider(
                                        color: Colors.grey.shade700,
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
                                        backgroundColor: Colors.white,
                                        elevation: 3.0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(60),
                                          side: const BorderSide(
                                              color: Colors
                                                  .grey), // Optional border
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
                                                'Continue with google',
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
                          )),
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
