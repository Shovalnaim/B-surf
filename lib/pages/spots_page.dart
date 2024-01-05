import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../components/func.dart';

class SpotsPage extends StatefulWidget {
  static const String id = 'spots_page';

  @override
  State<SpotsPage> createState() => _SpotsPageState();
}

class _SpotsPageState extends State<SpotsPage> {
  String userFavoriteSpot = '';
  User? loggedInUser;

  /**
   * Fetch the favorite spot of the currently logged-in user from Firestore.
   *
   * This function retrieves the favorite spot data associated with the currently authenticated user
   * and updates the `userFavoriteSpot` variable, if available.
   *
   * @throws {String} If an error occurs during the fetching process.
   */
  Future<void> fetchUserFavoriteSpot() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser);
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(loggedInUser!.uid)
            .get();
        if (userDoc.exists) {
          setState(() {
            userFavoriteSpot = userDoc['favoriteSpot'];
          });
        }
      }
    } catch (e) {
      print("Error fetching user's favorite spot: $e");
    }
  }

  Positioned buildFavoriteButton(String buttonName, BuildContext context) {
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

    return Positioned(
      top: 0,
      right: 0,
      child: InkWell(
        onTap: () async {
          // Request permission for FCM notifications
          NotificationSettings settings =
          await _firebaseMessaging.requestPermission(
            announcement: true, // Optional // true to receive critical alerts
          );

          if (settings.authorizationStatus == AuthorizationStatus.authorized) {
            print('Notification permission granted');

            if (isButtonFavorite(buttonName)) {
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(loggedInUser!.uid)
                  .update({'favoriteSpot': 'none', 'deviceToken': 'none'});
            } else {
              String? deviceToken = await _firebaseMessaging.getToken();
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(loggedInUser!.uid)
                  .update(
                  {'favoriteSpot': buttonName, 'deviceToken': deviceToken});
            }

            await fetchUserFavoriteSpot();
          } else {
            print('Notification permission denied');
          }
        },
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.transparent,
          ),
          child: Icon(
            Icons.favorite,
            color: isButtonFavorite(buttonName) ? Colors.red : Colors.blueGrey,
            size: 40,
          ),
        ),
      ),
    );
  }

  bool isButtonFavorite(String buttonName) {
    return userFavoriteSpot == buttonName;
  }

  @override
  void initState() {
    super.initState();
    fetchUserFavoriteSpot();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: gradientBoxDecoration, // Apply the gradientBoxDecoration
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.fromLTRB(20, 10, 20, 75),
            child: Column(children: [
              Container(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(color: Colors.black, fontSize: 20),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'חוף בצת \n',
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text:
                        '\n  עבור מתחילים הוא יכול להיות מסוכן בכניסה וביציאה מהמים וגם במידה ואתם עדיין לא מחדדים טוב ועלולים לצאת באזור שהוא יותר סלעי מהכניסה',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: ' הספוט בבצת ידוע ברוחות צפוניות\n',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () =>
                    locate('locations', 'Spot_betset'), // from func page
                child: Stack(
                  children: [
                    Container(
                      width: 325,
                      height: 175,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          'lib/images/betsetSpot.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    buildFavoriteButton(
                        'betset', context), // Reuse the function here
                  ],
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(15),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(color: Colors.black, fontSize: 20),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'קריות \n',
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                          text:
                          "הספוט בקריות נחשב נוח יותר למתחילים. יש בו רצועה חולית ארוכה\n  ",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(
                          text:
                          " לכן מתקיימים כאן שיעורים של מועדונים.הספוט נמצא בקריית ים סמוך לחוף זבולון שבו יש גם חניה די רחבה.הספוט עובד גם בצפוניות, דרומיות ומערביות. ",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () => locate('locations', 'Spot_krayot'),
                child: Stack(
                  children: [
                    Container(
                      width: 325,
                      height: 175,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          'lib/images/krayotSpot.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    buildFavoriteButton(
                        'krayot', context), // Reuse the function here
                  ],
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(15),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(color: Colors.black, fontSize: 20),
                    children: <TextSpan>[
                      TextSpan(
                          text: 'בת גלים \n',
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold)),
                      TextSpan(
                          text:
                          " \n חוף בת גלים אינו מתאים למתחילים, ודי מסוכן",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(
                          text:
                          'הכניסה למים היא דרך ריף מאוד חד ורדוד ובדרכ חוזרים עם חתכים.בת גלים נחשבת לספוט הטוב ביותר לגלישת קייט גלים בארץ. \n',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(
                          text:
                          ' כיוון הרוח הטוב ביותר לגלישה הוא בדרומיות/דרום-מערביות ולכן התקופה הטובה ביותר לגלישה בבת גלים היא בחורף וגם בקיץ יש ימים שנכנסות דרומיות טובות. ',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () => locate('locations', 'Spot_batGalim'),
                child: Stack(
                  children: [
                    Container(
                      width: 325,
                      height: 175,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          'lib/images/batgalimSpot.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    buildFavoriteButton(
                        'batGalim', context), // Reuse the function here
                  ],
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(15),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(color: Colors.black, fontSize: 20),
                    children: <TextSpan>[
                      TextSpan(
                          text: "\n חיפה חוף הסטודנטים",
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold)),
                      TextSpan(
                          text: "\n חוף הסטודנטים בחיפה מתאים למתחילים\n",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(
                        text:
                        "הכניסה אליו היא דרך כביש 2 דרום. במקום יש חניה גדולה חינם וקרובה מאוד לחוף עצמו. החוף הוא חולי, רחב וכמעט ללא סלעים. מדי פעם כן יהיו סלעים צמוד לקו המים וצריך לשים לב אליהם ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () => locate('locations', 'Spot_studentBeach'),
                child: Stack(
                  children: [
                    Container(
                      width: 325,
                      height: 175,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          'lib/images/studentsSpot.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    buildFavoriteButton(
                        'studentBeach', context), // Reuse the function here
                  ],
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(15),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(color: Colors.black, fontSize: 20),
                    children: <TextSpan>[
                      TextSpan(
                          text: "\n חוף המבצר בעתלית",
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold)),
                      TextSpan(
                          text:
                          "\n חוף המבצר בעתלית הוא כנראה החוף הטוב ביותר לגלוש בו בעונת הצפוניות בים התיכון בגלל השילוב של מקום שבו הצפונית נכנסת חזק ומוקדם יחסית לחופים אחרים וגם מכיוון שמדובר בחוף נוח גם למתחילים ולחובבי התרגילים. רצועה חולית ארוכה, ברובה רחבה וללא סלעים כלל.\n",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(
                        text:
                        "מעט לפני המבצר נמצא מזח שמשמש דייגים. הוא מסמן את הגבול הדרומי לגלישה. ממש אחריו נמצא כאמור המבצר שהוא שטח צבאי סגור. לכן אם הרוח לא מספיק חזקה לחידוד או שאתם מתחילים, צאו מהמים כאשר אתם כבר קרובים לאותו המזח של הדייגים ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () => locate('locations', 'Spot_atlit'),
                child: Stack(
                  children: [
                    Container(
                      width: 325,
                      height: 175,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          'lib/images/atlitSpot.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    buildFavoriteButton(
                        'atlit', context), // Reuse the function here
                  ],
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(15),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(color: Colors.black, fontSize: 20),
                    children: <TextSpan>[
                      TextSpan(
                          text: "\n נווה ים",
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold)),
                      TextSpan(
                        text:
                        "\n נווה ים הוא החוף הדרומי של עתלית וההגעה אליו היא דרך הכביש המוביל לקיבוץ נווה ים שעובר לאורך כל עתלית בצפוניות יש הסתרה וצריך להתמקם כמה מאות מטרים דרומה כדי לקבל את הצפונית כמו שצריך\n",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () => locate('locations', 'Spot_neveYam'),
                child: Stack(
                  children: [
                    Container(
                      width: 325,
                      height: 175,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          'lib/images/nevayamSpot.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    buildFavoriteButton(
                        'nevaYam', context), // Reuse the function here
                  ],
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(15),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(color: Colors.black, fontSize: 20),
                    children: <TextSpan>[
                      TextSpan(
                          text: "\n מעיין צבי",
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold)),
                      TextSpan(
                          text:
                          "\n רבים מכירים את החוף הזה כחוף שבו עושים חילוצים ברוחות מזרחיות,מדובר בחוף פתוח, מאוד ארוך ורחב, חולי וללא סלעים.\n",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(
                        text:
                        "\n  בצפוניות זהו חוף שיכול להיות מצוין למתחילים בגלל שיש מרחב ללמידה ולרדת ברוח, אבל גם בחוף זה כדאי לוודא שיהיה מישהו שגם יגלוש כאן, כי לרוב יהיו כאן בצפוניות גולשים בודדים.",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () => locate('locations', 'Spot_maayanTzvi'),
                child: Stack(
                  children: [
                    Container(
                      width: 325,
                      height: 175,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          'lib/images/mayanzviSpot.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    buildFavoriteButton(
                        'maayanTzvi', context), // Reuse the function here
                  ],
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(15),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(color: Colors.black, fontSize: 20),
                    children: <TextSpan>[
                      TextSpan(
                          text: "\n קייסריה ושדות ים",
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold)),
                      TextSpan(
                          text:
                          "\n חוף שדות ים נמצא מעט דרומית לקיסריה, קרוב מאוד לארובות של תחנת הכח חדרה חוף שדות ים הוא חולי ורצועת החוף רחבה יותר, אך עדיין ביחס לחופים אחרים כמו עתלית ופולג, נמצאים בו לא מעט סלעים ורצועת החוף להנפה היא לא רחבה מאוד, כמה עשרות מטרים. \n",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(
                        text:
                        "\n החוף נחשב מאוד פופולרי בצפוניות מכיוון שביחס לחופים דרומיים הוא עובד טוב בצפוניות",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () => locate('locations', 'Spot_sdotYam'),
                child: Stack(
                  children: [
                    Container(
                      width: 325,
                      height: 175,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          'lib/images/sdotyamSpot.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    buildFavoriteButton(
                        'sdotYam', context), // Reuse the function here
                  ],
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(15),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(color: Colors.black, fontSize: 20),
                    children: <TextSpan>[
                      TextSpan(
                          text: "\n בית ינאי",
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold)),
                      TextSpan(
                          text:
                          "\n חוף בית ינאי הוא אחד החופים הכי מזוהים עם גלישת קייט גם בקרב הרבה אנשים שאינם גולשים.מדובר בחוף ארוך ורחב ברובו וחולי ולכן הוא מתאים למתחילים. במקום מתקיימים הרבה קורסים יחסית לחופים אחרים גם בגלל הנגישות והמיקום שלו.  \n",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(
                        text:
                        "\n מכיוון שהחוף אינו בשטח עירוני והוא די רחב ופתוח, אפשר לגלוש בו באופן בטוח בצפוניות וגם בדרומיות ובמערביות של החורף.",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () => locate('locations', 'Spot_beitYanai'),
                child: Stack(
                  children: [
                    Container(
                      width: 325,
                      height: 175,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          'lib/images/bietynaySpot.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    buildFavoriteButton(
                        'beitYanai', context), // Reuse the function here
                  ],
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(15),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(color: Colors.black, fontSize: 20),
                    children: <TextSpan>[
                      TextSpan(
                          text: "\n נתניה-פולג",
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold)),
                      TextSpan(
                          text:
                          "\n הוא פחות מתאים למתחילים שהשליטה שלהם בקייט היא עדיין לא ברמה מספיק טובה. בדרומיות הים יותר מסודר באזור שקרוב לשובר, \n",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(
                        text:
                        "\nבצפוניות מומלץ להתמקם כמה מאות מטרים צפונה בגלל שוברי הגלים ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () => locate('locations', 'Spot_poleg'),
                child: Stack(
                  children: [
                    Container(
                      width: 325,
                      height: 175,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          'lib/images/natanyaSpot.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    buildFavoriteButton(
                        'poleg', context), // Reuse the function here
                  ],
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(15),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(color: Colors.black, fontSize: 20),
                    children: <TextSpan>[
                      TextSpan(
                          text: "\n הרצליה-מעליות",
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold)),
                      TextSpan(
                        text:
                        "\n החוף נמצא מתחת למלון דניאל בהרצליה, אמנם רצועת החוף היא חולית וללא סלעים, אבל היא לא רחבה.  החוף מאוד פופולרי בדרומיות, ובצפוניות \n",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () => locate('locations', 'Spot_herzliya'),
                child: Stack(
                  children: [
                    Container(
                      width: 325,
                      height: 175,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          'lib/images/herzlyaSpot.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    buildFavoriteButton(
                        'herzliya', context), // Reuse the function here
                  ],
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(15),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(color: Colors.black, fontSize: 20),
                    children: <TextSpan>[
                      TextSpan(
                          text: "\n גאולה",
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold)),
                      TextSpan(
                          text:
                          "\n לא מתאים למתחילים.  בעיקר כשהחוף פופולרי בסערות של החורף וברוחות מערביות אין מקום בכלל לטעויות כשאתם מטרים ספורים מהכביש והבניינים שממול. בתל אביב כמו בתל אביב, אם תחרגו מהאזור המוגדר לגלישת קייט או שתגלשו פה במועדים שאינם מורשים לגלישה, יש מצב טוב לחטוף קנס מפקח. צפונית ודרומית לחוף המיועד לקייט יש חופי רחצה.בצפוניות המים מאוד פלאט והתחושה היא כמו לגלוש בלגונה. \n",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(
                        text:
                        "\n מתי מותר לגלוש כאן? אפריל עד אוקטובר – כל יום, לא כולל שישי שבת, חגים וערבי חג. חודשים נובמבר עד מרץ – כל יום, לא כולל שישי שבת, חגים וערבי חג. אך בפועל בתקופה זו אין ממש אכיפה בסופי שבוע לעומת התקופות האחרות. יולי אוגוסט – אסורה פעילות קייט בחוף.  ",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () => locate('locations', 'Spot_geula'),
                child: Stack(
                  children: [
                    Container(
                      width: 325,
                      height: 175,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          'lib/images/geolaSpot.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    buildFavoriteButton(
                        'geula', context), // Reuse the function here
                  ],
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(15),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(color: Colors.black, fontSize: 20),
                    children: <TextSpan>[
                      TextSpan(
                          text: "\n בת ים",
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold)),
                      TextSpan(
                        text:
                        "\n הספוטים באזור הם חוף הסלע וחוף תאיו, כאשר חוף תאיו הוא הפופולרי והעמוס יותר מבין שניהם.בדרומיות ומערביות החוף מאוד פופולרי מכיוון שהוא חוף רחב יחסיתהוא נחשב חוף שמתאים גם למתחילים מהבחינה הזו שיש מרחק שהם יכולים לרדת ברוח,אבל מבחינת הרוח בצפוניות, מדובר בחוף שהרוח נכנסת פחות חזק מחופים צפוניים יותר. \n",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () => locate('locations', 'Spot_batYam'),
                child: Stack(
                  children: [
                    Container(
                      width: 325,
                      height: 175,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          'lib/images/batyamSpot.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    buildFavoriteButton(
                        'batYam', context), // Reuse the function here
                  ],
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(15),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(color: Colors.black, fontSize: 20),
                    children: <TextSpan>[
                      TextSpan(
                          text: "\n אילת",
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold)),
                      TextSpan(
                        text:
                        "\n חוף הריף רף הוא הספוט הרשמי לגלישת קייט סרף באילת.הגלישה היא ברוח צפונית. בחורף גולשים כאן גם ברוח דרומית, אבל זה משהו שעושים בעיקר המקומיים ומי שלא מכיר טוב את הספוט, עדיף להימנע מזה. יוני עד ספטמבר זוהי התקופה הטובה ביותר ואפשר לצפות לרוח כמעט כל יום. גם בשאר השנה יש כאן לא מעט ימי רוח.למתחילים אילת היא מעבדה ומקום להתקדם בו משמעותית יותר מהר ממה שיתקדמו אם ישארו לתרגל רק בים התיכון. מי שלא יודע לחדד, יצטרך להכנס רק עם הרשמה לחילוץ ולקבוע עם סירה שתאסוף אותו בסוף הסשן במורד הרוח.\n",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () => locate('locations', 'Spot_eilat'),
                child: Stack(
                  children: [
                    Container(
                      width: 325,
                      height: 175,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          'lib/images/eilatSpot.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    buildFavoriteButton(
                        'eilat', context), // Reuse the function here
                  ],
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(15),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(color: Colors.black, fontSize: 20),
                    children: <TextSpan>[
                      TextSpan(
                          text: "\n סיני",
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold)),
                      TextSpan(
                          text:
                          "\n סיני הינו ספוט מאוד מומלץ גם למתחילים.בסיני יש שני ספוטים מרכזיים הראשון בדאב והשני בבלו לגין.הספוט בדהב הינו לגונה היושבת בצמוד למלון טירנה למתחילים יש את הלגונה, הלגונה עובדת משעות הבוקר המוקדמות ועד השעה אחת בצהריים כיין שיש שפל, ולאנשים מקצועיים יותר שיודעים כבר לחדד אפשר לצאת לים הפתוח שצמוד ללגונה . ישנם שלושה בתי ספר של קייט גם השכרת ציוד(מתחילים לא יכולים להשכיר ציוד) שימו לב מתחילים- נא לא לצאת לים הפתוח,אין סירות חילוץ! הבלו לאגון לעומת זה עובד מהשעות המוקדמות של הבוקר כל היום, .\n",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () => locate('locations', 'Spot_dahab'),
                child: Stack(
                  children: [
                    Container(
                      width: 325,
                      height: 175,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          'lib/images/dahabSpot.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    buildFavoriteButton(
                        'dahab', context), // Reuse the function here
                  ],
                ),
              ),
              SizedBox(height: 20),
              InkWell(
                onTap: () => locate('locations', 'Spot_sinai'),
                child: Stack(
                  children: [
                    Container(
                      width: 325,
                      height: 175,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          'lib/images/blueSpot.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    buildFavoriteButton(
                        'sinai', context), // Reuse the function here
                  ],
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(15),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(color: Colors.black, fontSize: 20),
                    children: <TextSpan>[
                      TextSpan(
                          text: "\n כנרת-דיאמונד",
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold)),
                      TextSpan(
                          text:
                          "\n הוא נמצא בחלק המזרחי של הכנרת והכניסה היא דרך מלון סטאי החדש, הכנרת עובדת מסוף מאי ועד תחילת ספטמבר עם רוח דרום-מערבית/מערבית שנכנסת בשעות הצהריים. מדובר בספוט שיכול להיות די מסוכן. אין כאן חול, הכל אבנים וסלעים גם בחוף וגם בתוך המים. כל תקלה ותאונה יכולה להגמר אחרת לגמרי מחופים פתוחים וחוליים כמו שיש בים התיכון. \n",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () => locate('locations', 'Spot_seaofGalilee'),
                child: Stack(
                  children: [
                    Container(
                      width: 325,
                      height: 175,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          'lib/images/kinertSpot.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    buildFavoriteButton(
                        'seaofGalilee', context), // Reuse the function here
                  ],
                ),
              ),
              SizedBox(height: 20),
            ]),
          ),
        ),
      ),
    );
  }
}