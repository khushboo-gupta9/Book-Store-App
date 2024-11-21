import 'package:bookapp/common/color_extenstion.dart';
import 'package:bookapp/common_widget/round_button.dart';
import 'package:bookapp/view/login/conf_new_password.dart';
import 'package:bookapp/view/main_tab/main_tab_view.dart';
import 'package:flutter/material.dart';

class EmailVerification extends StatefulWidget {
  const EmailVerification({super.key, required String email});

  @override
  State<EmailVerification> createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
  final TextEditingController txtEmailverfy1 = TextEditingController();
  final TextEditingController txtEmailverfy2 = TextEditingController();
  final TextEditingController txtEmailverfy3 = TextEditingController();
  final TextEditingController txtEmailverfy4 = TextEditingController();

  // Error messages
  String? emailvarifyError;

  bool isStay = false;

  void _EmailVerfication() {
    setState(() {
      // Validate and update error messages
    });

    if (emailvarifyError == null) {
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
                "Enter your email OTP here",
                style: TextStyle(
                    color: TColor.text,
                    fontSize: 24,
                    fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    width: 70,
                    height: 70,
                    child: TextField(
                      autofocus: true,
                      controller: txtEmailverfy1,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    width: 70,
                    height: 70,
                    child: TextField(
                      autofocus: true,
                      controller: txtEmailverfy2,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(border: InputBorder.none),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    width: 70,
                    height: 70,
                    child: TextField(
                      autofocus: true,
                      controller: txtEmailverfy3,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(border: InputBorder.none),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    width: 70,
                    height: 70,
                    child: TextField(
                      controller: txtEmailverfy4,
                      textAlign: TextAlign.center,
                      autofocus: true,
                      decoration: InputDecoration(border: InputBorder.none),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              RoundLineButton(
                title: "Submit",
                onPressed: () {
                  _EmailVerfication();
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ConfNewPassword()));
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
