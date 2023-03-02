import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class roughui extends StatefulWidget {
  const roughui({ Key? key }) : super(key: key);

  @override
  _roughuiState createState() => _roughuiState();
}



class _roughuiState extends State<roughui> {
final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
       backgroundColor: Colors.black,
       title:Text('COURSES')),
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
                
              ),
            ],  
          ),
        ),
     ),
    );
   }
}