import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sign_in/commons/custom_card.dart';
import 'package:sign_in/models/developer_info.dart';
import 'package:sign_in/pages/Specific.dart';

class AboutUs extends StatefulWidget {
  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        children: <Widget>[
          SizedBox(height: 40.0,),
          Card(
            color: Colors.transparent,
            child: ClipPath(
              clipper: ShapeBorderClipper(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)
                ),
              ),
              child: Container(
                height: MediaQuery.of(context).size.height/4,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 40.0),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/aboutUs.png'),
                        fit: BoxFit.cover
                    )
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 20,),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            width: 3.0,
                          ),
                          borderRadius: BorderRadius.circular(20.0)
                      ),
                      child: Text(
                        "About Us",
                        style: TextStyle(
                            fontFamily: 'Lexend_Deca',
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 35.0
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: developers.length,
              itemBuilder: (context, index) {
                // return InkWell(
                //   onTap: (){
                    // Navigator.push(context, MaterialPageRoute(builder: (_)=>Specific(
                    //       info: developers[index],
                    //       i:index,
                    //       url: developers[index].gitLink,
                    //     )
                    //   )
                    // );
                //   },
                //   child: CustomCard(
                //     i:  index,
                //     name: developers[index].name,
                //     image: developers[index].imageLink,
                //     subtitle: developers[index].otherInfo,
                //     url: developers[index].gitLink,
                //   ),
                // );
                return SafeArea(
                        child: Column(
                          children: [
                            CupertinoButton(
                              child: Container(
                                height: 150,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage("assets/RoverDev$index.jpg"),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.fromLTRB(15, 15, 0, 0),
                                      child: Hero(
                                        tag: "Name$index",
                                        child: Material(
                                          type: MaterialType.transparency,
                                          child: Text(
                                            developers[index].name,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      // height: 50.0,
                                      // alignment: Alignment.centerLeft,
                                      margin: EdgeInsets.fromLTRB(0, 10, 15, 0),
                                      child: Hero(
                                        tag: "Profile$index",
                                        child: Material(
                                          type: MaterialType.transparency,
                                          child: CircleAvatar(
                                            backgroundImage: AssetImage(developers[index].imageLink),
                                            radius: 20.0,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (_)=>Specific(
                                      info: developers[index],
                                      i:index,
                                      url: developers[index].gitLink,
                                    )
                                  )
                                );
                              },
                            ),
                          ],
                        ),
                      );
              },
            ),
          ),
        ],
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
}
