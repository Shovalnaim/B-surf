import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../components/func.dart';

class InfoPage extends StatefulWidget {
  static const String id = 'info_page';

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  // Define the URLs of the instructional videos
  final video1 = "https://www.youtube.com/watch?v=-n1R0hwEr6s&t=479s";
  final video2 = "https://www.youtube.com/watch?v=Vaa3RMTyxEg";
  final video3 = "https://www.youtube.com/watch?v=RtwkPeg8lO4";

  // Declare YoutubePlayerController instances for the videos
  late YoutubePlayerController _controller1;
  late YoutubePlayerController _controller2;
  late YoutubePlayerController _controller3;

  void initState() {
    // Convert video URLs to video IDs
    final IDviideo1 = YoutubePlayer.convertUrlToId(video1);
    final IDviideo2 = YoutubePlayer.convertUrlToId(video2);
    final IDviideo3 = YoutubePlayer.convertUrlToId(video3);

    // Initialize YoutubePlayerControllers with video IDs and settings
    _controller1 = YoutubePlayerController(
      initialVideoId: IDviideo1!,
      flags: YoutubePlayerFlags(autoPlay: false),
    );
    _controller2 = YoutubePlayerController(
      initialVideoId: IDviideo2!,
      flags: YoutubePlayerFlags(autoPlay: false),
    );
    _controller3 = YoutubePlayerController(
      initialVideoId: IDviideo3!,
      flags: YoutubePlayerFlags(autoPlay: false),
    );

    super.initState();
  }

  @override
  void dispose() {
    // Dispose of YoutubePlayerControllers when the page is disposed
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: gradientBoxDecoration, // Apply the gradientBoxDecoration
      child: Scaffold(
        appBar: AppBar(
          title: Text("C O U R S E"),
          backgroundColor: Colors.white70,
          centerTitle: true,
        ),
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.fromLTRB(8.0, 4.0, 0, 0.0),
          child: Container(
            child: Column(
              children: [
                // Lesson 1
                Container(
                  padding: EdgeInsets.all(15),
                  child: RichText(
                    textAlign: TextAlign.right,
                    text: TextSpan(
                      style: TextStyle(color: Colors.black, fontSize: 20),
                      children: <TextSpan>[
                        TextSpan(
                            text:
                            'תוכלו למצוא בארץ שני סוגים של קורסי קייט \n ',
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.bold)),
                        TextSpan(
                          text: "קלאסי\n ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        TextSpan(
                            text: "שמתבצע ב3 שיעורים בעלות: עד 2000 שקלים\n",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                          text: "ומורכב יותר \n",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        TextSpan(
                          text: "שמתבצע ב5 שעות קורס בעלות 3000 שקלים(מומלץ)\n",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: ":הרכבי השיעור הקלאסי\n",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline),
                        ),
                        TextSpan(
                          text: "הקורס מתחלק ל-3 שיעורים,שעתיים כל שיעור\n",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: "בשיעור הראשון\n",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline),
                        ),
                        TextSpan(
                          text:
                          "בחלקו הראשון של השיעור לומדים לימודי תאוריה על הרכב הקייט ,ידיעת כיוון הרוח , הכרת מנגנוני בטיחות(חשוב) , טכניקת שליטה על הקייט , הסבר מפורט על חוקי הגלישה. לרוב השיעור מתבצע בחלקו הרב ביבשה ולפעמים במידת שליטה בחומר נכנס לחלקו השני למים להרגשת הקייט ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 300,
                  height: 200,
                  child: YoutubePlayer(
                    controller: _controller1,
                    showVideoProgressIndicator: true,
                  ),
                ),

                // Lesson 2
                Container(
                  padding: EdgeInsets.all(15),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(color: Colors.black, fontSize: 20),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'השיעור שני \n',
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text:
                          "נחזור לשיעור קודם לרענון הידע ,ונלמד לייצר כוח מהקייט ואיך נשלוט בכוח הזה לטובת הגלישה,תלמדו לקרוא נתוני מסזג אוויר ועל פי זה לדעת מתי כדי לנו להגיע לחוף לפי תנאי מזג האוויר ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 300,
                  height: 200,
                  child: YoutubePlayer(
                    controller: _controller2,
                    showVideoProgressIndicator: true,
                  ),
                ),
                // Lesson 3
                Container(
                  padding: EdgeInsets.all(15),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(color: Colors.black, fontSize: 20),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'השיעור השלישי \n',
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                            text:
                            "לאחר שלמדנו את מנגנוני הבטיחות , הכרת הקייט והשליטה בו תעברו לשלב  \n- ",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                          text: 'Water Start\n',
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                            text:
                            'שלב העלייה לגלשן . בשלב זה תחברו את כל מה שלמדתם , אבל עכשיו עם גלשן ברגליים. בשלב זה תלמדו לייצר את הכוח הנכון בשביל עלייה לגלשן ואיך לעמוד נכון. ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 300,
                  height: 200,
                  child: YoutubePlayer(
                    controller: _controller3,
                    showVideoProgressIndicator: true,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(15),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(color: Colors.black, fontSize: 20),
                      children: <TextSpan>[
                        TextSpan(
                          text: "\n טיפ ממני \n",
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                            text:
                            "שחררו קצת את הבר, השענו לאחור , שימו לב להישענות על רגל אחורית, תסתכלו על המטרה ופשוט תהנו מהבריזה\n",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                          text:
                          "בקורס המורחב 2 השיעורים הבאים מיועדים לשיפור הגלישה",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}