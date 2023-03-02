import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timezone/timezone.dart'as tz;
import 'package:timezone/data/latest.dart'as tz;
import 'package:vidyalayaapp/Pages/size_config.dart';

FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();

class aboutClass extends StatefulWidget {
  const aboutClass(this.classname,this.subject,this.code,this.section,this.createdby) : super();
  final String classname;
  final String subject;
  final String code;
  final String section;
  final String createdby;
  @override
  _aboutClassState createState() => _aboutClassState();
}
 
bool isON=false;


class _aboutClassState extends State<aboutClass> {

  @override
  void initState(){
    tz.initializeTimeZones();
    initializeSetting();
    super.initState();
  }
  

  Widget switchbtn(){
   return  Transform.scale(
     scale: 0.11*SizeConfig.heightMultiplier,
     child: Switch(      activeColor: Colors.lightBlue,
                          activeTrackColor:Colors.white30,
                          inactiveThumbColor:Colors.grey[300],
                          inactiveTrackColor:Colors.white30,
                          value: isON,
                          onChanged:( value)async{
                            final FirebaseAuth _auth = FirebaseAuth.instance;
                            final User? Cuser = _auth.currentUser;
                            final uid = Cuser?.uid;
                            QuerySnapshot snap= await FirebaseFirestore.instance.collection('class').where('class-code',isEqualTo: widget.code).get();
                             final List<DocumentSnapshot> docs=snap.docs;
                            //if(docs.length!=0)
                             DocumentSnapshot<Object?>? userDoc=docs.last;
                            print(userDoc['notification_time']);
                            DateTime myDateTime = userDoc['notification_time'].toDate();
                            print(myDateTime); 
                            setState(() {
                              isON = value;
                               });
                               if (isON == true) {
                                displayNotification(myDateTime);
                                //FirebaseFirestore.instance.collection('student notification').doc(uid).update({'value': 'ON', 'class': widget.classname});
                              }
                            else if(isON ==false){
                             // FirebaseFirestore.instance.collection('student notification').doc(uid).update({'value': 'OFF'});
                            }   
                           }
                           
                         ),
   );        
  }

  Widget classInfo(){
    Size size = MediaQuery.of(context).size;
    return Column(
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
                'Enabling the switch will help you to get class notifications of this particular class..',
               style: GoogleFonts.firaSans(
            color: Colors.white70,
                 fontWeight: FontWeight.w400,
                 fontSize: 2.5*SizeConfig.textMultiplier,
                ),
               ),
              const SizedBox(height: 15,),
                 Row(
           children:<Widget>[
             Text('Class Notification   ',
             style: GoogleFonts.firaSans(
            color: Colors.white70,
               fontWeight: FontWeight.w500,
               fontSize: 2.5*SizeConfig.textMultiplier,
              ),
             ),
            switchbtn(),
           ],
         ),  
          ],
        ),
       
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              Container(
                  height:double.infinity,
                  width:double.infinity ,
                  decoration: const BoxDecoration(
                  gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                      Color(0xDD000000),
                      Color(0xDD000000),
                      Color(0xDD000000),
                      Color(0xDD000000),
                      Color(0xDD000000),
                    ]
                  )
                ),
               child: SingleChildScrollView(
                        physics:const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()), 
                         padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20,
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
  Future<void> displayNotification(DateTime time)async{
    notificationsPlugin.zonedSchedule(0, 
                                      'Your'+widget.classname, 
                                      'class is live', 
                                      tz.TZDateTime.from(time, tz.local), 
                                      NotificationDetails(
                                      android: AndroidNotificationDetails('channel id','channel name')), 
                                      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime, 
                                      androidAllowWhileIdle: true
                                );
                          }
 } 

void initializeSetting()async{
  var initializeAndroid = AndroidInitializationSettings('logovidyalayaa');
  var initializeSetting = InitializationSettings(android: initializeAndroid);
  await notificationsPlugin.initialize(initializeSetting);
}