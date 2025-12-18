import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'second_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Eric Sample',
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Carousel images
  final List<String> imageList = [
    "https://picsum.photos/id/1018/800/400",
    "https://picsum.photos/id/1015/800/400",
    "https://picsum.photos/id/1003/800/400",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GFAppBar(
        title: const Text("Midterm App Bar Sample"),
        backgroundColor: GFColors.PRIMARY,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            // 🔵 AUTO-SLIDING CAROUSEL
            GFCarousel(
              height: 200.0,
              autoPlay: true,
              enlargeMainPage: true,
              activeIndicator: GFColors.PRIMARY,
              passiveIndicator: Colors.white,
              pagerSize: 10,
              items: imageList.map((url) {
                return Container(
                  margin: const EdgeInsets.all(5),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(url, fit: BoxFit.cover),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            // 🟦 CARD SAMPLE
           GFCard(
              boxFit: BoxFit.cover,
              image: Image.network(
                'https://picsum.photos/id/1020/800/400',
                fit: BoxFit.cover,
              ),
              title: GFListTile(
                avatar: GFAvatar(
                  backgroundImage: const NetworkImage('https://picsum.photos/100'),
                ),
                title: const Text('ERIC NJUGUNA'),
                subTitle: const Text('Near East University Mobile Developers'),
              ),

              buttonBar: GFButtonBar(
                children: <Widget>[
                  GFButton(
                    onPressed: () {
                      GFToast.showToast(
                        "Awesome! Registered.",
                        context,
                        backgroundColor: Colors.green,
                        toastPosition: GFToastPosition.BOTTOM,
                      );
                    },
                    text: 'Yes',
                    color: GFColors.PRIMARY,
                  ),
                  GFButton(
                    onPressed: () {
                      GFToast.showToast(
                        "As how now ?!",
                        context,
                        backgroundColor: Colors.redAccent,
                        toastPosition: GFToastPosition.BOTTOM,
                      );
                    },
                    text: 'No',
                    color: GFColors.PRIMARY,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ⭐ RATING WIDGET
            GFRating(
              value: 3,
              color: Colors.amber,
              borderColor: Colors.grey.shade400,
              size: GFSize.LARGE,
              allowHalfRating: true,
              onChanged: (value) {
                GFToast.showToast(
                  "Your current rating is $value stars",
                  context,
                  backgroundColor: Colors.green,
                  toastPosition: GFToastPosition.BOTTOM,
                );
              },
            ),

            const SizedBox(height: 30),

            // 🟩 BUTTON TO GO TO SECOND PAGE
            GFButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SecondPage()),
                );
              },
              text: "Go to Second Page",
              color: GFColors.PRIMARY,
              fullWidthButton: true,
            ),

          ],
        ),
      ),
    );
  }
}
