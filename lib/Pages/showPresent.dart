import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class showPresent extends StatefulWidget {
  const showPresent(this.code, this.date) : super();
  final String date;
  final String code;
  @override
  _showPresentState createState() => _showPresentState();
}

class _showPresentState extends State<showPresent> {

  Widget titleheader(){
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("Present  ",
            style: GoogleFonts.firaSans(
                        fontSize: 25,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                     )
            ),
            const Divider(
              thickness: 2, 
               color: Colors.black, 
                height: 30, 
              ),
          ],
        ),
      ),
    );
  }

 Widget presenties(){
    return StreamBuilder<QuerySnapshot> (
                      stream: FirebaseFirestore.instance.collection('attendance').where('class-code',isEqualTo: widget.code ).where('date',isEqualTo: widget.date).snapshots(), 
                      builder: (BuildContext context, snapshot){   
                         if(!snapshot.hasData){
                            return  Text('No user was present',
                                        style:TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25,
                                          color: Colors.amber,
                                        ) ,    
                                     );        
                         }
                          if(snapshot.connectionState==ConnectionState.waiting)
                             return  CircularProgressIndicator();
                          else   {
                             return  ListView.builder(
                                shrinkWrap: true,
                                physics: ClampingScrollPhysics(),
                                itemCount: snapshot.data?.docs.length,
                                itemBuilder: (context, i) {
                                  return Column(
                                    children: [
                                      ...snapshot.data?.docs[i]['present'].map((roll)=>
                                      Card( 
                                        child: ListTile(
                                        title: Text(roll,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                ),
                                        trailing: Icon(
                                          Icons.check_box,
                                          color: Colors.green
                                        )
                                            ),
                                      ),
                                      ),
                                      
                                    ],
                                  );
                                },
                              );
                          }
                      }
          );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        backgroundColor: Colors.black,
       ),
       body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          child: Stack(
            children: <Widget>[
              Container(
                height:double.infinity,
                width:double.infinity ,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF9E9E9E),
                      Color(0xFF757575),
                      Color(0xFF616161),
                      Color(0xFF424242),
                      Color(0xFF212121),
                    ]
                  )
                ),
               child: SingleChildScrollView(
                 physics: const BouncingScrollPhysics(parent:  AlwaysScrollableScrollPhysics()),
                 padding: EdgeInsets.symmetric(
                   horizontal: 10,
                   vertical: 10,
                  ),
                 child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      titleheader(),
                        presenties(),
                    ],
                  ),
                 ),
               ),
            ],
          ),
        ),
      ),
    );
  }
}