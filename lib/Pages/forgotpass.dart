import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vidyalayaapp/Pages/size_config.dart';

class forgotPassword extends StatefulWidget {
  const forgotPassword({ Key? key }) : super(key: key);

  @override
  _forgotPasswordState createState() => _forgotPasswordState();
}

class _forgotPasswordState extends State<forgotPassword> {

 final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
 final TextEditingController emailController = new TextEditingController();
 final FirebaseAuth _auth = FirebaseAuth.instance;
 String _email='';
 bool _isloading=false;

  Widget buildemail(){
    return SizedBox(
      child: TextFormField(
        autofocus: false,
         controller: emailController,
         onChanged:(val){
           _email=val;
         },
         keyboardType: TextInputType.emailAddress,
         validator: (input)
          {
         if (!RegExp(
             r"^[a-zA-Z0-9!#$%&'*+-/=?^_`@{|}~]").hasMatch(input ?? ""))
             {return 'Enter valid Email';}
          },
         style:const TextStyle(
           color: Colors.black87
         ),
         decoration: InputDecoration(
           contentPadding: EdgeInsets.symmetric(vertical: 1.8*SizeConfig.heightMultiplier),
           border:const OutlineInputBorder(
           borderSide: BorderSide(color: Colors.grey)),
           enabledBorder:const OutlineInputBorder(
           borderSide: BorderSide(color: Colors.grey)),
           focusedBorder:const OutlineInputBorder(
           borderSide: BorderSide(color: Colors.cyan)),
           prefixIcon: Icon(
             Icons.email,
             color: Colors.white54,
             size: 2.4*SizeConfig.heightMultiplier,
           ),
           hintText:'Email',
           hintStyle: TextStyle(
             color: Colors.white54,
             fontSize: 1.9*SizeConfig.textMultiplier
             )
         )
      ),
    );
  }

 Widget submitbtn(){
   return Container(
    width: SizeConfig.isMobilePortrait==true?40.0*SizeConfig.widthMultiplier:
    29.0*SizeConfig.widthMultiplier,
     height: 6.0*SizeConfig.heightMultiplier,
    child: ElevatedButton(
      onPressed: () async{
       bool validated=this._formKey.currentState?.validate()??false;
       if(!validated)return;
       else{
          if(_email.isNotEmpty){
          setState(() {
          _isloading=true;
        });
        _auth.sendPasswordResetEmail(email: _email);
        Fluttertoast.showToast(msg: "Link Sent");
        Navigator.pop(context);
       }
       }
      },
      child: _isloading?
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             Text("Sending link...",
             style: TextStyle(
               color: Colors.black,
               fontSize: 4.5*SizeConfig.widthMultiplier,
             ),
             ),
            const SizedBox(width: 10,),
            const SizedBox(
              height: 20,
              width: 20,
              child: Center(
                child: CircularProgressIndicator(
                   color: Colors.black,
                ),
              ),
            ),
          ],
        ):
         Text(
        'SUBMIT',
        style: TextStyle(
          color: const Color(0xff212121),
          fontSize: 2.0*SizeConfig.textMultiplier,
          fontWeight: FontWeight.bold
        ),
       ),
       style: ElevatedButton.styleFrom(
              primary: Colors.cyan[300],
              onPrimary: Colors.orange,
              elevation: 3,
	    ),
    )
  );
 }

  @override
  Widget build(BuildContext context) {
    Size size= MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black54,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
       backgroundColor: Colors.transparent,
       elevation: 0,
      ),
       body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          child: Stack(
            children: <Widget>[
              SingleChildScrollView(
                physics:const BouncingScrollPhysics(parent:  AlwaysScrollableScrollPhysics()),
                child: Container(
                  height:size.height,
                  width:size.width ,
                  padding:SizeConfig.isMobilePortrait==true?
                  EdgeInsets.symmetric(horizontal: 6.0*SizeConfig.widthMultiplier):
                  EdgeInsets.symmetric(horizontal: 8.0*SizeConfig.widthMultiplier),
                  decoration:const BoxDecoration(
                   image: DecorationImage(image: AssetImage('assets/images/forgotpassbackground.jpg'),
                   colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken),
                   fit: BoxFit.cover,
                   opacity: 0.9,
                   )
                  ),
                 child: SingleChildScrollView(
                   physics:const BouncingScrollPhysics(parent:  AlwaysScrollableScrollPhysics()),
                   child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:<Widget>[
                      SizedBox(height:13.0*SizeConfig.heightMultiplier),
                        Align(
                        alignment: Alignment.topLeft,
                        child: Text( 
                          'Forgot Password?',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 4.0*SizeConfig.textMultiplier,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(height: 7.0*SizeConfig.heightMultiplier),
                       Text('Please enter your registered Email below to get password reset instructions...',
                          style: TextStyle(
                            fontSize: 2.5*SizeConfig.textMultiplier,
                            color: Colors.grey[400],
                            fontWeight: FontWeight.w300
                          ),
                      ),
                      SizedBox(height: 5.0*SizeConfig.heightMultiplier),
                      Form(key:_formKey, child: Column(children: [buildemail()])),
                      SizedBox(height: 4.0*SizeConfig.heightMultiplier),
                      submitbtn(),
                    ],
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