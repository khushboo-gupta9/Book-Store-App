import 'package:bookapp/common/api.dart';
import 'package:bookapp/common/validator_form.dart';
import 'package:bookapp/view/login/help_us_view.dart';
import 'package:flutter/material.dart';
import '../../common/color_extenstion.dart';
import '../../common_widget/round_button.dart';
import '../../common_widget/round_textfield.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final ValidatorController validatorController = ValidatorController();
  final TextEditingController txtUserName = TextEditingController();
  final TextEditingController txtEmail = TextEditingController();
  final TextEditingController txtMobile = TextEditingController();
  final TextEditingController txtPassword = TextEditingController();
  final TextEditingController txtCity = TextEditingController();
 
  // Error messages
  String? usernameError;
  String? emailError;
  String? passwordError;
  String? mobileError;
  String? cityError;
  bool isStay = false;
  bool _isPasswordVisible = false;
  bool mounted = true;
  Future<void> _signUp() async {
    setState(() {
      // Validate and update error messages
      usernameError = validatorController.validateUsername(txtUserName.text);
      emailError = validatorController.validateEmail(txtEmail.text);
      passwordError = validatorController.validatePassword(txtPassword.text);
      mobileError = validatorController.validateMobile(txtMobile.text);
      cityError = validatorController.validateCity(txtCity.text);
    });

    // Check if validation passed
    if (usernameError == null &&
        emailError == null &&
        passwordError == null &&
        mobileError == null &&
        cityError == null) {
      // API call only if validation is successful
      print("Validation passed. Attempting to sign up...");
      
      final response = await ApiService.signup(
        username: txtUserName.text,
        email: txtEmail.text,
        mobile: txtMobile.text,
        city: txtCity.text,
        password: txtPassword.text,
      );

      print("API Response: $response"); // Debugging line to check the response

      if (response['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Signup successfully!')),
        );
        // Delay to ensure the snack bar is visible before navigation
        await Future.delayed(Duration(seconds: 1));

        // Navigate to the next page on success
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const HelpUsView(),
            ),
          );
        }
      } else {
        // Handle signup error
        print("Signup failed: ${response['message']}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'])),
        );
      }
    } else {
      print("Validation failed. Not proceeding with signup.");
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
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: TColor.primary),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Sign up",
                style: TextStyle(
                  color: TColor.text,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 20),

              // Username Field with Error
              RoundTextField(
                suffixIcon: IconButton(onPressed: (){}, icon: Icon(Icons.person,color: TColor.text)),
                controller: txtUserName,
                hintText: "Username",
                onChanged: (value) {},
              ),
              if (usernameError != null)
                Text(
                  usernameError!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              const SizedBox(height: 15),

              // Email Field with Error
              RoundTextField(
                suffixIcon: IconButton(onPressed: (){}, icon: Icon(Icons.email,color: TColor.text)),
                controller: txtEmail,
                hintText: "Email Address",
                keyboardType: TextInputType.emailAddress,
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

              // City Field with Error
              RoundTextField(
                suffixIcon: IconButton(onPressed: (){}, icon: Icon(Icons.home,color: TColor.text)),
                controller: txtCity,
                hintText: "City",
                keyboardType: TextInputType.text,
                onChanged: (value) {},
              ),
              if (cityError != null)
                Text(
                  cityError!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              const SizedBox(height: 15),

              // Mobile Field with Error
              RoundTextField(
                suffixIcon: IconButton(onPressed: (){}, 
                icon: Icon(Icons.call,color: TColor.text,)),
                controller: txtMobile,
                hintText: "Mobile Phone",
                keyboardType: TextInputType.phone,
                onChanged: (value) {},
              ),
              if (mobileError != null)
                Text(
                  mobileError!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              const SizedBox(height: 15),

              Row(
                children: [
                  IconButton(
                    onPressed: () => setState(() => isStay = !isStay),
                    icon: Icon(
                      isStay ? Icons.check_box : Icons.check_box_outline_blank,
                      color: isStay
                          ? TColor.primary
                          : TColor.subTitle.withOpacity(0.3),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "Please sign me up for the monthly newsletter.",
                      style: TextStyle(
                        color: TColor.subTitle.withOpacity(0.3),
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              RoundLineButton(
                title: "Sign Up",
                onPressed: _signUp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
