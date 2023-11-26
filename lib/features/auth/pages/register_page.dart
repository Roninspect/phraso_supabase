import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/colors/colors.dart';
import '../../../router/router.dart';
import '../controller/auth_controller.dart';
import '../widgets/google_sign_in_button.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final GlobalKey<FormState> _registerKey = GlobalKey<FormState>();
  bool _passwordVisible = true;

  var name;
  var email;
  var pass;

  void validRegister() async {
    if (_registerKey.currentState!.validate()) {
      _registerKey.currentState!.save();
      await ref.watch(authControllerProvider.notifier).registerUser(
          name: name, email: email, password: pass, contexts: context);

      await Future.delayed(const Duration(seconds: 5));
    }
    @override
    void initState() {
      _passwordVisible;
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isLoading = ref.watch(authControllerProvider);
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(),
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0).copyWith(top: 20, left: 20),
                child: const Text('Register',
                    style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 40),
              Form(
                  key: _registerKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: TextFormField(
                            decoration: const InputDecoration(
                                hintText: "Email",
                                border: OutlineInputBorder()),
                            onSaved: (emailVal) {
                              email = emailVal;
                            },
                            validator: (emailVal) {
                              bool result = emailVal!.contains(
                                RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"),
                              );
                              return result ? null : "enter a valid Email";
                            }),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: TextFormField(
                          decoration: const InputDecoration(
                              hintText: " Your Name",
                              border: OutlineInputBorder()),
                          onSaved: (nameVal) {
                            name = nameVal;
                          },
                          validator: (nameVal) {
                            return nameVal!.isNotEmpty
                                ? null
                                : "Please Enter Your Name";
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: TextFormField(
                          obscureText: _passwordVisible,
                          decoration: InputDecoration(
                            hintText: "Password",
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(
                                // Based on passwordVisible state choose the icon
                                _passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                // Update the state i.e. toogle the state of passwordVisible variable
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                            ),
                          ),
                          onSaved: (passVal) {
                            pass = passVal;
                          },
                          validator: (passVal) {
                            return passVal!.length > 6
                                ? null
                                : "Password must be greater than 6";
                          },
                        ),
                      ),
                    ],
                  )),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(250, 60),
                      backgroundColor: darkColor),
                  onPressed: () => validRegister(),
                  child: isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : const Text(
                          "Register",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                ),
              ),
              const SizedBox(height: 30),
              const Center(child: SizedBox(width: 250, child: GoogleButton())),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an Account?"),
                  InkWell(
                    onTap: () {
                      context.goNamed(AppRoutes.login.name);
                    },
                    child: const Text(
                      ' Sign In',
                      style: TextStyle(color: Colors.black),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
