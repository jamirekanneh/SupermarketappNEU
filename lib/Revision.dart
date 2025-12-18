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
      title: 'GetWidget 7.0.0 Demo',
      home: GetWidgetDemo(),
    );
  }
}

class GetWidgetDemo extends StatelessWidget {
  Widget header(String text) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(text,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GFAppBar(
        title: Text("GetWidget 7.0.0 Components"),
        backgroundColor: GFColors.PRIMARY,
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // 1. GFButton -----------------------------------------------------
            header("1. GFButton"),
            GFButton(
              onPressed: () {},
              text: "Click Me",
              color: GFColors.PRIMARY,
            ),
            SizedBox(height: 20),

            // 3. GFListTile ---------------------------------------------------
            header("3. GFListTile"),
            GFListTile(
              avatar: GFAvatar(backgroundImage: AssetImage('assets/images/myimage.jpg')),
              titleText: 'John Doe',
              subTitleText: 'Flutter Developer',
            ),

            // 4. GFAvatar -----------------------------------------------------
            header("4. GFAvatar"),
            GFAvatar(
              backgroundImage: AssetImage('assets/images/myimage.jpg'),
              size: GFSize.LARGE,
            ),
            SizedBox(height: 20),

            // 5. GFIconButton -------------------------------------------------
            header("5. GFIconButton"),
            GFIconButton(
              onPressed: () {},
              icon: Icon(Icons.favorite, color: Colors.white),
              color: GFColors.DANGER,
            ),
            SizedBox(height: 20),

            // 6. GFAccordion --------------------------------------------------
            header("6. GFAccordion"),
            GFAccordion(
              title: 'Learn Flutter',
              content:
                  'Flutter is Google’s UI toolkit for building apps across platforms.',
            ),
            SizedBox(height: 20),

            // 7. GFProgressBar ------------------------------------------------
            header("7. GFProgressBar"),
            GFProgressBar(
              percentage: 0.6,
              backgroundColor: Colors.black26,
              progressBarColor: GFColors.INFO,
            ),
            SizedBox(height: 20),

            // 8. GFCarousel ---------------------------------------------------
            header("8. GFCarousel"),
            GFCarousel(
              autoPlay: true,
              viewportFraction: 1.0,
              items: ['1', '2', '3'].map(
                (num) => Container(
                  color: Colors.blueGrey,
                  child: Center(
                    child: Text(
                      'Slide $num',
                      style: TextStyle(color: Colors.white, fontSize: 22),
                    ),
                  ),
                ),
              ).toList(),
            ),
            SizedBox(height: 20),

            // 9. GFLoader -----------------------------------------------------
            header("9. GFLoader"),
            GFLoader(type: GFLoaderType.circle),
            SizedBox(height: 20),

            // 10. GFCheckbox --------------------------------------------------
            header("10. GFCheckbox"),
            GFCheckbox(
              size: GFSize.SMALL,
              activeBgColor: GFColors.SUCCESS,
              onChanged: (value) {},
              value: true,
            ),
            SizedBox(height: 20),

            // 11. GFRadio -----------------------------------------------------
            header("11. GFRadio"),
            GFRadio(
              value: 1,
              groupValue: 1,
              onChanged: (val) {},
            ),
            SizedBox(height: 20),

            // 12. GFToggle ----------------------------------------------------
            header("12. GFToggle"),
            GFToggle(
              onChanged: (val) {},
              value: true,
            ),
            SizedBox(height: 20),

            // 13. GFBadge -----------------------------------------------------
            header("13. GFBadge"),
            GFBadge(
              text: 'New',
              color: GFColors.SECONDARY,
            ),
            SizedBox(height: 20),

            // 14. GFDrawer ----------------------------------------------------
            header("14. GFDrawer"),
            Container(
              height: 100,
              color: Colors.grey[200],
              child: Center(
                  child: Text("Drawer shows from Scaffold drawer property")),
            ),
            SizedBox(height: 20),

            // 15. GFAppBar ----------------------------------------------------
            header("15. GFAppBar (Example Above)"),
            Text("Already used at the top of this screen"),
            SizedBox(height: 20),

            // 16. GFToast -----------------------------------------------------
            header("16. GFToast"),
            GFButton(
              text: "Show Toast",
              color: GFColors.INFO,
              onPressed: () {
                GFToast.showToast(
                  "This is a toast message!",
                  context,
                  toastPosition: GFToastPosition.BOTTOM,
                );
              },
            ),
            SizedBox(height: 20),

            // 17. GFShimmer ---------------------------------------------------
            header("17. GFShimmer"),
            GFShimmer(
              child: Container(
                height: 100,
                width: double.infinity,
                color: Colors.grey[300],
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
