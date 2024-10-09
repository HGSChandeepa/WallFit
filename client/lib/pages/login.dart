import 'package:client/pages/home_page.dart';
import 'package:client/pages/register.dart';
import 'package:client/services/auth.dart';
import 'package:client/widgets/reusable/custum_button.dart';
import 'package:client/widgets/reusable/custum_input.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService authService = AuthService();

  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  void login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      try {
        final result = await authService.login(
          password: passwordController.text,
          email: emailController.text,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Login failed! Check credentials."),
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SafeArea(
            child: Center(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
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

                    // Refactor input fields using InputField widget
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

                    // Use the LoginButton widget
                    CustomButton(
                      isLoading: isLoading,
                      onPressed: login,
                      labelText: "Login",
                    ),

                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterPage()),
                        );
                      },
                      child: const Text(
                        "Don't have an account? Register",
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
