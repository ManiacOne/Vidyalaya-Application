
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vidyalayaapp/Pages/Sdashboard.dart';

class joinclass extends StatefulWidget {
  const joinclass({ Key? key }) : super(key: key);

  @override
  _joinclassState createState() => _joinclassState();
}



class _joinclassState extends State<joinclass> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _sdref = FirebaseFirestore.instance.collection('class');
  final _dref = FirebaseFirestore.instance.collection('users');
  final FirebaseAuth _auuth = FirebaseAuth.instance;

   String class_code=''; 
   String token= '';
   String roll= '';
   String name='';
   int enrolledlength=0;
   bool _joining=false;
   bool isInputEmpty=true;


Widget buildgivecode(){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
     const Align(
       alignment: Alignment.centerLeft,
       child: Padding(
         padding: EdgeInsets.symmetric(horizontal: 38),
         child: Text(
           'Class Code',
           style: TextStyle(
             color: Colors.white,
             fontSize: 20,
             fontWeight: FontWeight.bold
           ),
         ),
       ),
     ),
     SizedBox(height: 20),
     Container(
       alignment: Alignment.centerLeft,
       decoration: BoxDecoration(
         color: Colors.white,
         boxShadow: [
         BoxShadow(
           color: Colors.black26,
           blurRadius: 6,
           offset: Offset(0,2)
         )
    ]
       ),
       width: 300,
       child: ConstrainedBox(
        constraints: const BoxConstraints(
        maxHeight: 120.0,),
        child:TextFormField(
         maxLines: null,
         onChanged: (input){
         setState(() {
           class_code=input;
            if(class_code.isNotEmpty){
                 isInputEmpty=false;
            }
            else{
              isInputEmpty=true;
            }
            
            });
         },
         validator: (input)
          {   
              if(input==null|| input=='')
                 return ;
          },
         keyboardType: TextInputType.name,
         style: const TextStyle(
           color: Colors.black87
         ),
         decoration:const InputDecoration(
           fillColor: Colors.grey,
           filled: true,
            enabledBorder:  OutlineInputBorder(
            borderSide:  BorderSide(color: Colors.orange, width: 2.0),
             ),
           contentPadding: EdgeInsets.symmetric(vertical: 12.5, horizontal: 20),
           hintText:'enter class code',
           hintStyle: TextStyle(
             color: Colors.black38
             )
           )
       )
        ) 
     )
    ],
  );
}


Widget buildjoinbutton(){
  return Container(
     padding: EdgeInsets.symmetric(vertical: 25),
    width: 150,
    height: 100,
    child: IgnorePointer(
      ignoring: isInputEmpty,
      child: ElevatedButton(
        onPressed: () async {
          final FirebaseAuth _auuth = FirebaseAuth.instance;
          final User? user = _auuth.currentUser;
          final cuserID = user?.uid; 
          FirebaseMessaging.instance.getToken().then((value) {
                   token = value!;
                });
          bool validated=this._formKey.currentState?.validate()??false;
          if(!validated)
          return ;
          else if(validated)
          {   
              setState(() {
                _joining=true;
              });
            //get roll
            final User? user = _auuth.currentUser;
            final cuserID = user?.uid;  
            QuerySnapshot snap= await FirebaseFirestore.instance.collection('users').where('personal-id',isEqualTo: cuserID).get();
            final List<DocumentSnapshot> docs=snap.docs;
            if(docs.length!=0){
                DocumentSnapshot<Object?>? userDoc=docs.last;
                roll = userDoc['roll'];
                name = userDoc['name'];
             //update class with students enrolled
            var querySnapshots = await _sdref.where('class-code',isEqualTo: class_code).get();
            if(querySnapshots.docs.isNotEmpty)
            {
             var arraysnapshot = await _sdref.where('class-code',isEqualTo: class_code).where('enrolled-by',arrayContains: cuserID).get();//snapshot for checking already enrolled
             if(arraysnapshot.docs.isEmpty){
             enrolledlength=querySnapshots.docs.last['enrolled_length']; 
             print(enrolledlength);
             for(var  snapshot in querySnapshots.docs){
             var documentID= snapshot.id;
             _sdref.doc(documentID)
             .update({ 'enrolled-by': FieldValue.arrayUnion([cuserID]),
              'tokens': FieldValue.arrayUnion([token]),
              'enrolled-roll': FieldValue.arrayUnion([roll]),
              'enrolled_length': enrolledlength+1,
              });
             } 
             //update users enrolled-in
            final User? cuser = _auuth.currentUser;
            final userID = user?.uid;
            var snaps = await _dref.where('personal-id',isEqualTo: userID).get();
            for(var  snapshot in snaps.docs){
             var docid= snapshot.id;
            _dref.doc(docid).update({'enrolled-in': FieldValue.arrayUnion([class_code])})
            .then(
               (value) => Fluttertoast.showToast(msg: "Successfully Enrolled"),
             ); 
            }
             Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => SDashboard(name)));
             }
             else{
               Fluttertoast.showToast(msg: "Already Enrolled");
               setState(() {
            _joining=false;
              });
             }
            }
            else{
                 setState(() {
            _joining=false;
              });
             Fluttertoast.showToast(msg: "invalid code");
            }
            }
            else{
              return;
            }
           }
           else
             {
                setState(() {
            _joining=false;
              });
                return;
             }
         },

        child:_joining?
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
               Text("Joining...",
               style: TextStyle(
                 color: Colors.white,
                 fontSize: 20,
               ),
               ),
               SizedBox(width: 10,),
              SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                   color: Colors.white,
                ),
              ),
            ],
          ): 
        
        const Text(
          'JOIN',
          style: TextStyle(
            color: Color(0xFF212121),
            fontSize: 20,
            fontWeight: FontWeight.bold
          ),
        ),
         style: ElevatedButton.styleFrom(
                // color: isInputEmpty ? Colors.grey : Colors.black,
                primary: isInputEmpty ? Colors.white24: Colors.blueGrey,
                onPrimary: Colors.orange,
                elevation: 3,
	    ),
      ),
    ),
  );

}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xDD000000),
        ),
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
                 physics: AlwaysScrollableScrollPhysics(),
                 padding: EdgeInsets.symmetric(
                   horizontal: 10,
                   vertical: 10,
                  ),
                 child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 200),
                      Form(key:_formKey, child: Column(children: [
                     buildgivecode(),])),
                     buildjoinbutton(),
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