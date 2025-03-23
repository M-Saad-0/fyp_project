import 'package:backend_services_repository/backend_service_repositoy.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:next_gen_ai_healthcare/blocs/sign_up/sign_up_bloc.dart';
import 'package:next_gen_ai_healthcare/widgets/my_text_field.dart';
import 'package:next_gen_ai_healthcare/widgets/show_toast.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  IconData iconPassword = CupertinoIcons.eye_fill;
  bool obscurePassword = true;
  bool signUpRequired = false;

  bool containsUpperCase = false;
  bool containsLowerCase = false;
  bool containsNumber = false;
  bool containsSpecialChar = false;
  bool contains8Length = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignUpBloc, SignUpState>(
      listener: (context, state) {
        if (state is SignUpSuccess) {
          setState(() {
            signUpRequired = false;
          });
        } else if (state is SignUpLoading) {
          setState(() {
            signUpRequired = true;
          });
        } else if (state is SignUpError) {
          return;
        }
      },
      builder: (context, state) {
        switch (state) {
          case SignUpError():
            {
              signUpRequired = false;
              showToastMessage(state.error);
              break;
            }
          default:
            // debugPrint("Normal Life");
        }
        return SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Center(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: MyTextField(
                        controller: emailController,
                        hintText: 'Email',
                        obscureText: false,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: const Icon(CupertinoIcons.mail_solid),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Please fill in this field';
                          } else if (!RegExp(r'^[\w-\.]+@([\w-]+.)+[\w-]{2,4}$')
                              .hasMatch(val)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        }),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: MyTextField(
                        controller: passwordController,
                        hintText: 'Password',
                        obscureText: obscurePassword,
                        keyboardType: TextInputType.visiblePassword,
                        prefixIcon: const Icon(CupertinoIcons.lock_fill),
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
                          if (val.contains(RegExp(
                              r'^(?=.*?[!@#$&*~`)\%\-(_+=;:,.<>/?"[{\]}\|^])'))) {
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
                                iconPassword = CupertinoIcons.eye_fill;
                              } else {
                                iconPassword = CupertinoIcons.eye_slash_fill;
                              }
                            });
                          },
                          icon: Icon(iconPassword),
                        ),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Please fill in this field';
                          } else if (!RegExp(
                                  r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~`)\%\-(_+=;:,.<>/?"[{\]}\|^]).{8,}$')
                              .hasMatch(val)) {
                            return 'Please enter a valid password';
                          }
                          return null;
                        }),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "⚈  1 uppercase",
                            style: TextStyle(
                                color: containsUpperCase
                                    ? Theme.of(context).primaryColor
                                    : Theme.of(context)
                                        .colorScheme
                                        .onSurface),
                          ),
                          Text(
                            "⚈  1 lowercase",
                            style: TextStyle(
                                color: containsLowerCase
                                    ? Theme.of(context).primaryColor
                                    : Theme.of(context)
                                        .colorScheme
                                        .onSurface),
                          ),
                          Text(
                            "⚈  1 number",
                            style: TextStyle(
                                color: containsNumber
                                    ? Theme.of(context).primaryColor
                                    : Theme.of(context)
                                        .colorScheme
                                        .onSurface),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "⚈  1 special character",
                            style: TextStyle(
                                color: containsSpecialChar
                                    ? Theme.of(context).primaryColor
                                    : Theme.of(context)
                                        .colorScheme
                                        .onSurface),
                          ),
                          Text(
                            "⚈  8 minimum character",
                            style: TextStyle(
                                color: contains8Length
                                    ? Theme.of(context).primaryColor
                                    : Theme.of(context)
                                        .colorScheme
                                        .onSurface),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: MyTextField(
                        controller: nameController,
                        hintText: 'Name',
                        obscureText: false,
                        keyboardType: TextInputType.name,
                        prefixIcon: const Icon(CupertinoIcons.person_fill),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Please fill in this field';
                          } else if (val.length > 30) {
                            return 'Name too long';
                          }
                          return null;
                        }),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  !signUpRequired
                      ? SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  User myUser = User(
                                      userId: "",
                                      userName: nameController.text,
                                      email: emailController.text);

                                  setState(() {
                                    context.read<SignUpBloc>().add(
                                        SignUpRequired(
                                            user: myUser,
                                            password: passwordController.text));
                                  });
                                }
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 25, vertical: 5),
                                child: Text(
                                  'Sign Up',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                              )),
                        )
                      : const CircularProgressIndicator()
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
