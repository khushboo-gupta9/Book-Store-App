import 'dart:convert';
import 'package:bookapp/common_widget/your_review_cell.dart';
import 'package:bookapp/view/account/edit_profile_view.dart';
import 'package:bookapp/view/login/sign_in_view.dart';
import 'package:flutter/material.dart';
import '../../common/color_extenstion.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AccountView extends StatefulWidget {
  const AccountView({super.key});

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  String username = "";
  String city = "";
  String profileImage = "";

  @override
  void initState() {
    super.initState();
    // Load user info after login (Assuming the token is saved in shared preferences or other storage)
    loadUserData();
  }

Future<void> saveToken(String token) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('authToken', token); // 'authToken' key के रूप में सेव करें
}
Future<String?> getToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('authToken'); // 'authToken' के द्वारा टोकन प्राप्त करें
}

  Future<void> loadUserData() async {
    String token = "jsonwebtoken"; // Retrieve saved token
    final response = await http.get(
      Uri.parse("http://192.168.74.220:5454/updateprofile"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      setState(() {
        username = data['user']['username'];
        city = data['user']['city'];
        profileImage = data['user']['profile_image'];
      });
    } else {
      // Handle error
      print("Failed to load user data: ${response.statusCode}");
    }
  }

 Future<void> updateProfile(String newUsername, String newCity) async {
  String? token = await getToken(); 

  if (token == null) {
    print("No token found. User might not be logged in.");
    return;
  }

  final response = await http.post(
    Uri.parse("http://10.0.2.2:5454/updateprofile"),
    headers: {"Authorization": "Bearer $token"},
    body: {
      "username": newUsername,
      "city": newCity,
    },
  );

  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    setState(() {
      username = data['updatedProfile']['username'] ?? username;
      city = data['updatedProfile']['city'] ?? city;
    });
    print("Profile updated successfully");
  } else {
    print("Failed to update profile: ${response.statusCode}");
  }
}
Future<void> removeToken() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('authToken'); // 'authToken' को हटाएँ
}


  List<String> purArr = [
    "assets/img/p1.jpeg",
    "assets/img/p2.jpg",
    "assets/img/p3.jpg"
  ];

  List<Map<String, dynamic>> sResultArr = [
    {
      "img": "assets/img/p1.jpeg",
      "description":
          "A must read for everybody. This book taught me so many things about...",
      "rate": 5.0
    },
    {
      "img": "assets/img/p2.jpg",
      "description":
          "#1 international bestseller and award winning history book.",
      "rate": 4.0
    }
  ];

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '{$username}',
                          style: TextStyle(
                              color: TColor.text,
                              fontSize: 20,
                              fontWeight: FontWeight.w700),
                        ),
                        Text(
                          "Constantly travelling and keeping up to date with business related books.",
                          style:
                              TextStyle(color: TColor.subTitle, fontSize: 13),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(35),
                    child: Image.asset(
                      "assets/img/u1.png",
                      width: 70,
                      height: 70,
                    ),
                  ),
                  const SizedBox(width: 15),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                children: [
                  Icon(
                    Icons.near_me_sharp,
                    color: TColor.subTitle,
                    size: 15,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "{$city}",
                      style: TextStyle(color: TColor.subTitle, fontSize: 13),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfileScreen(),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.edit,
                          size: 35,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        onPressed: () {
                          // Show the logout confirmation dialog
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Logout Confirmation"),
                                content:
                                    Text("Are you sure you want to logout?"),
                                actions: [
                                  TextButton(
                                    child: Text("Cancel"),
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Close the dialog
                                    },
                                  ),
                                  TextButton(
                                    child: Text("OK"),
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Close the dialog
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const SignInView(),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        icon: const Icon(
                          Icons.logout_outlined,
                          size: 35,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "21",
                        style: TextStyle(
                            color: TColor.subTitle,
                            fontSize: 30,
                            fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Books",
                        style: TextStyle(color: TColor.subTitle, fontSize: 11),
                      ),
                    ],
                  ),
                  const SizedBox(width: 30),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "5",
                        style: TextStyle(
                            color: TColor.subTitle,
                            fontSize: 30,
                            fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Reviews",
                        style: TextStyle(color: TColor.subTitle, fontSize: 11),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
              child: Text(
                "Your wishes (21)",
                style: TextStyle(
                    color: TColor.subTitle,
                    fontSize: 20,
                    fontWeight: FontWeight.w700),
              ),
            ),
            Stack(
              alignment: Alignment.centerLeft,
              children: [
                Container(
                  height: media.width * 0.4,
                  width: media.width * 0.45,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 243, 235, 235),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: purArr.map((iName) {
                      var isFirst = purArr.first == iName;
                      var isLast = purArr.last == iName;
                      return Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 2, horizontal: 12),
                        padding: isFirst
                            ? const EdgeInsets.only(left: 25)
                            : (isLast
                                ? const EdgeInsets.only(right: 25)
                                : null),
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 2,
                                  offset: Offset(0, 1))
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.asset(
                              iName,
                              height: media.width * 0.5,
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
              child: Text(
                "Your reviews (7)",
                style: TextStyle(
                    color: TColor.subTitle,
                    fontSize: 20,
                    fontWeight: FontWeight.w700),
              ),
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 25),
              itemCount: sResultArr.length,
              itemBuilder: (context, index) {
                var rObj = sResultArr[index];
                return YourReviewRow(sObj: rObj);
              },
            ),
          ],
        ),
      ),
    );
  }
}
