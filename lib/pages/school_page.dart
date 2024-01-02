import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../components/func.dart';

class SchoolPage extends StatefulWidget {
  static const String id = 'school_page';
  @override
  State<SchoolPage> createState() => _SchoolPage();
}

class _SchoolPage extends State<SchoolPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: gradientBoxDecoration, // Apply the gradientBoxDecoration
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.fromLTRB(8.0, 4.0, 0, 0.0),
          child: Container(
            margin: EdgeInsets.fromLTRB(50, 10, 50, 0),
            child: Column(
              children: [
                InkWell(
                  onTap: () => locate(
                      'schools', 'school_extremeEilat'), // from func page
                  child: Container(
                    height: 200,
                    width: 300,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        'lib/images/asabro.jpeg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Container(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(color: Colors.black, fontSize: 20),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'אקסטרים - האחים אסא  \n',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: 'מיקום: אילת  \n',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: 'אזורי לימוד: אילת  \n',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => locate(
                      'schools', 'school_extremeBeitYanai'), // from func page
                  child: Container(
                    height: 200,
                    width: 300,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        'lib/images/asabro.jpeg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Container(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(color: Colors.black, fontSize: 20),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'אקסטרים - האחים אסא  \n',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: 'מיקום: בית ינאי  \n',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: 'אזורי לימוד: בית ינאי  \n',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                FetchPhone(schoolId: 'school_extremeBeitYanai'),
                SizedBox(height: 30),
                InkWell(
                  onTap: () =>
                      locate('schools', 'school_surfCenter'), // from func page
                  child: Container(
                    height: 100,
                    width: 300,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset('lib/images/surfcenter.png',
                          fit: BoxFit.fill),
                    ),
                  ),
                ),
                Container(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(color: Colors.black, fontSize: 20),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'סרף סנטר \n',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: 'מיקום: חוף הריף-רף אילת\n',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: 'אזורי לימוד: אילת \n',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                FetchPhone(schoolId: 'school_surfCenter'),
                SizedBox(height: 30),
                InkWell(
                  onTap: () =>
                      locate('schools', 'school_sunShine'), // from func page
                  child: Container(
                    height: 200,
                    width: 300,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        'lib/images/sunshine.jpeg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Container(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(color: Colors.black, fontSize: 20),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'סאנשיין  \n',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: 'מיקום: עתלית  \n',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: 'אזורי לימוד: עתלית, מעיין צבי  \n',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                FetchPhone(schoolId: 'school_sunShine'),
                SizedBox(height: 30),
                InkWell(
                  onTap: () =>
                      locate('schools', 'school_iks'), // from func page
                  child: Container(
                    height: 200,
                    width: 300,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        'lib/images/IKS.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Container(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(color: Colors.black, fontSize: 20),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'IKS -עידן קפלן  \n',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: 'מיקום: חוף פולג  \n',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: 'אזורי לימוד: חוף פולג  \n',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                FetchPhone(schoolId: 'school_iks'),
                SizedBox(height: 30),
                InkWell(
                  onTap: () =>
                      locate('schools', 'school_kiteLab'), // from func page
                  child: Container(
                    height: 200,
                    width: 300,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        'lib/images/kitelab.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                Container(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(color: Colors.black, fontSize: 20),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'קייט לאב \n',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: 'מיקום: הפרחים 41, מושב רשפון  \n',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                            text:
                            'אזורי לימוד: הרצליה, פולג, מכמורת, בית ינאי, שדות ים, חיפה, כנרת  \n',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                FetchPhone(schoolId: 'school_kiteLab'),
                SizedBox(height: 30),
                InkWell(
                  onTap: () =>
                      locate('schools', 'school_surfShack'), // from func page
                  child: Container(
                    height: 200,
                    width: 300,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        'lib/images/surfshack.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Container(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(color: Colors.black, fontSize: 20),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'מועדון הגלישה ניצנים \n',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: 'מיקום: חוף ניצנים  \n',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: 'אזורי לימוד: אשדוד, אשקלון ועד זיקים \n',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                FetchPhone(schoolId: 'school_surfShack'),
                SizedBox(height: 30),
                InkWell(
                  onTap: () =>
                      locate('schools', 'school_kiteSurf'), // from func page
                  child: Container(
                    height: 100,
                    width: 300,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        'lib/images/kitesurfeilat.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                Container(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(color: Colors.black, fontSize: 20),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'קייט סרף אילת\n',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: 'מיקום: אילת  \n',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: 'אזורי לימוד: אילת \n',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                FetchPhone(schoolId: 'school_kiteSurf'),
                SizedBox(height: 30),
                InkWell(
                  onTap: () =>
                      locate('schools', 'school_core'), // from func page
                  child: Container(
                    height: 100,
                    width: 300,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        'lib/images/core.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                Container(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(color: Colors.black, fontSize: 20),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'קייטים -קור \n',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: 'מיקום: קיבוץ גלויות 5, עכו  \n',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                            text:
                            'אזורי לימוד: עכו, נהריה, קריות, חיפה, עתלית, שדות ים \n',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                FetchPhone(schoolId: 'school_core'),
                SizedBox(height: 30),
                InkWell(
                  onTap: () =>
                      locate('schools', 'school_freeGull'), // from func page
                  child: Container(
                    height: 100,
                    width: 300,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        'lib/images/freegull.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                Container(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(color: Colors.black, fontSize: 20),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'פריגל\n',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: 'מיקום: מרכז ימי קיסרייה  \n',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: 'אזורי לימוד: שדות ים \n',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                FetchPhone(schoolId: 'school_freeGull'),
                SizedBox(height: 30),
                InkWell(
                  onTap: () =>
                      locate('schools', 'school_myPoint'), // from func page
                  child: Container(
                    height: 100,
                    width: 300,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        'lib/images/mypoint.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                Container(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(color: Colors.black, fontSize: 20),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'מאי פויינט \n',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: 'מיקום:שלמה בן יוסף 6, הרצליה\n',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: 'אזורי לימוד: חוף פולג, הרצליה \n',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                FetchPhone(schoolId: 'school_myPoint'),
                SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/**
 * A custom button for initiating a phone call.
 *
 * This `CallButton` widget is designed to create an ElevatedButton that, when pressed,
 * initiates a phone call to the specified phone number.
 *
 * @param {String} phoneNumber - The phone number to call when the button is pressed.
 */
class CallButton extends StatelessWidget {
  final String phoneNumber;

  CallButton({required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _launchPhoneCall(),
      child: Text('Call $phoneNumber'),
    );
  }

  _launchPhoneCall() async {
    final url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

/**
 * A widget that fetches a school's phone number and displays a call button.
 *
 * This `FetchPhone` widget retrieves a school's phone number from Firestore based on the provided `schoolId`
 * and displays a `CallButton` to initiate a phone call to that phone number.
 *
 * @param {String} schoolId - The unique identifier for the school.
 */
class FetchPhone extends StatelessWidget {
  final String
  schoolId; // Assuming you have a unique identifier for each school

  FetchPhone({required this.schoolId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('schools')
          .doc(schoolId)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          print('haveData!!');
          return CircularProgressIndicator(); // Loading indicator while fetching data
        }

        // Assuming your document structure has a field called 'phoneNumber'
        final phone = snapshot.data?['phone'];
        print("phone: "+ phone);
        return CallButton(phoneNumber: phone);
      },
    );
  }
}