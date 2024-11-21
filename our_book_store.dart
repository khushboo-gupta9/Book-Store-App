import 'package:flutter/material.dart';

class OurBookStore extends StatefulWidget {
  const OurBookStore({super.key});

  @override
  State<OurBookStore> createState() => _OurBookStoreState();
}

class _OurBookStoreState extends State<OurBookStore> {
  List imageArr = [
    "assets/img/s1.jpg", 
    "assets/img/s2.jpg",
    "assets/img/s3.jpg"
  ];

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.topCenter,
              children: [
                Image.asset(
                  "assets/img/ob3.jpg",
                  width: media.width,
                  height: media.height * 0.35,
                  fit: BoxFit.cover,
                ),
                AppBar(
                  backgroundColor: Colors.black.withOpacity(0.3),
                  elevation: 0,
                  leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    'Our Book Store',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  centerTitle: true,
                ),
                Padding(
                  padding: EdgeInsets.only(top: media.height * 0.24),
                  child: Column(
                    children: [
                      SizedBox(
                        height: media.width * 0.5,
                        child: PageView.builder(
                          onPageChanged: (index) {
                            setState(() {
                              currentIndex = index;
                            });
                          },
                          itemCount: imageArr.length,
                          itemBuilder: (context, index) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                for (int i = 0; i < 3; i++) 
                                  Image.asset(
                                    imageArr[(index + i) % imageArr.length],
                                    height: 150,
                                    width: media.width * 0.3,
                                    fit: BoxFit.cover,
                                  ),
                              ],
                            );
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(imageArr.length, (index) {
                          return Container(
                            width: currentIndex == index ? 10.0 : 8.0,
                            height: currentIndex == index ? 10.0 : 8.0,
                            margin: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 4.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: currentIndex == index
                                  ? Colors.blue
                                  : Colors.grey[400],
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
              child: Text(
                """ Discover a world of endless stories at your fingertips with our online reading book store  app, offering a vast library of genres to suit every reader’s taste.
Enjoy a seamless reading experience with customizable features like adjustable font sizes, night mode, and bookmarks to pick up right where you left off.
Stay connected with your favorite authors and receive personalized recommendations based on your reading habits, helping you find new books you'll love.""",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[800], 
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
