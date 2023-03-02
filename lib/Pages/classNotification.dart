import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vidyalayaapp/Pages/Tdashboard.dart';

class classNotificationpage extends StatefulWidget {
  const classNotificationpage(this.code) : super();
  final String code;
  @override
  _classNotificationpageState createState() => _classNotificationpageState();
}

class _classNotificationpageState extends State<classNotificationpage> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _date='';
  String _hour='';
  String _min='';

  Widget timeBox(){
    return 
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
         Row(
           crossAxisAlignment: CrossAxisAlignment.center,
           children:<Widget>[
              Text('Enter Date: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                    ),
                    ),
                    Container(
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        offset: Offset(0,2)
                      )
                  ]
                    ),
                    width: 200,
                    height: 40,
                    child: TextFormField(
                      onChanged: (input){
                        this._date=input;
                      },
                      validator: (input)
                        {   
                            if(input==null|| input=='')
                              return 'Enter Date';
                        },
                      keyboardType: TextInputType.name,
                      style: TextStyle(
                        color: Colors.black87
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 12.5, horizontal: 20),
                        hintText:'yyyy-mm-dd',
                        hintStyle: TextStyle(
                          color: Colors.black38
                          )
                        )
                    )
                  )
           ], 
           ),
         SizedBox(height:20),
        Row(
          children:<Widget>[
             Text('Enter Time:',
             style: TextStyle(
               fontWeight: FontWeight.bold,
               fontSize: 20,
             ),
             
         ),
         SizedBox(width: 10),
             Container(
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        offset: Offset(0,2)
                      )
                  ]
                    ),
                    width: 100,
                    height: 40,
                    child: TextFormField(
                      onChanged: (input){
                        this._hour=input;
                      },
                      validator: (input)
                        {   
                            if(input==null|| input=='')
                              return 'Enter hour';
                        },
                      keyboardType: TextInputType.name,
                      style: TextStyle(
                        color: Colors.black87
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 12.5, horizontal: 20),
                        hintText:'24 hour',
                        hintStyle: TextStyle(
                          color: Colors.black38
                          )
                        )
                    )
                  ),
             SizedBox(width: 10),
             Container(
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        offset: Offset(0,2)
                      )
                  ]
                    ),
                    width: 90,
                    height: 40,
                    child: TextFormField(
                      onChanged: (input){
                        this._min=input;
                      },
                      validator: (input)
                        {   
                            if(input==null|| input=='')
                              return 'Enter min';
                        },
                      keyboardType: TextInputType.name,
                      style: TextStyle(
                        color: Colors.black87
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 12.5, horizontal: 20),
                        hintText:'minute',
                        hintStyle: TextStyle(
                          color: Colors.black38
                          )
                        )
                    )
                  ),
              ],
            ),
         ],
      );
  }

  Future submitdatetime()async{
      String time = _date+' '+_hour+':'+_min+':'+'00';
      DateTime dateTime =  DateTime.parse(time);
      Timestamp myTimeStamp = Timestamp.fromDate(dateTime);
      print(myTimeStamp); 
       final FirebaseAuth _auuth = FirebaseAuth.instance;
      final User? user = _auuth.currentUser;
      final cuserID = user?.uid;  
      QuerySnapshot snap = await FirebaseFirestore.instance.collection('users').where('personal-id',isEqualTo: cuserID).get();
      List<DocumentSnapshot> docs = snap.docs;
      if(docs.length!=0){
        DocumentSnapshot<Object?>? userDoc=docs.last;
         var querySnapshots = await FirebaseFirestore.instance.collection('class').where('class-code',isEqualTo: widget.code).get();
        for(var  snapshot in querySnapshots.docs){
        var documentID= snapshot.id;
        FirebaseFirestore.instance.collection('class').doc(documentID).update({'notification_time': myTimeStamp});
        Navigator.of(this.context).push(MaterialPageRoute(builder: (context)=> TDashboard(userDoc['name'])));
      }
    }
     
  }

  Widget submitbtn(){
    return Container(
     padding: EdgeInsets.symmetric(vertical: 25),
     width: 200,
     child: RaisedButton(
      elevation: 5,
      onPressed: () async {
        bool validated=this._formKey.currentState?.validate()??false;
        if(!validated)
        return;
        if(validated){
          submitdatetime();
        }
      },
      padding: EdgeInsets.all(15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15)   
      ),
      color: Colors.white,
      child: Text(
        'create',
        style: TextStyle(
          color: Color(0xFF212121),
          fontSize: 18,
          fontWeight: FontWeight.bold
        ),
      ),
    ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        backgroundColor: Colors.black,
        title:Text('Notify Students')),
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
               child: SingleChildScrollView(
                 physics: const BouncingScrollPhysics(parent:  AlwaysScrollableScrollPhysics()),
                 padding: EdgeInsets.symmetric(
                   horizontal: 10,
                   vertical: 10,
                  ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 150,horizontal: 20),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                              Form(key:_formKey, child: Column(children: [
                              timeBox(),])),
                              SizedBox(height: 50),
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