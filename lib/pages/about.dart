import 'package:flutter/material.dart';
import 'package:sign_in/commons/custom_card.dart';
import 'package:sign_in/models/developer_info.dart';

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
                        image: NetworkImage('https://static.dribbble.com/users/3181935/screenshots/10598987/media/82ab7346bace7f63944f1ef3d2ee3210.jpg'),
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
                return CustomCard(
                  name: developers[index].name,
                  image: developers[index].imageLink,
                  subtitle: developers[index].otherInfo,
                  url: developers[index].gitLink,
                );
              },
            ),
          ),
        ],
      )
    );
  }
}
