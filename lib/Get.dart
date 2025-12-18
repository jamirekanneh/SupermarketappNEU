import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ✅ List of network images for carousel
  final List<String> imageList = [
    "https://cdn.pixabay.com/photo/2017/12/03/18/04/christmas-balls-2995437_960_720.jpg",
    "https://cdn.pixabay.com/photo/2017/12/13/00/23/christmas-3015776_960_720.jpg",
    "https://cdn.pixabay.com/photo/2019/12/19/10/55/christmas-market-4705877_960_720.jpg",
    "https://cdn.pixabay.com/photo/2019/12/20/00/03/road-4707345_960_720.jpg",
    "https://cdn.pixabay.com/photo/2019/12/22/04/18/x-mas-4711785__340.jpg",
    "https://cdn.pixabay.com/photo/2016/11/22/07/09/spruce-1848543__340.jpg"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GFAppBar(
        leading: GFIconButton(
          icon: Icon(
            Icons.message,
            color: Colors.white,
          ),
          onPressed: () {},
          type: GFButtonType.transparent,
        ),
        searchBar: true,
        title: Text("GF UI Demo"),
        actions: <Widget>[
          GFIconButton(
            icon: Icon(
              Icons.favorite,
              color: Colors.white,
            ),
            onPressed: () {},
            type: GFButtonType.transparent,
          ),
        ],
      ),

      // ✅ Body content
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ✅ Carousel at top
            GFCarousel(
              items: imageList.map(
                (url) {
                  return Container(
                    margin: EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      child: Image.network(
                        url,
                        fit: BoxFit.cover,
                        width: 1000.0,
                      ),
                    ),
                  );
                },
              ).toList(),
              onPageChanged: (index) {
                setState(() {});
              },
            ),

            SizedBox(height: 10),

            // ✅ GF Card section
            GFCard(
              boxFit: BoxFit.cover,
              titlePosition: GFPosition.start,
              showOverlayImage: true,
              imageOverlay: AssetImage(
                'assets/your_image.jpg', // change to your asset
              ),
              title: GFListTile(
                avatar: GFAvatar(
                  backgroundImage: AssetImage('assets/your_image.jpg'),
                ),
                titleText: 'Game Controllers',
                subTitleText: 'PlayStation 4',
              ),
              content: Text(
                "Some quick example text to build on the card",
              ),
              buttonBar: GFButtonBar(
                children: <Widget>[
                  GFAvatar(
                    backgroundColor: GFColors.PRIMARY,
                    child: Icon(
                      Icons.share,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            // ✅ Added GFButton below card
            GFButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Button clicked!')),
                );
              },
              text: "Click Me",
              color: GFColors.PRIMARY,
            ),
            GFListTile(
                avatar: GFAvatar(backgroundImage: AssetImage('assets/user.png')),
                 titleText: 'John Doe',
                 subTitleText: 'Flutter Developer',
                )

          ],
        ),
      ),
      
    );
  }
}
