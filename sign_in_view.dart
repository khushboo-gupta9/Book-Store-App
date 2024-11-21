import 'package:bookapp/common/api.dart';
import 'package:flutter/material.dart';
import 'package:bookapp/common/color_extenstion.dart';
import 'package:bookapp/common/validator_form.dart';
import 'package:bookapp/view/login/forgot_password_view.dart';
import 'package:bookapp/view/main_tab/main_tab_view.dart';
import '../../common_widget/round_button.dart';
import '../../common_widget/round_textfield.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  final ValidatorController validatorController = ValidatorController();
  final TextEditingController txtEmail = TextEditingController();
  final TextEditingController txtPassword = TextEditingController();

  // Error messages
  String? emailError;
  String? passwordError;
  bool isStay = false;
  bool _isPasswordVisible = false;

  // This function now ensures fields are not empty or invalid
  void _signIn() {
    setState(() {
      emailError = validatorController.validateEmail(txtEmail.text);
      passwordError = validatorController.validatePassword(txtPassword.text);
    });

    // Prevent sign-in if there are validation errors
    if (emailError == null && passwordError == null) {
      _performSignIn();
    }
  }

  // Function to handle the actual sign-in process
  Future<void> _performSignIn() async {
    final response = await ApiService.login(
      email: txtEmail.text,
      password: txtPassword.text,
    );
    if (response['status'] == 'success') {
      print("Login successfully!: ${response['token']}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Login successfully!'),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MainTabView(),
        ),
      );
    } else {
      // Handle login error
      print("Login failed: ${response['message']}");
      // Show error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response['message']),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: TColor.primary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Sign In",
                style: TextStyle(
                  color: TColor.text,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 15),

              // Email Field with Error
              RoundTextField(
                suffixIcon: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.email, color: TColor.text),
                ),
                controller: txtEmail,
                hintText: "Email Address",
                onChanged: (value) {},
              ),
              if (emailError != null)
                Text(
                  emailError!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              const SizedBox(height: 15),

              // Password Field with Error
              RoundTextField(
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: TColor.text,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
                controller: txtPassword,
                hintText: "Password",
                obscureText: !_isPasswordVisible,
                onChanged: (value) {},
              ),
              if (passwordError != null)
                Text(
                  passwordError!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              const SizedBox(height: 15),

              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        isStay = !isStay;
                      });
                    },
                    icon: Icon(
                      isStay ? Icons.check_box : Icons.check_box_outline_blank,
                      color: isStay
                          ? TColor.primary
                          : TColor.subTitle.withOpacity(0.3),
                    ),
                  ),
                  Text(
                    "Stay Logged In",
                    style: TextStyle(
                      color: TColor.subTitle.withOpacity(0.5),
                      fontSize: 15,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ForgotPasswordView(),
                        ),
                      );
                    },
                    child: Text(
                      "Forgot Your Password?",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: TColor.subTitle.withOpacity(0.5),
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              RoundLineButton(
                title: "Sign In",
                onPressed: _signIn,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
 