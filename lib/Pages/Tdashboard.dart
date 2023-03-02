import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vidyalayaapp/Pages/classNotification.dart';
import 'package:vidyalayaapp/Pages/create_coure.dart';
import 'package:vidyalayaapp/Pages/images.dart';
import 'package:vidyalayaapp/Pages/login_page.dart';
import 'package:vidyalayaapp/Pages/Tclasspage.dart';
import 'package:vidyalayaapp/Pages/size_config.dart';

class TDashboard extends StatefulWidget {
   TDashboard(this.name) : super();
  final String name;
  
  @override
  _TDashboardState createState() => _TDashboardState();
}
  

class _TDashboardState extends State<TDashboard> {

 
  String _classcode='';

Future clearToken()async{
   final FirebaseAuth _auth = FirebaseAuth.instance;
   final User? user = _auth.currentUser;
   final userid = user?.uid; 
  FirebaseFirestore.instance.collection('tokens').doc(userid).delete();
}

  Widget buildStreamBuilder(images imagelist){
  Size size = MediaQuery.of(context).size;
  final FirebaseAuth _auuth = FirebaseAuth.instance;
  final User? user = _auuth.currentUser;
  final cuserID = user?.uid;  
    return StreamBuilder<QuerySnapshot> (
                      stream: FirebaseFirestore.instance.collection('class').where('created-by',isEqualTo: cuserID).orderBy('created_time').snapshots(),
                       builder: (BuildContext context, snapshot){   
                          if(!snapshot.hasData){
                            return const Text('No data');
                          }
                          if(snapshot.hasData&&snapshot.data!.docs.isEmpty){
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 60),
                              child: Column(
                              children: [
                                Transform.rotate(
                                  angle: 50,
                                  child: Icon(Icons.book,
                                  color: Colors.black87.withOpacity(0.2),
                                  size: size.width*0.4,
                                  ),
                                ),
                                SizedBox(height: size.height*0.02),   
                                Text(
                                    'No classes created yet',
                                    style: GoogleFonts.ubuntu(
                                      color: Colors.black87,
                                    // fontWeight: FontWeight.bold,
                                      fontSize: size.width*0.05
                                    ),
                                  ),
                                SizedBox(height: size.height*0.01),   
                                TextButton(
                                  onPressed:(){
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const createCLass()));
                                  },
                                  child:Text(
                                    'Create Class',
                                    style: TextStyle(
                                      shadows:const [
                                          Shadow(
                                              color: Colors.black,
                                              offset: Offset(0, -7))
                                        ],
                                      decoration: TextDecoration.underline,
                                      color: Colors.transparent,
                                      decorationColor: Colors.black,
                                      decorationThickness: 3,
                                      fontWeight: FontWeight.bold,
                                      fontSize: size.width*0.05
                                    ),
                                  ),
                                ),
                              ],
                          ),
                            );       
                          }
                          if(snapshot.connectionState==ConnectionState.waiting)
                             {return  const CircularProgressIndicator();}
                          else   {
                             return SingleChildScrollView(
                                      child: ListView.builder(physics:const NeverScrollableScrollPhysics(),
                                                              shrinkWrap: true,
                                                              itemCount: snapshot.data?.docs.length,
                                                              itemBuilder: (context, i ){
                                                                return MaterialButton(
                                                                  padding: EdgeInsets.symmetric(vertical: 0.7*SizeConfig.heightMultiplier),
                                                                  textColor: Colors.white,
                                                                  splashColor: Colors.black,
                                                                   child: Container(
                                                                    height: SizeConfig.isMobilePortrait==true?24.0*SizeConfig.heightMultiplier:
                                                                            28.0*SizeConfig.heightMultiplier,
                                                                    width: MediaQuery.of(context).size.width,
                                                                    decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(5),
                                                                    image: DecorationImage(
                                                                          image: AssetImage(imagelist.myimagelist[i],),
                                                                          colorFilter:const ColorFilter.mode(Colors.black38, BlendMode.darken),
                                                                          fit: BoxFit.fill,),
                                                                    ),
                                                                      child: Column(children:<Widget> [
                                                                         Flexible(
                                                                           child: Align(
                                                                             alignment: Alignment.topLeft,
                                                                             child: Padding(
                                                                               padding: const EdgeInsets.symmetric(vertical: 10,horizontal:10),
                                                                               child: Text("${snapshot.data?.docs[i]['Subject-name']}",
                                                                                    style: TextStyle(
                                                                                          fontWeight: FontWeight.w600,
                                                                                          fontSize: 2.7*SizeConfig.textMultiplier,
                                                                                    ),
                                                                               ),
                                                                             ),
                                                                           ),
                                                                         ),
                                                                         Flexible(
                                                                           child: Align(
                                                                             alignment: Alignment.bottomLeft,
                                                                             child: Padding(
                                                                               padding: const EdgeInsets.symmetric(vertical: 10,horizontal:10),
                                                                               child: Text("${snapshot.data?.docs[i]['createdby(name)']}",
                                                                                    style: TextStyle(
                                                                                          fontWeight: FontWeight.w600,
                                                                                          fontSize: 1.8*SizeConfig.textMultiplier,
                                                                                ),
                                                                               ),
                                                                             ),
                                                                           ),
                                                                         ),
                                                                        ],)
                        
                                                                  ),
                                                                  onPressed: () {
                                                                   Navigator.push(
                                                                      context, MaterialPageRoute(
                                                                        builder: (context)=> TclassPage(
                                                                          "${snapshot.data?.docs[i]['Class-name']}",
                                                                          "${snapshot.data?.docs[i]['Subject-name']}",
                                                                          "${snapshot.data?.docs[i]['class-code']}",
                                                                          "${snapshot.data?.docs[i]['Section-name']}",
                                                                          "${snapshot.data?.docs[i]['createdby(name)']}",
                                                                          imagelist.myimagelist[i],
                                                                          "${snapshot.data?.docs[i]['created-by']}",
                                                                          "${snapshot.data?.docs[i]['allow_comment']}"
                                                                          ),
                                                                   ));
                                                                  },
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
    Size size = MediaQuery.of(context).size;
    return Scaffold( 
        appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black,size: 2.5*SizeConfig.heightMultiplier),
        backgroundColor: Colors.transparent,
        title: Text('Class',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 2.5*SizeConfig.textMultiplier),),
          elevation:0),
        drawer:  SizedBox(
          width: SizeConfig.isMobilePortrait==true?70.0*SizeConfig.widthMultiplier:
                 50.0*SizeConfig.widthMultiplier,
          child: Drawer (
              child: Column(
              children:<Widget>[
                SizedBox(
                  height: 23.0*SizeConfig.heightMultiplier,
                  child: DrawerHeader(
                      decoration:const BoxDecoration(
                        color: Colors.black,
                        image: DecorationImage(
                        image: AssetImage(
                            'assets/images/teacherdrawer.jpg'),
                        fit: BoxFit.fill,
                      ),
                      ),
                      child: Padding(
                        padding:const EdgeInsets.symmetric(vertical: 5),
                          child:  Align(
                            alignment: Alignment.bottomLeft,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children:<Widget>[
                                     Align(
                                       alignment: Alignment.bottomLeft,
                                       child: Text(
                                       "welcome,",
                                    style: TextStyle(
                                        fontSize: 1.8*SizeConfig.textMultiplier,
                                        color: Colors.black
                                    ),
                                    ),
                                     ),
                                  Stack(
                                    children: [
                                     Align(
                                       alignment: Alignment.bottomLeft,
                                       child: Text(
                                           widget.name,
                                             style: TextStyle(
                                              fontSize: 2.0*SizeConfig.textMultiplier,
                                              fontWeight: FontWeight.bold,
                                               color: Colors.black,
                                                 ),
                                               ),
                                     ),
                                             
                                           ], 
                                       ),
                              ],
                            ),
                          ),
                        
                      ),
                  ),
                ),
                SizedBox(height: SizeConfig.isMobilePortrait==true?0.0*SizeConfig.textMultiplier:
                                  1.0*SizeConfig.textMultiplier),
                ListTile(
                  title: Text('Create Class',
                        style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 1.9*SizeConfig.textMultiplier,
                      ),),
                   leading:const Icon(Icons.book_online,
                               color:Colors.black,
                            ),   
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> createCLass()));
                  },
                ),
                SizedBox(height: SizeConfig.isMobilePortrait==true?0.0*SizeConfig.textMultiplier:
                                  1.0*SizeConfig.textMultiplier),
                ListTile(
                  title: Text('Class Notification',
                        style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize:1.9*SizeConfig.textMultiplier,
                      ),),
                  leading: Icon(Icons.access_alarm_sharp,
                               color:Colors.black,  
                            ),
                  onTap: () {
                   showDialog(
                    context: this.context,
                    builder: (context) {
                   return AlertDialog(
                      backgroundColor: Colors.black,
                      title: Text('Which class do you want to modify?',
                      style: GoogleFonts.firaSans(
                        fontSize:17,
                        color:Colors.white60,
                        fontWeight: FontWeight.w400
                      )
                      ),
                      content: TextField(
                        cursorWidth: 1,
                        keyboardType: TextInputType.emailAddress,
                        style:const TextStyle(
                          color: Colors.white70
                        ),
                        autofocus: true,
                                onChanged: (value) {
                                  this._classcode = value;
                                },
                                decoration:const InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.fromLTRB(15, 8, 0, 0),
                                hintText:'class code',
                                hintStyle: TextStyle(
                                  color: Colors.white60
                                  )
                                )
                              ),
                              
                      actions: <Widget>[
                        TextButton(
                        onPressed: () async{
                        final FirebaseAuth _auth = FirebaseAuth.instance;
                        final User? user = _auth.currentUser;
                        final userID = user?.uid;
                        final QuerySnapshot snap = await FirebaseFirestore.instance.collection('class').where('class-code',isEqualTo: _classcode).get();
                        final List<DocumentSnapshot> docs=snap.docs;
                        if(docs.length!=0){
                        DocumentSnapshot<Object?>? userDoc=docs.last;
                        if (this._classcode==null) {
                          return;
                        }
                        else if(userDoc['class-code']==_classcode){
                           Navigator.of(this.context).push(MaterialPageRoute(builder: (context)=> classNotificationpage(userDoc['class-code'])));
                        }
                        }
                        else return;
                      },
                      child:const Text('Next')),
                      ],
                    );
                    },
                    );
                  },
                ),
                SizedBox(height: SizeConfig.isMobilePortrait==true?0.0*SizeConfig.textMultiplier:
                                  1.0*SizeConfig.textMultiplier),
                ListTile(
                  title: Text('Sign Out',
                  style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 1.9*SizeConfig.textMultiplier,
                      ),),
                   leading:const Icon(Icons.logout,
                               color:Colors.red,             
                            ),   
                  onTap: () {
                    final FirebaseAuth _auth = FirebaseAuth.instance;
                    _auth.signOut();
                    clearToken();
                     Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
                   },
                ),
              ],
            ),
      ),
        ),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          child: Stack(
            children: <Widget>[
              SizedBox(
                height:size.height,
                width:size.width,
               child: SingleChildScrollView(
                 physics: const BouncingScrollPhysics(parent:  AlwaysScrollableScrollPhysics()),
                 padding: EdgeInsets.symmetric(
                   horizontal: 2.8*SizeConfig.widthMultiplier,
                   vertical: 3.0*SizeConfig.widthMultiplier,
                  ),
                 child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                     buildStreamBuilder(images()),
                    // const SizedBox(height: 100),
                    ],
                  ),
                 ),
               ),
            ],
          ),
        ),
      ),
      //drawer
       
   );
  }
}