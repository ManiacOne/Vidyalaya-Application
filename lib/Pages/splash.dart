import 'dart:async';
//import 'package:js/js.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:vidyalayaapp/Pages/Sdashboard.dart';
import 'package:vidyalayaapp/Pages/Tdashboard.dart';
import 'package:vidyalayaapp/Pages/login_page.dart';
import 'package:vidyalayaapp/Pages/welcomepage.dart';

class Splash extends StatefulWidget {
  const Splash({ Key? key }) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  @override
  void initState() {
    this.toHome();
    super.initState();
  }
  @override
  void didChangeDependencies() {
    precacheImage(const AssetImage('assets/images/welcomebackground.jpg'), this.context);
    precacheImage(const AssetImage('assets/images/a1.jpg'), this.context);
    precacheImage(const AssetImage('assets/images/a2.jpg'), this.context);
    precacheImage(const AssetImage('assets/images/a3.jpg'), this.context);
    precacheImage(const AssetImage('assets/images/a4.jpg'), this.context);
    super.didChangeDependencies();
  }

  String role='';
  String name='';

  void toHome()async{
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;
    final suserid = user?.uid; 
    QuerySnapshot snap = await FirebaseFirestore.instance.collection('users').where('personal-id',isEqualTo:suserid).get();
    List<DocumentSnapshot> docs=snap.docs;
    if(docs.isNotEmpty){
      DocumentSnapshot<Object?>? userDoc = docs.last;
      role = userDoc['role'];
      name = userDoc['name'];
    }
    Timer(const Duration(seconds: 5),(){
      if(FirebaseAuth.instance.currentUser ==null){
      Navigator.pushReplacement(this.context, MaterialPageRoute(builder: (context)=>welcomePage()));
      }
      else{
        if(role=='teacher'){
         Navigator.pushReplacement(this.context, MaterialPageRoute(builder: (context)=>TDashboard(name)));
      }
        if(role=='student'){
         Navigator.pushReplacement(this.context, MaterialPageRoute(builder: (context)=>SDashboard(name)));
      }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Stack(
          children: [
            Align(alignment: Alignment.center, child: Image.asset('assets/images/logovidyalayaa.png', width: 200, fit:BoxFit.contain, height: 200 ,)),
          Align(alignment: Alignment.bottomCenter, child: Padding(
            padding: const EdgeInsets.only(bottom: 50),
            child: Text('make in INDIA'),
          ))
          ],
        ),
      ),
    );
  }
}
