import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class viewUsers extends StatefulWidget {
  const viewUsers(this.code) : super();
  final String code;
  @override
  _viewUsersState createState() => _viewUsersState();
}

class _viewUsersState extends State<viewUsers> {

Widget titleheader(){
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
        child: Column(
          children: [
            Text("ENROLLED  ",
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
  
  Widget showUsers(){
    Size size=MediaQuery.of(context).size;
    return StreamBuilder<QuerySnapshot> (
                      stream: FirebaseFirestore.instance.collection('class').where('class-code',isEqualTo: widget.code ).snapshots(), 
                      builder: (BuildContext context, snapshot){   
                         if(!snapshot.hasData){
                          return  Text('no data',
                                        style:TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25,
                                          color: Colors.amber,
                                        ) ,    
                                     );        
                         }
                         if(snapshot.hasData&&snapshot.data!.docs.last['enrolled_length']==0){
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 10),
                            child: Column(children: [
                              Transform.rotate(
                                  angle: 00,
                                  child: Icon(Icons.people,
                                  color: Colors.black87.withOpacity(0.2),
                                  size: size.width*0.3,
                                  ),
                                ),
                                SizedBox(height: size.height*0.02,),
                                Text('There are no enrolled users yet in this class.',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.ubuntu(
                                  color: Colors.black54,
                                  fontSize: size.width*0.047,
                                ),
                                ),
                            ],)
                          );
                         }
                          if(snapshot.connectionState==ConnectionState.waiting)
                             return  CircularProgressIndicator();
                          else {
                             return  ListView.builder(
                                shrinkWrap: true,
                                physics: ClampingScrollPhysics(),
                                itemCount: snapshot.data?.docs.length,
                                itemBuilder: (context, i) {
                                  return Column(
                                    children: [
                                     
                                      ...snapshot.data?.docs[i]['enrolled-roll'].map((usersenrolled)=>
                                      Card( 
                                        child: ListTile(
                                        title: Text(usersenrolled,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                ),
                                        leading: Icon(Icons.person),
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
                        showUsers(),
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