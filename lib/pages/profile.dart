import 'package:flutter/material.dart';
import 'package:sign_in/pages/constants_profile.dart';
import 'package:sign_in/pages/QuickAccess.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final List<QuickAccess> recommendedJobs = [
    QuickAccess('Home', 'Home Screen',
        'assets/Home2.png', lightGreenColor),
    QuickAccess('About\nUs', 'About the devs', 'assets/About2.png',
        lightPurpleColor),
    QuickAccess('Buy us\na coffee', '🥤🥤🥤',
        'assets/Sponsor2.png', lightYellowColor),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 30.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Your\nPy",
                          style: TextStyle(
                            fontFamily: "Avenir",
                            fontWeight: FontWeight.w900,
                            fontSize: 28,
                            color: Color(0xff000000),
                          ),
                        ),
                        SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.only(right: 24.0),
                          child: LinearProgressIndicator(
                            value: 0.6,
                            backgroundColor: secondaryColor,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(primaryColor),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Profile Completeness",
                          style: TextStyle(
                            fontFamily: "Avenir",
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color: Color(0xff8d8d8d),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      image: DecorationImage(
                        image: Image.asset('assets/person.png').image,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 32),
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: primaryColor,
              ),
              
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  buildInfo('5', 'Completed\nJobs'),
                  Container(width: 1, height: 50, color: secondaryColor),
                  buildInfo('1', 'Remaining\nJob'),

                ],
              ),
            ),
            SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                "Quick Access",
                style: TextStyle(
                  fontFamily: "Avenir",
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  color: Color(0xff000000),
                ),
              ),
            ),
            SizedBox(height: 16),
            Container(
              height: 150,
              padding: EdgeInsets.only(left: 24),
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: recommendedJobs.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: (){
                        print("Hey $index");
                        // move to different page from here
                      },
                      child: Stack(
                        children: <Widget>[
                          Container(
                            width: 140,
                            padding: EdgeInsets.all(16),
                            margin: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: recommendedJobs[index].backgroundColor,
                                borderRadius: BorderRadius.circular(18)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(height: 16),
                                new Text(
                                  recommendedJobs[index].jobTitle,
                                  softWrap: true,
                                  style: TextStyle(
                                    fontFamily: "Avenir",
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    color: Color(0xff434343),
                                  ),
                                ),
                                SizedBox(height: 8),
                                new Text(
                                  recommendedJobs[index].jobLocation,
                                  softWrap: true,
                                  style: TextStyle(
                                    fontFamily: "Avenir",
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                    color: Color(0xff818181),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned.fill(
                              child: Align(
                                  alignment: Alignment.topRight,
                                  child: Image.asset(recommendedJobs[index]
                                      .companyImageSource))),
                        ],
                      ),
                    );
                  }),
            ),
            SizedBox(height: 16.0,),
            Container(
              height: 150.0,
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 32),
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: primaryColor,
                image: DecorationImage(
                    image: new AssetImage('assets/WhatsNew.png'),
                    fit: BoxFit.cover
                ),
              ),
              child: Container(
                margin: const EdgeInsets.all(30.0),
                padding: const EdgeInsets.all(10.0),  
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Text(
                  "What's New",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                    color: Colors.white
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      
    );
  }

  Padding buildInfo(String value, String description) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Text(
            value,
            style: TextStyle(
              fontFamily: "Avenir",
              fontWeight: FontWeight.w900,
              fontSize: 28,
              color: Color(0xffffffff),
            ),
          ),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: "Avenir",
              fontWeight: FontWeight.w500,
              fontSize: 12,
              color: Color(0xffffffff),
            ),
          ),
        ],
      ),
    );
  }
}
