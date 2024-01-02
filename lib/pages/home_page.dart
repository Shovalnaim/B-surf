import 'package:flutter/material.dart';
import '../components/func.dart';
import 'info_page.dart';

class HomePage extends StatelessWidget {
  static const String id = 'home_page';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: gradientBoxDecoration, // Apply the gradientBoxDecoration
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            reverse: true,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  height: 150,
                  child: Image.asset('lib/images/BBB.png'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Text(
                    '''
קייט סרפינג הוא ספורט אקסטרים ימי שבו הגולש מחובר לעפיפון גדול ומייצר כוח בעזרת הרוח מדובר באחד מענפי הספורט הימי המפותחים ביותר כיום
קייט סרפינג נחשב לספורט קל יחסית מבחינה פיזית מאחר והשליטה בעפיפון היא טכנית ולא דורשת מאמץ רב
את הטכניקה רוכשים בקורס קייט סרפינג אשר מלמד בנוסף לתאוריה והוראות בטיחות גם את השליטה הנכונה בקייט''',
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(
                        context, InfoPage.id); // nav to the info page
                  },
                  child: Text(
                    'למידע נוסף וסרטונים לחץ כאן',
                    style: TextStyle(color: Colors.red, fontSize: 20),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}