import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:web_auth/components/strings.dart';
import 'package:web_auth/components/textfield.dart';

class ForgotPasswordScreen extends StatelessWidget {
  static const routeName = '/ForgotPasswordScreen';

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Forgot Password')),
      body: Center(
        child: SingleChildScrollView(
          child: LayoutBuilder(builder: (context, constraints) {
            const maxWidth = 500.0;
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
                    Colors.deepPurple.shade100,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3), // changes the shadow direction
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
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'RESET PASSWORD',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16.0),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Forgot your password? Reset it securely through your email.',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24.0),
                        MyTextField(
                            controller: _emailController,
                            hintText: 'Email',
                            obscureText: false,
                            keyboardType: TextInputType.emailAddress,
                            prefixIcon: const Icon(CupertinoIcons.mail_solid),
                            validator: (val) {
                              if (val!.isEmpty) {
                                return 'Please fill in this field';
                              } else if (!emailRexExp.hasMatch(val)) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            }),
                        const SizedBox(height: 24.0),
                        ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {}
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(60),
                              ),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                  'Submit Your e-mail'),
                            )),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
