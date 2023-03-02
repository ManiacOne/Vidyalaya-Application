import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vidyalayaapp/Pages/login_page.dart';
import 'package:vidyalayaapp/Pages/select_role.dart';
import 'package:vidyalayaapp/Pages/size_config.dart';

class welcomePage extends StatefulWidget {
  const welcomePage({ Key? key }) : super(key: key);

  @override
  _welcomePageState createState() => _welcomePageState();
}

class _welcomePageState extends State<welcomePage> {

  @override
  void didChangeDependencies() {
    precacheImage(const AssetImage('assets/images/loginbackground.jpg'), context);
    precacheImage(const AssetImage('assets/images/signupbackground1.jpg'), context);
    precacheImage(const AssetImage('assets/images/rolebackground.jpg'), context);
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          child: Stack(
            children: <Widget>[
              bodybackground(size),
              Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
              buildtext(),
           ],
           ),
           Padding(
             padding: EdgeInsets.only(bottom:5.0*SizeConfig.heightMultiplier),
             child: Align(
               alignment: Alignment.center,
               child: buildlowerbody(context),
             ),
                ),               
            ],
          ),
        ),
      ),  
    );
  }

  ShaderMask bodybackground(Size size) {
    return ShaderMask(
              shaderCallback: (rect)=>const LinearGradient(
                begin:Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent,Colors.black12,Colors.black87]).createShader(rect),
                blendMode: BlendMode.darken,
              child: Container(
                height:size.height,
                width:size.width ,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                  image: AssetImage('assets/images/welcomebackground.jpg'),
                  colorFilter: ColorFilter.mode(Colors.black12, BlendMode.darken),
                  fit: BoxFit.cover,
                  opacity: 0.9)
                ),
              ),
            );
  }

  Column buildlowerbody(BuildContext context) {
    return Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                          Text('Take your education to the next level\n Vidyalaya welcomes you to\n join our virtual space',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.ubuntu(
                            color:Colors.white,
                            fontSize: 2.2*SizeConfig.textMultiplier
                            ),), 
                          SizedBox(height: 5.0*SizeConfig.heightMultiplier,),
                          SizedBox(
                            width: SizeConfig.isMobilePortrait==true?42.0*SizeConfig.widthMultiplier:
                            30.0*SizeConfig.widthMultiplier,
                            height: SizeConfig.isMobilePortrait==true?45:
                            6.4*SizeConfig.heightMultiplier,
                            child: ElevatedButton(
                              onPressed: (){
                                   Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
                              },
                              child:Text(
                                'LOGIN',
                                style: GoogleFonts.montserrat(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 2.0*SizeConfig.textMultiplier
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                              primary: Colors.cyan[600],
                              onPrimary: Colors.orange,
                              elevation: 3,
                             ),
                            ),
                          ),
                          SizedBox(height: 1.0*SizeConfig.heightMultiplier,),
                          SizedBox(
                            width: SizeConfig.isMobilePortrait==true?42.0*SizeConfig.widthMultiplier:
                            30.0*SizeConfig.widthMultiplier,
                            height: SizeConfig.isMobilePortrait==true?45:
                            6.4*SizeConfig.heightMultiplier,
                            child: ElevatedButton(
                              onPressed: (){
                                   Navigator.of(context).push(MaterialPageRoute(builder: (context)=> SelectRole()));
                              },
                              child: Text(
                                'SIGNUP',
                                style: GoogleFonts.montserrat(
                                  color: Colors.black,
                                  fontSize: 2.0*SizeConfig.textMultiplier,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                              primary: Colors.cyan[300],
                              onPrimary: Colors.orange,
                              elevation: 3,
                              ),
                            ),
                        ), 
                       ],
                    );
  }

  Stack buildtext() {
    return Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 2.5*SizeConfig.widthMultiplier,
                  vertical:7.0*SizeConfig.heightMultiplier),
                  child: Text('Hello',
                      style: TextStyle(
                          fontSize: 11.5*SizeConfig.textMultiplier,
                           fontWeight: FontWeight.bold,
                           color:Colors.white54)),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 2.5*SizeConfig.textMultiplier,
                  vertical: 19.0*SizeConfig.heightMultiplier),
                  child: Text('There.',
                      style: TextStyle(
                          fontSize: 11.5*SizeConfig.textMultiplier,
                           fontWeight: FontWeight.bold,
                           color: Colors.white54)),
                ),
             ],
            );
  }
}