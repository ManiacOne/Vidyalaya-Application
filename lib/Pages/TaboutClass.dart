import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vidyalayaapp/Pages/size_config.dart';


class aboutTclass extends StatefulWidget {
  const aboutTclass(this.classname,this.subject,this.code,this.section,this.createdby) : super();
  final String classname;
  final String subject;
  final String code;
  final String section;
  final String createdby;

  @override
  _aboutTclassState createState() => _aboutTclassState();
}

class _aboutTclassState extends State<aboutTclass> {

bool isenabled=false;
final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
      super.initState();
      checkSwitch();
  }

  checkSwitch()async{
    QuerySnapshot snap= await FirebaseFirestore.instance.collection('class').where('class-code',isEqualTo: widget.code).get();
    List<DocumentSnapshot> docs=snap.docs;
    DocumentSnapshot<Object?>userdoc=docs.last;
    if(userdoc['allow_comment']=='enable'){
      isenabled=true;
      setState(() {});
    }
    else if(userdoc['allow_comment']=='disable'){
      isenabled=false;
      setState(() {});
    }
  }

  Widget switchbtn(){
   return  Transform.scale(
     scale: 0.11*SizeConfig.heightMultiplier,
     child: Switch(       activeColor: Colors.lightBlue,
                          activeTrackColor:Colors.white30,
                          inactiveThumbColor:Colors.grey[300],
                          inactiveTrackColor:Colors.white30,
                          value: isenabled,
                          onChanged:( value)async{
                            final User? cuser = _auth.currentUser;
                            final uid = cuser?.uid;
                            QuerySnapshot snap= await FirebaseFirestore.instance.collection('class').where('class-code',isEqualTo: widget.code).where('created-by',isEqualTo: uid).get();
                            final List<DocumentSnapshot> docs=snap.docs;
                            if(docs.length!=0){
                           // DocumentSnapshot<Object?>? userDoc=docs.last;
                            for(var  snapshot in docs){
                            var documentID= snapshot.id;
                            print(documentID);
                            setState(() {
                              isenabled = value;
                               });
                               if (isenabled == true) {
                                FirebaseFirestore.instance.collection('class').doc(documentID).update({'allow_comment': 'enable'});
                              }
                            else if(isenabled ==false){
                              FirebaseFirestore.instance.collection('class').doc(documentID).update({'allow_comment': 'disable'});
                            }
                            }
                            }   
                           }
                          ),
   );        
  }

  Widget classInfo(){
    Size size = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children:[
        Text('The details provided here were given by the creator of this class.',
            textAlign:TextAlign.left ,
            style: GoogleFonts.firaSans(
             color: Colors.white70,
             fontWeight: FontWeight.w400,
            fontSize:2.5*SizeConfig.textMultiplier,)),
        SizedBox(height: 2.0*SizeConfig.heightMultiplier),
         Row(
           children: [
             Text('Classname :   ',
             style: GoogleFonts.firaSans(
             color: Colors.white70,
               fontWeight: FontWeight.w500,
               fontSize: 2.5*SizeConfig.textMultiplier,
              ),
             ),
             Text(
               widget.classname,
             style: GoogleFonts.firaSans(
             color: Colors.white70,
               fontWeight: FontWeight.normal,
               fontSize: 2.5*SizeConfig.textMultiplier,
              ),
             ),
           ],
         ),
         SizedBox(height: 1.5*SizeConfig.heightMultiplier),
         Row(
           children: [
             Text('Subject :   ',
             style: GoogleFonts.firaSans(
             color: Colors.white70,
               fontWeight: FontWeight.w500,
               fontSize: 2.5*SizeConfig.textMultiplier,
              ),
             ),
             Text(widget.subject,
             style: GoogleFonts.firaSans(
             color: Colors.white70,
               fontWeight: FontWeight.normal,
               fontSize: 2.5*SizeConfig.textMultiplier,
              ),
             ),
           ],
         ),
         SizedBox(height: 1.5*SizeConfig.heightMultiplier),
         Row(
           children: [
             Text('Section :   ',
             style: GoogleFonts.firaSans(
              color: Colors.white70,
               fontWeight: FontWeight.w500,
               fontSize: 2.5*SizeConfig.textMultiplier,
              ),
             ),
             widget.section==''?
             Text("None",
             style: GoogleFonts.firaSans(
             color: Colors.white70,
               fontWeight: FontWeight.normal,
               fontSize: 2.5*SizeConfig.textMultiplier,
              ),
             ):
             Text(widget.section,
             style: GoogleFonts.firaSans(
             color: Colors.white70,
               fontWeight: FontWeight.normal,
               fontSize: 2.5*SizeConfig.textMultiplier,
              ),
             ),
           ],
         ),
         SizedBox(height: 1.5*SizeConfig.heightMultiplier),
         Row(
           children: [
             Text('Created by :   ',
             style: GoogleFonts.firaSans(
            color: Colors.white70,
               fontWeight: FontWeight.w500,
               fontSize: 2.5*SizeConfig.textMultiplier,
              ),
             ),
             Flexible(
               child: Text(widget.createdby,
               style: GoogleFonts.firaSans(
             color: Colors.white70,
                 fontWeight: FontWeight.normal,
                 fontSize: 2.5*SizeConfig.textMultiplier,
                ),
               ),
             ),
           ],
         ),
         SizedBox(height:  1.5*SizeConfig.heightMultiplier),
         Row(
           children: [
             Text('Class Code :   ',
             style: GoogleFonts.firaSans(
            color: Colors.white70,
               fontWeight: FontWeight.w500,
               fontSize: 2.5*SizeConfig.textMultiplier,
              ),
             ),
             Expanded(
               child: Text(widget.code,
               style: GoogleFonts.firaSans(
             color: Colors.white70,
                 fontWeight: FontWeight.normal,
                 fontSize:2.5*SizeConfig.textMultiplier,
                ),
               ),
             ),
            IconButton(
            icon:const Icon(
              Icons.copy
            ),
            tooltip: 'copy to clipboard',
            iconSize: 3.0*SizeConfig.textMultiplier,
            color: Colors.green,
            onPressed: () {
              Clipboard.setData(ClipboardData(text: widget.code));
              Fluttertoast.showToast(msg: "Code Copied");
            },
             ),
           ],
         ),
         SizedBox(height: 4.0*SizeConfig.heightMultiplier,),
         const Divider(
                thickness: 1,
                color: Colors.orange,
              ),
         SizedBox(height: 2.0*SizeConfig.heightMultiplier,),
         Column(
          children:<Widget>[
             Text(
                'If you do not want the enrolled users to add messages in your class, you can enable the switch..    ',
               style: GoogleFonts.firaSans(
            color: Colors.white70,
                 fontWeight: FontWeight.w400,
                 fontSize:2.5*SizeConfig.textMultiplier,
                ),
               ),
              const SizedBox(height: 15,),
              Row(
                children: [
                   Text(
               ' Disable/Enable',
               style: GoogleFonts.firaSans(
            color: Colors.white70,
                 fontWeight: FontWeight.w500,
                 fontSize: 2.5*SizeConfig.textMultiplier,
                ),
               ),
               const SizedBox(width: 15,),
               switchbtn()
                ],
              )
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
      backgroundColor: Colors.black,
       title:Text('About Class',style: TextStyle(
         fontSize: 2.5*SizeConfig.textMultiplier
       ),)),
       body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector( 
          child: Stack(
            children: <Widget>[
              SizedBox(
                  height:size.height,
                  width:size.width ,
                  child: SingleChildScrollView(
                        physics:const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()), 
                        padding: EdgeInsets.symmetric(
                        horizontal: 5.0*SizeConfig.widthMultiplier,
                        vertical: 4.5*SizeConfig.widthMultiplier,
                     ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        classInfo(),
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

