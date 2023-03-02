import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vidyalayaapp/Pages/showPresent.dart';
import 'package:vidyalayaapp/Pages/size_config.dart';

class viewAttendance extends StatefulWidget {
  const viewAttendance(this.code) : super();

   final String code;

  @override
  _viewAttendanceState createState() => _viewAttendanceState();
}

class _viewAttendanceState extends State<viewAttendance> {

  List<String> presentRoll = [];

  Widget showdates(){
      Size size=MediaQuery.of(context).size;
      return StreamBuilder<QuerySnapshot> (
                      stream: FirebaseFirestore.instance.collection('attendance').where('class-code',isEqualTo: widget.code).snapshots(),
                      builder: (BuildContext context, snapshot){   
                        if(!snapshot.hasData){
                            return const Text(
                                  'Not yet marked');}
                         if(snapshot.hasData&&snapshot.data!.docs.isEmpty){
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 24.0*SizeConfig.heightMultiplier,horizontal: 10),
                            child: Column(
                              children: [
                                Transform.rotate(
                                  angle: 50,
                                  child: Icon(Icons.date_range,
                                  color: Colors.black87.withOpacity(0.2),
                                  size: 15.0*SizeConfig.heightMultiplier,
                                  ),
                                ),
                                SizedBox(height: size.height*0.02,),
                                Text('The class creator has not yet marked any attendances. Please consult with your class creator for further information.',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.ubuntu(
                                  color: Colors.black54,
                                  fontSize: 2.3*SizeConfig.textMultiplier,
                                ),
                                ),
                              ],
                            ),
                          );
                         }
                          if(snapshot.connectionState==ConnectionState.waiting)
                             return  CircularProgressIndicator();

                          else{
                            return SingleChildScrollView(
                                      child: ListView.builder(physics: NeverScrollableScrollPhysics(),
                                                              shrinkWrap: true,
                                                              itemCount: snapshot.data?.docs.length,
                                                              itemBuilder: (context, i ){
                                                                    return  Card( 
                                                                            child: ListTile(
                                                                            tileColor: Colors.black87,
                                                                            title: Text("  ${snapshot.data?.docs[i]['date']}",
                                                                                        style: TextStyle(
                                                                                        fontSize: 2.5*SizeConfig.textMultiplier,
                                                                                        fontWeight: FontWeight.bold,
                                                                                        color: Colors.white54
                                                                                      ),
                                                                                    ),
                                                                            trailing:const Padding(
                                                                            padding:EdgeInsets.symmetric(horizontal:15 ),
                                                                           child: Icon(
                                                                                  Icons.arrow_forward_ios,
                                                                                  color: Colors.blue
                                                                                 ),
                                                                                ),  
                                                                            onTap: () {
                                                                            Navigator.push(
                                                                            context, MaterialPageRoute(
                                                                            builder: (context)=> showPresent(widget.code,"${snapshot.data?.docs[i]['date']}")));
                                                                                    },
                                                                                ),
                                                                          );
                                                }
                                          ),
                                        );
                          }
                             
                          }
                         
       );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Attendance',style: TextStyle(
          color: Colors.black,
          fontSize: 2.5*SizeConfig.textMultiplier,fontWeight: FontWeight.bold),),
       ),
       body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          child: Stack(
            children: <Widget>[
              SizedBox(
                height:double.infinity,
                width:double.infinity,
               child: SingleChildScrollView(
                 physics: const BouncingScrollPhysics(parent:  AlwaysScrollableScrollPhysics()),
                 padding: EdgeInsets.symmetric(
                   horizontal: 2.5*SizeConfig.widthMultiplier,
                   vertical: 2.2*SizeConfig.heightMultiplier,
                  ),
                 child: Column(
                   // mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                        showdates(),
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