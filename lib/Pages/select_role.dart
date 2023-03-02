import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
//import 'package:js/js.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vidyalayaapp/Pages/Tsigniup_page.dart';
import 'package:vidyalayaapp/Pages/login_page.dart';
import 'package:vidyalayaapp/Pages/Ssignup_page.dart';
import 'package:vidyalayaapp/Pages/size_config.dart';

class SelectRole extends StatefulWidget {
  const SelectRole({ Key? key }) : super(key: key);

  @override
  _SelectRoleState createState() => _SelectRoleState();
}

class _SelectRoleState extends State<SelectRole> {
  
  ImageProvider? roleImage;

  @override
  void didChangeDependencies()async {
    roleImage=const AssetImage("assets/images/rolebackground.jpg",);
    await precacheImage(roleImage!, context);
    super.didChangeDependencies();
  }

  Widget buildTeacherbtn(){
    return Container(
    width: SizeConfig.isMobilePortrait==true?50.0*SizeConfig.widthMultiplier:
     40.0*SizeConfig.widthMultiplier,
     height: SizeConfig.isMobilePortrait==true?55:
    6.4*SizeConfig.heightMultiplier,
    child: ElevatedButton(
      onPressed: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=> teacherSignupScreen()));
      },
      child:const Text(
        'Teacher',
        style: TextStyle(
          color: Color(0xff212121),
          fontSize: 25,
          fontWeight: FontWeight.bold,
           fontFamily: 'Montserrat',
        ),
      ),
       style: ElevatedButton.styleFrom(
              primary: Colors.cyan[300],
              onPrimary: Colors.orange,
              elevation: 5,
	    ),
    )
    );

  }

 Widget buildStudentbtn(){
  Size size = MediaQuery.of(context).size;
    return Container(
    width: SizeConfig.isMobilePortrait==true?50.0*SizeConfig.widthMultiplier:
     40.0*SizeConfig.widthMultiplier,
     height: SizeConfig.isMobilePortrait==true?55:
    6.4*SizeConfig.heightMultiplier,
    child: ElevatedButton(
      onPressed: () {
         Navigator.of(context).push(MaterialPageRoute(builder: (context)=> studentSignupScreen()));
       },
      child:const Text(
        'Student',
        style: TextStyle(
          color: Color(0xff212121),
          fontSize: 25,
          fontWeight: FontWeight.bold,
           fontFamily: 'Montserrat',
        ),
      ),
       style: ElevatedButton.styleFrom(
              primary: Colors.cyanAccent[700],
              onPrimary: Colors.orange,
              elevation: 3,
	    ),
    )
    );

 }

Widget buildloginBtn(context){
  Size size = MediaQuery.of(context).size;
  return GestureDetector(
    onTap: (){
      Navigator.of(context).push(MaterialPageRoute(builder: (context)=> LoginScreen()));
    },
    child: RichText(
      text: TextSpan( 
        children: [
          TextSpan(
            text: 'Already have an Account?',
            style: TextStyle(
              color: Colors.white,
              fontSize:SizeConfig.isMobilePortrait==true? 1.9*SizeConfig.textMultiplier:
               1.3*SizeConfig.textMultiplier,
              fontWeight: FontWeight.w400
            )
          ),
          TextSpan(
            text: ' Login',
            style: TextStyle(
              color: Colors.lightBlueAccent,
              fontSize:SizeConfig.isMobilePortrait==true? 2.2*SizeConfig.textMultiplier:
               1.9*SizeConfig.textMultiplier,
              fontWeight: FontWeight.bold
            )
          )
        ] 
        ),
    ),
  );
}
 
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar:AppBar(
       backgroundColor: Colors.transparent,
       elevation: 0,
       ) ,
        body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          child: Stack(
            children: <Widget>[
              ShaderMask(shaderCallback: (rect)=>
              const LinearGradient(
              begin: Alignment.center,
              end: Alignment.bottomCenter,
              colors: [Colors.black12,Colors.black38]
              ).createShader(rect),
              blendMode: BlendMode.darken,
              ),
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                child: Container(
                  height:size.height,
                  width:double.infinity ,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                    image:roleImage!, 
                    colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken),
                    fit: BoxFit.cover,
                    opacity: 0.9
                    )
                  ),
                 child: SingleChildScrollView(
                   physics:const BouncingScrollPhysics(parent:  AlwaysScrollableScrollPhysics(),),
                   padding:const EdgeInsets.symmetric(
                     horizontal: 25,
                     ),
                   child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: size.height*0.2),
                         Text( 
                          'Who are you?',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 3.5*SizeConfig.textMultiplier,
                            fontWeight: FontWeight.w700
                          ),
                        ),
                      SizedBox(height: size.height*0.05),
                      buildTeacherbtn(),
                      SizedBox(height: size.height*0.03),
                      buildStudentbtn(),
                       SizedBox(height: size.height*0.045),
                      buildloginBtn(context),
                    ],
                    ), 
                 ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Please provide a genuine role\n ',
                    style: GoogleFonts.ubuntu(
                      color: Colors.white,
                      fontSize: SizeConfig.isMobilePortrait==true?2.0*SizeConfig.textMultiplier:
                      1.5*SizeConfig.textMultiplier
                    ),
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