import 'package:flutter/material.dart';
import 'package:sign_in/pages/about.dart';
import 'package:sign_in/pages/constants_profile.dart';
import 'package:sign_in/pages/QuickAccess.dart';
import 'package:sign_in/pages/new_process_page.dart';
import 'package:sign_in/services/AuthService.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final List<QuickAccess> recommendedJobs = [
    QuickAccess('Reports', 'Past records',
        'assets/Home2.png', lightGreenColor),
    QuickAccess('About\nUs', 'About the devs', 'assets/About2.png',
        lightPurpleColor),
    QuickAccess('Buy us\na coffee', '🥤🥤🥤',
        'assets/Sponsor2.png', lightYellowColor),
  ];
  final List<Widget> pages = [
    ProcessPage(),
    AboutUs(),
    AboutUs()
  ];
  dynamic name = ["User", 0];

  @override
  void initState() {
    super.initState();
    // name = gettingName();
    
    gettingName().then((data){
      setState(() {
        name = data;
      });
    });
  }

  gettingName() async {
    AuthService obj = AuthService();
    return await obj.getCurrentUserName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
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
                            "Hello ${name[0]}!",
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
                    buildInfo('${name[1]}', 'Completed\nJobs'),
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
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>pages[index]));
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
              InkWell(
                onTap: () {
                  _onButtonPressed(context);
                },
                child: Container(
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
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButton: FloatingActionButton(
        heroTag: 'fab',
        onPressed: () {
          Navigator.of(context).pop();
        },
        elevation: 5.0,
        tooltip: "Go back",
        child: Icon(Icons.arrow_back),
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


void _onButtonPressed(context){
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15.0),
    ),
    builder: (context) =>
      Container(
        height: MediaQuery.of(context).size.height / 2,
        decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: new BorderRadius.only(
                  topLeft: const Radius.circular(10.0),
                  topRight: const Radius.circular(10.0)
                )
        ),
        child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(height: 10.0,),
          Text(
            "What's New",
            style: TextStyle(
              color: Colors.black,
              fontSize: 25.0
            ),
          ),
          SizedBox(height: 10.0,),
          ListTile(
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            title: Text('Geo Tracking'),
            subtitle: Text(
              "See live on the map where the crop was detected",
              style: TextStyle(color: Colors.grey),  
            ),
            leading: Icon(Icons.pin_drop),
            onTap: () => Navigator.of(context).pop(),
          ),
          SizedBox(height: 10.0,),
          ListTile(
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            title: Text('Storage free'),
            subtitle: Text(
              "No image is stored on your phone. Everything is cloud-based!",
              style: TextStyle(color: Colors.grey),  
            ),
            leading: Icon(Icons.storage),
            onTap: () => Navigator.of(context).pop(),
          ),
          SizedBox(height: 10.0,),
          ListTile(
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            title: Text('Live Feed'),
            subtitle: Text(
              "See a live feed of your Rover on your app.",
              style: TextStyle(color: Colors.grey),  
            ),
            leading: Icon(Icons.live_tv),
            onTap: () => Navigator.of(context).pop(),
          ),
          SizedBox(height: 10.0,),
          ListTile(
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            title: Text('Optimised UI'),
            subtitle: Text(
              "A cleaner, optimized interface to navigate through the app.",
              style: TextStyle(color: Colors.grey),  
            ),
            leading: Icon(Icons.phone_iphone),
            onTap: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      )
  );
}