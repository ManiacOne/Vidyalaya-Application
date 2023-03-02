import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vidyalayaapp/Pages/Tclasspage.dart';

class markAttendance extends StatefulWidget {
  const markAttendance(this.classname,this.subject,this.code,this.section,this.createdby ,this.date,this.image,this.createdbyid,this.allowcomment) : super();
  final String classname;
  final String subject;
  final String code;
  final String section;
  final String createdby;
  final String date;
  final String image;
  final String createdbyid;
  final String allowcomment;
  
  @override
  _markAttendanceState createState() => _markAttendanceState();
}

class _markAttendanceState extends State<markAttendance> {

 List<String> presentRoll = [];
 String date='';
 final TextEditingController dateController = new TextEditingController();

Future submitauth()async{
   final QuerySnapshot snap= await FirebaseFirestore.instance.collection('attendance').where('class-code',isEqualTo: widget.code).get();
   final List<DocumentSnapshot> docs=snap.docs;
               if(docs.length!=0){
                 DocumentSnapshot<Object?>? userDoc=docs.last;
                 if (userDoc['date']==widget.date) {
                    Fluttertoast.showToast(msg: "Already Submitted");
                     Navigator.pop(context);
                  }            
                 else
                { buildloadAttendance();
                Navigator.pushReplacement(this.context, MaterialPageRoute(
                builder: (BuildContext context) =>
                TclassPage(widget.classname,widget.subject,widget.code,widget.section,widget.createdby,widget.image,widget.createdbyid,widget.allowcomment)));
                }
               }
               else
                { buildloadAttendance();
                Navigator.pushReplacement(this.context, MaterialPageRoute(
                builder: (BuildContext context) =>
                TclassPage(widget.classname,widget.subject,widget.code,widget.section,widget.createdby,widget.image,widget.createdbyid,widget.allowcomment)));
                }
              
}

Widget buildlistheader(){
    return Card( 
        child: ListTile(
        title: Text('Roll Number', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        trailing: Text("Mark", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      )
      );
   
  }

Widget getroll(){
  return StreamBuilder<QuerySnapshot> (
                      stream: FirebaseFirestore.instance.collection('class').where('class-code',isEqualTo: widget.code ).snapshots(), 
                      builder: (BuildContext context, snapshot){   
                         if(!snapshot.hasData){
                            return  Text('no Data');        
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
                                      ...snapshot.data?.docs[i]['enrolled-roll'].map((roll)=>
                                      Card( 
                                        child: ListTile(
                                        title: Text(roll),
                                        trailing: this.presentRoll.contains(roll) ?const Padding(
                                          padding: EdgeInsets.symmetric(horizontal:15 ),
                                          child: Icon(
                                                    Icons.check,
                                                    color: Colors.green
                                                    ),
                                                  ):
                                                  const Padding(
                                                    padding: EdgeInsets.symmetric(horizontal:15 ),
                                                    child: Icon(Icons.clear,
                                                    color: Colors.redAccent,
                                                    ),
                                                  ),
                                                onTap: () {
                                                  if(this.presentRoll.contains(roll)){
                                                    this.presentRoll.remove(roll);
                                                  }
                                                  else{
                                                    this.presentRoll.add(roll);
                                                  }
                                                  setState(() {
                                                    
                                                  });
                                                },
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

Future buildloadAttendance()async{
  await FirebaseFirestore.instance.collection('attendance').add({
      'class-code': widget.code,
      'present': presentRoll,
      'date':widget.date,
    });
     Fluttertoast.showToast(msg: "Submitted Succesfully");
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
                    buildlistheader(),
                    getroll(),
                    ],
                  ),
                 ),
               ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
              floatingActionButton: Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: FloatingActionButton.extended(
                      backgroundColor: const Color(0xff03dac6),
                      foregroundColor: Colors.black,
                      onPressed: () {
                        submitauth();
                      },
                      label: Text('SUBMIT',
                              style: TextStyle(
                              color: Color(0xFF212121),
                              fontSize: 22,
                              fontWeight: FontWeight.bold
                               ),
                              ),
                    ),
     ),
    );
  }
}