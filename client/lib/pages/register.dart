import 'package:client/services/auth.dart';
import 'package:client/widgets/reusable/custum_button.dart';
import 'package:client/widgets/reusable/custum_input.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService authService = AuthService();

  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  void register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      try {
        final result = await authService.register(
          username: usernameController.text,
          email: emailController.text,
          password: passwordController.text,
        );
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Registration successful. Please log in."),
          backgroundColor: Colors.green,
        ));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Registration failed."),
          backgroundColor: Colors.red,
        ));
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Row(
                      children: [
                        Text(
                          "WallFit",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Make each time a real pleasure with unique wallpapers from QHD Wallpapers collections. Let your device become a source of self-expression, joy, inspiration and more...  ",
                      style: TextStyle(fontSize: 15),
                    ),
                    Image.asset(
                      "assets/images/logo.png",
                      height: MediaQuery.of(context).size.height * 0.3,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                    CustomInputField(
                      controller: usernameController,
                      labelText: "Username",
                      validator: (value) =>
                          value!.isEmpty ? "Please enter your username" : null,
                    ),
                    const SizedBox(height: 20),
                    CustomInputField(
                      controller: emailController,
                      labelText: "Email",
                      validator: (value) =>
                          value!.isEmpty ? "Please enter your email" : null,
                    ),
                    const SizedBox(height: 20),
                    CustomInputField(
                      controller: passwordController,
                      labelText: "Password",
                      obscureText: true,
                      validator: (value) =>
                          value!.isEmpty ? "Please enter your password" : null,
                    ),
                    const SizedBox(height: 20),
                    CustomButton(
                      isLoading: isLoading,
                      onPressed: register,
                      labelText: "Register",
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Already have an account? Login",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
