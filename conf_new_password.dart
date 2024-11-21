import 'package:bookapp/common/color_extenstion.dart';
import 'package:bookapp/common/validator_form.dart';
import 'package:bookapp/common_widget/round_button.dart';
import 'package:bookapp/common_widget/round_textfield.dart';
import 'package:bookapp/view/main_tab/main_tab_view.dart';
import 'package:flutter/material.dart';

class ConfNewPassword extends StatefulWidget {
  const ConfNewPassword({super.key});

  @override
  State<ConfNewPassword> createState() => _ConfNewPasswordState();
}

class _ConfNewPasswordState extends State<ConfNewPassword> {
  final TextEditingController txtnewPassword = TextEditingController();
  final TextEditingController txtconfPassword = TextEditingController();
  final ValidatorController validatorController = ValidatorController(); // Instantiate the validator

  // Error messages
  String? newPassError;
  String? confPasswordError;
 // Toggle password visibility
  bool _isPasswordVisible = false;

  void _confPassword() {
    setState(() {
      // Validate and update error messages
      newPassError = validatorController.validateconfPassword(txtnewPassword.text);
      confPasswordError = validatorController.validateconfPassword(txtconfPassword.text);
    });

    if (newPassError == null && confPasswordError == null) {
      // All validations passed, navigate to the main page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const MainTabView(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                "New Password",
                style: TextStyle(
                  color: TColor.text,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 15),

              // New Password Field with Error Message
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
                ),                controller: txtnewPassword,
                hintText: "New Password",
                onChanged: (value) {
                  // Clear error message when input is detected
                  if (newPassError != null) {
                    setState(() {
                      newPassError = null;
                    });
                  }
                },
              ),
              if (newPassError != null)
                Text(
                  newPassError!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              const SizedBox(height: 20),

              // Confirm Password Field with Error Message
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
                controller: txtconfPassword,
                hintText: "Confirm Password",
                onChanged: (value) {
                  // Clear error message when input is detected
                  if (confPasswordError != null) {
                    setState(() {
                      confPasswordError = null;
                    });
                  }
                },
              ),
              if (confPasswordError != null)
                Text(
                  confPasswordError!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              const SizedBox(height: 20),

              // Submit Button
              RoundLineButton(
                title: "Submit",
                onPressed: _confPassword,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
