import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vidyalayaapp/Pages/login_page.dart';
import 'package:vidyalayaapp/Pages/size_config.dart';

class studentSignupScreen extends StatefulWidget {
  const studentSignupScreen({ Key? key }) : super(key: key);

  @override
  _studentSignupScreenState createState() => _studentSignupScreenState();
}



class _studentSignupScreenState extends State<studentSignupScreen> {
  
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _pass = TextEditingController();  
  final TextEditingController _confirmPass = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

   String email= ''; 
   String password= '';
   String name='';
   String roll='';
   String token='';
   bool _isloading=false;
  

Widget buildUsername() { 
  Size size = MediaQuery.of(context).size;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
     Container(
       alignment: Alignment.centerLeft,
       child: TextFormField(
         onChanged: (val){
           this.name=val;
         },
         validator: (input)
          {   
              if(input==null|| input=='')
                 return 'Enter Username';
              else if (!RegExp(
                  r"^[a-zA-Z0-9]").hasMatch(input))
               return 'Enter validate Username';
          },
         keyboardType: TextInputType.name,
         textInputAction: TextInputAction.next,
         style:const TextStyle(
           color: Colors.white70
         ),
         decoration: InputDecoration(
           border:const OutlineInputBorder(      
           borderSide: BorderSide(color: Colors.white60)),
           enabledBorder:const OutlineInputBorder(      
           borderSide: BorderSide(color: Colors.white60)), 
           focusedBorder:const OutlineInputBorder(
           borderSide: BorderSide(color: Colors.cyan)),
           contentPadding: EdgeInsets.symmetric(vertical: 1.8*SizeConfig.heightMultiplier),
            prefixIcon:  Icon(
               Icons.account_circle,
               color: Colors.white60,
               size: 2.4*SizeConfig.textMultiplier,
           ),
           hintText:'Full Name',
           hintStyle: TextStyle(
             color: Colors.white60,
             fontSize: 2.0*SizeConfig.textMultiplier,
             fontWeight: SizeConfig.isMobilePortrait==true?FontWeight.w500:FontWeight.w300
             )
           )
       )
     )
    ],
  );
}

Widget buildEmailid() {
  Size size = MediaQuery.of(context).size;
 return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
     Container(
       alignment: Alignment.centerLeft,
       child: TextFormField(
          validator: (input)
          {
         if (!RegExp(
             r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(input ?? ""))
            return 'Enter valid Email';
          },
         keyboardType: TextInputType.emailAddress,
         onChanged: (value) {
           email = value.toString().trim();
         },
         style:const TextStyle(
           color: Colors.white70
         ),
         decoration: InputDecoration(
           border:const OutlineInputBorder(      
           borderSide: BorderSide(color: Colors.white60)),
           enabledBorder:const OutlineInputBorder(      
           borderSide: BorderSide(color: Colors.white60)), 
           focusedBorder:const OutlineInputBorder(
           borderSide: BorderSide(color: Colors.cyan)),
           contentPadding: EdgeInsets.symmetric(vertical: 1.8*SizeConfig.heightMultiplier),
            prefixIcon: Icon(
               Icons.email,
               color: Colors.white60,
               size: 2.4*SizeConfig.textMultiplier,
            ),
           hintText:'Enter your email',
           hintStyle: TextStyle(
             color: Colors.white60,
             fontSize: 2.0*SizeConfig.textMultiplier,
             fontWeight: SizeConfig.isMobilePortrait==true?FontWeight.w500:FontWeight.w300
             )
           )
       )
     )
    ],
  );
}

Widget buildRollno(){
  Size size = MediaQuery.of(context).size;
return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
     Container(
       alignment: Alignment.centerLeft,
       child: TextFormField(
         onChanged: (val){
           this.roll=val;
         },
         validator: (input)
          {
              if(input==null||input=='')
                 return 'Enter Roll';
              else if (!RegExp(
                  r"^[a-zA-Z0-9]").hasMatch(input))
               return 'Enter validate Rollno';
          },
         keyboardType: TextInputType.emailAddress,
         style:const TextStyle(
           color: Colors.white70
         ),
         decoration: InputDecoration(
           border:const OutlineInputBorder(      
           borderSide: BorderSide(color: Colors.white60)),
           enabledBorder:const OutlineInputBorder(      
           borderSide: BorderSide(color: Colors.white60)), 
           focusedBorder:const OutlineInputBorder(
           borderSide: BorderSide(color: Colors.cyan)),
           contentPadding: EdgeInsets.symmetric(vertical: 1.8*SizeConfig.heightMultiplier),
            prefixIcon: Icon(
               Icons.account_circle,
               color: Colors.white60,
               size: 2.4*SizeConfig.textMultiplier,
           ),
           hintText:'Enter your roll',
           hintStyle: TextStyle(
             color: Colors.white60,
             fontSize: 2.0*SizeConfig.textMultiplier,
             fontWeight: SizeConfig.isMobilePortrait==true?FontWeight.w500:FontWeight.w300
             )
           )
       )
     )
    ],
  );
}

Widget buildPass() {
  Size size = MediaQuery.of(context).size;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
     Container(
       alignment: Alignment.centerLeft,
       child: TextFormField(
         controller: _pass,
         validator: (input){
            if(input!.isEmpty)
              {
                return "Enter password";
              }
              if (!RegExp(
             r"^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{6,}$").hasMatch(input))
             { return 'password must contain at least one letter, one number and one special character';
             }
           },
         obscureText: true,
         onChanged: (value){
           password = value;
         },
         style:const TextStyle(
           color: Colors.white70
         ),
         decoration: InputDecoration(
           border:const OutlineInputBorder(      
           borderSide: BorderSide(color: Colors.white60)),
           enabledBorder:const OutlineInputBorder(      
           borderSide: BorderSide(color: Colors.white60)), 
           focusedBorder:const OutlineInputBorder(
           borderSide: BorderSide(color: Colors.cyan)),
           contentPadding: EdgeInsets.symmetric(vertical: 1.8*SizeConfig.heightMultiplier),
           prefixIcon:  Icon(
               Icons.lock,
               color: Colors.white60,
               size: 2.4*SizeConfig.textMultiplier,
             ),
           hintText:'Create your Password',
           hintStyle: TextStyle(
             color: Colors.white60,
             fontSize: 2.0*SizeConfig.textMultiplier,
             fontWeight: SizeConfig.isMobilePortrait==true?FontWeight.w500:FontWeight.w300
             )
           )
       )
     )
    ],
  );
}

Widget buildConPass() {
  Size size = MediaQuery.of(context).size;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
     Container(
       alignment: Alignment.centerLeft,
       child: TextFormField(
        controller: _confirmPass,
         validator: (val){
            if(val==null)
              return 'Cannot be empty';
            if(val!= _pass.text)
               return 'Passwords do not match';
            return null;
         },
         obscureText: true,
         style:const TextStyle(
           color: Colors.white70
         ),
         decoration:  InputDecoration(
           border:const OutlineInputBorder(      
           borderSide: BorderSide(color: Colors.white60)),
           enabledBorder:const OutlineInputBorder(      
           borderSide: BorderSide(color: Colors.white60)), 
           focusedBorder:const OutlineInputBorder(
           borderSide: BorderSide(color: Colors.cyan)),
           contentPadding: EdgeInsets.symmetric(vertical: 1.8*SizeConfig.heightMultiplier),
           prefixIcon:const Padding(
             padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
             child: Icon(
               Icons.lock,
               color: Colors.white60
             ),
           ),
           hintText:'Confirm your Password',
           hintStyle: TextStyle(
             color: Colors.white60,
             fontSize: 2.0*SizeConfig.textMultiplier,
             fontWeight: SizeConfig.isMobilePortrait==true?FontWeight.w500:FontWeight.w300
             )
           )
       )
     )
    ],
  );
}

Widget buildProceedbtn(context) {
  Size size = MediaQuery.of(context).size;
  return Container(
    width: SizeConfig.isMobilePortrait==true?42.0*SizeConfig.widthMultiplier:
    35.0*SizeConfig.widthMultiplier,
    height: SizeConfig.isMobilePortrait==true?50:
    6.4*SizeConfig.heightMultiplier,
    child: ElevatedButton(
      onPressed: () async {
        setState(() {
          _isloading=true;
        });
        bool validated=this._formKey.currentState?.validate()??false;
        if(!validated)
        {
           setState(() {
          _isloading=false;
        });
        return;
        }
        try {
           FirebaseMessaging.instance.getToken().then((value) {
                 token = value!;
              });
          UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password
          );
          final User? user = _auth.currentUser;
          final suserid = user?.uid; 
            await FirebaseFirestore.instance.collection('users').add({
            'email':email,
            'name': this.name,
            'roll':this.roll,
            'role':'student',
            'personal-id': suserid,
            'token-id': token,
            'enrolled-in':[],
         });
           await FirebaseFirestore.instance.collection('student notification').doc(suserid).set({
             'value':'OFF',
           });
         Fluttertoast.showToast(msg: "Account created Successfully");
         await Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
        }
         on FirebaseAuthException catch (e) {
             _isloading = false;
             print(e);
             if (e.code == 'email-already-in-use') {
             print('The account already exists for that email.');
             ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.redAccent,
                content:Text('Account already exists for this email',
                              style: TextStyle(fontSize: 20.0),
                 )
                )
             );
              }
        }
         catch (e) {
         print(e);
          }
      },
      child:_isloading?
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             Text("Creating...",
             style: TextStyle(
               color: Colors.black,
               fontSize: 4.5*SizeConfig.widthMultiplier,
             ),
             ),
             SizedBox(width: 10,),
            SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                 color: Colors.black,
              ),
            ),
          ],
        ): 
       Text(
        'PROCEED',
        style: TextStyle(
          color: Color(0xFF212121),
          fontSize: SizeConfig.isMobilePortrait==true?5.0*SizeConfig.widthMultiplier:
          4.0*SizeConfig.widthMultiplier,
          fontWeight: SizeConfig.isMobilePortrait==true?FontWeight.bold:
          FontWeight.w500
        ),
      ),
       style: ElevatedButton.styleFrom(
              primary: Colors.cyan[300],
              onPrimary: Colors.orange,
              elevation: 3,
	    ),
    ),
  );
}
  
  
  @override
  Widget build(BuildContext context) {
  Size size = MediaQuery.of(context).size;
    return Scaffold(
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
                    decoration: const BoxDecoration(
                      image: DecorationImage(image: AssetImage('assets/images/signupbackground1.jpg'),
                      colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken),
                      fit: BoxFit.cover,
                      opacity:0.9
                      )
                    ),
                   child: SingleChildScrollView(
                     physics:const BouncingScrollPhysics(parent:  AlwaysScrollableScrollPhysics()),
                     padding:SizeConfig.isMobilePortrait==true?const EdgeInsets.symmetric(
                       horizontal: 25,
                       ):
                       const EdgeInsets.symmetric(
                       horizontal: 50,
                       ),
                     child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: size.height*0.1),
                        Text( 
                          'Create Account',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 4.0*SizeConfig.textMultiplier,
                            fontWeight: SizeConfig.isMobilePortrait==true?FontWeight.w400:
                            FontWeight.w400
                          ),
                        ),
                        SizedBox(height: size.height*0.05),
                        Form(key:_formKey, child: Column(children: [ buildUsername(), 
                         SizedBox(height: 1.7*SizeConfig.heightMultiplier),
                        buildEmailid(),
                        SizedBox(height: 1.7*SizeConfig.heightMultiplier),
                        buildRollno(),
                        SizedBox(height:1.7*SizeConfig.heightMultiplier),
                        buildPass(),
                        SizedBox(height: 1.7*SizeConfig.heightMultiplier),
                        buildConPass(),
                         SizedBox(height: 8.0*SizeConfig.heightMultiplier),
                        ],)),
                        
                        buildProceedbtn(context),
                       
                      ],
                      ), 
                   ),
                  ),
                ),
              ],
            ),
          ),
             ),
      // ),
    );
  }
}

