import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class ThirdPage extends StatelessWidget {
  const ThirdPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GFAppBar(
        title: const Text("Third Page"),
        backgroundColor: GFColors.PRIMARY,
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

          
            GFImageOverlay(
              height: 200,
              width: double.infinity,
              image: const NetworkImage(
                'https://images.unsplash.com/photo-1522202176988-66273c2fd55f',
              ),
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.4),
                BlendMode.darken,
              ),
              child: const Center(
                child: Text(
                  "Third Page Header Image",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 📘 ACCORDION
            GFAccordion(
              title: 'Eric Page Info',
              content: 'Program: Computer Information Systems (CIS)\n'
                          "University: Near East University\n"
                          "Role: Mobile App Developer (Student)\n"
                          "Skills: Flutter • Java • PHP • MySQL",
              collapsedIcon: const Icon(Icons.arrow_drop_down),
              expandedIcon: const Icon(Icons.arrow_drop_up),
            ),

            const SizedBox(height: 20),

            // 📊 PROGRESS BAR
            GFProgressBar(
              percentage: 0.6,
              backgroundColor: Colors.black12,
              progressBarColor: GFColors.PRIMARY,
              lineHeight: 12,
              child: const Text(
                '60%',
                style: TextStyle(color: Colors.black),
              ),
            ),

            const SizedBox(height: 20),

          
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
                        "Awesome! Clock it.",
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

            // ⭐ RATING 
            GFRating(
              value: 5,
              color: Colors.amber,
              borderColor: Colors.grey,
              size: GFSize.LARGE,
              allowHalfRating: true,
              onChanged: (value) {
                GFToast.showToast(
                  "You rated $value stars",
                  context,
                  backgroundColor: GFColors.PRIMARY,
                  toastPosition: GFToastPosition.BOTTOM,
                );
              },
            ),

            const SizedBox(height: 20),

            // ⏳ LOADER
            const GFLoader(type: GFLoaderType.circle),

            const SizedBox(height: 20),

            // 🔙 BACK BUTTON
            GFButton(
              onPressed: () {
                Navigator.pop(context);
              },
              text: "Back to Previous Page",
              icon: const Icon(Icons.arrow_back),
              color: GFColors.PRIMARY,
              fullWidthButton: true,
            ),
          ],
        ),
      ),
    );
  }
}
