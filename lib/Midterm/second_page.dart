import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'third_page.dart';

class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GFAppBar(
        title: const Text("Second Page"),
        backgroundColor: GFColors.PRIMARY,
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            // 🖼️ IMAGE OVERLAY
            GFImageOverlay(
              height: 200,
              width: double.infinity,
              image: const NetworkImage(
                'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
              ),
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.4),
                BlendMode.darken,
              ),
              child: const Center(
                child: Text(
                  "Midterm Network Image Example",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 📘 ACCORDION
            GFAccordion(
              title: 'More Info',
              content:
                  'This is the second page of your Midterm Exam using GetWidget components like GFAccordion, GFImageOverlay, and GFProgressBar.',
              collapsedIcon: const Icon(Icons.arrow_drop_down),
              expandedIcon: const Icon(Icons.arrow_drop_up),
            ),

            const SizedBox(height: 20),

            // 📊 PROGRESS BAR
            GFProgressBar(
              percentage: 0.9,
              backgroundColor: Colors.black12,
              progressBarColor: Colors.green,
              lineHeight: 12,
              child: const Text(
                '90%',
                style: TextStyle(color: Colors.black),
              ),
            ),

            const SizedBox(height: 20),

            // ⭐ RATING
            GFRating(
              value: 4,
              color: Colors.amber,
              borderColor: Colors.grey.shade400,
              size: GFSize.LARGE,
              allowHalfRating: true,
              onChanged: (value) {
                GFToast.showToast(
                  "You rated $value stars",
                  context,
                  backgroundColor: Colors.green,
                  toastPosition: GFToastPosition.BOTTOM,
                );
              },
            ),

            const SizedBox(height: 20),

            // 🟦 NEW BUTTON → GO TO THIRD PAGE
            GFButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ThirdPage()),
                );
              },
              text: "Go to Third Page",
              color: GFColors.PRIMARY,
              fullWidthButton: true,
            ),

            const SizedBox(height: 12),

            // 🔙 BACK BUTTON
            GFButton(
              onPressed: () {
                Navigator.pop(context);
              },
              text: "Back to Home Page",
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
