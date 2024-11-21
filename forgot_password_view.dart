import 'package:bookapp/common/api.dart';
import 'package:bookapp/common/color_extenstion.dart';
import 'package:bookapp/common/validator_form.dart';
import 'package:bookapp/view/account/email_code_verifi.dart';
import 'package:flutter/material.dart';

import '../../common_widget/round_button.dart';
import '../../common_widget/round_textfield.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final TextEditingController txtEmail = TextEditingController();
  final ValidatorController validatorController = ValidatorController();

  String? emailError;

  // Validate and initiate forgot password process
  void _forgetPassword() {
    setState(() {
      emailError = validatorController.validateEmail(txtEmail.text);
    });

    if (emailError == null) {
      _performSignForgotPass();
    }
  }

  // Perform forgot password action
  Future<void> _performSignForgotPass() async {
    try {
      final response = await ApiService.forgotPassword(
        email: txtEmail.text,
      );

      // Debug: Print the server response
      print("Server Response: $response");

      // Check if response indicates success
      if (response['status'] == 'success') {
        print("Email verification code sent successfully!: ${response['token']}");

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email verification code sent successfully!'),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(top: 20, left: 20, right: 20),
            duration: Duration(seconds: 2),
          ),
        );

        // Short delay before navigating
        await Future.delayed(const Duration(seconds: 2));

        // Navigate to EmailVerification page
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => EmailVerification(email: txtEmail.text),
          ),
        );
      } else {
        // Handle failure case
        print("Code send failed: ${response['message']}");

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message'] ?? 'Failed to send code'),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
          ),
        );
      }
    } catch (e) {
      // Handle unexpected errors
      print("Error: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An unexpected error occurred. Please try again.'),
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
                "Forgot Password",
                style: TextStyle(
                  color: TColor.text,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 15),

              // Email Field with Error Message
              RoundTextField(
                controller: txtEmail,
                hintText: "Email Address",
                suffixIcon: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.email),
                ),
                onChanged: (value) {},
              ),
              if (emailError != null)
                Text(
                  emailError!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),

              const SizedBox(height: 25),

              // Send Button
              RoundLineButton(
                title: "Send",
                onPressed: _forgetPassword,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
