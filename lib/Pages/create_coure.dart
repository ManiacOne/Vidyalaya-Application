import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';
import 'package:vidyalayaapp/Pages/Tdashboard.dart';

class createCLass extends StatefulWidget {
  const createCLass({ Key? key }) : super(key: key);

  @override
  _createCLassState createState() => _createCLassState();
}

class _createCLassState extends State<createCLass> {

   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
   final FirebaseAuth _auth = FirebaseAuth.instance;

  String classname= '';
  String subjectname='';
  String sectionname='';  
  bool _iscreating=false;  
 
 List a=[
     'assets/images/a1.jpg',
     'assets/images/a2.jpg',
     'assets/images/a3.jpg',
     'assets/images/a4.jpeg',
     'assets/images/a5.jpeg',
     'assets/images/a6.jpeg',
     'assets/images/a7.jpeg',
     'assets/images/a8.jpeg',
     'assets/images/a9.jpeg',
     'assets/images/a10.jpeg',
  ];
 
  Widget buildClassname(){
    Size size=MediaQuery.of(context).size;
    return Column(
   crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
     Container(
       alignment: Alignment.centerLeft,
       height: 60,
       child: TextFormField(
         onChanged: (val){
           this.classname=val;
         },
         validator: (input)
          {   
              if(input==null|| input=='')
                 {return 'class name cannot be empty';}
              else if (!RegExp(
                  r"^[a-zA-Z0-9]").hasMatch(input))
               {return 'Enter valid Class name';}
          },
         keyboardType: TextInputType.name,
         style:const TextStyle(
           color: Colors.black87
         ),
         decoration: InputDecoration(
           focusedBorder:const UnderlineInputBorder(
           borderSide: BorderSide(color: Colors.orange)),
           contentPadding:const EdgeInsets.only(top:15),
            prefixIcon:const Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Icon(
               Icons.auto_stories_outlined,
               color: Color(0xff212121)
           ),
            ),
           hintText:'class ',
           helperText: '',
           hintStyle: TextStyle(
             color: Colors.black54,
             fontSize: size.width*0.045, 
             )
           )
       )
     )
    ],
    );
  }
  
  Widget buildSubject(){
    Size size=MediaQuery.of(context).size;
    return Column(
     crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
     Container(
       alignment: Alignment.centerLeft,
       height: 60,
       child: TextFormField(
         onChanged: (val){
           this.subjectname=val;
         },
         validator: (input)
          {   
              if(input==null|| input=='')
                 return 'subject name cannot be empty';
              else if (!RegExp(
                  r"^[a-zA-Z0-9]").hasMatch(input))
               return 'Enter valid subject name';
          },
         keyboardType: TextInputType.name,
         style:const TextStyle(
           color: Colors.black87
         ),
         decoration: InputDecoration(
         focusedBorder:const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.orange)),
         contentPadding: EdgeInsets.only(top:15),
         prefixIcon:const Padding(
         padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
         child: Icon(
         Icons.auto_stories,
               color: Color(0xff212121)
           ),
            ),
           hintText:'subject',
           helperText: '',
           hintStyle: TextStyle(
             color: Colors.black54,
             fontSize: size.width*0.045,
             )
           )
       )
     )
    ],
    );
  }
  
  Widget buildCreateclassbtn(){ 
    Size size=MediaQuery.of(context).size;
    return Container(
     width: size.width*0.5,
     height: size.height*0.065,
    child: ElevatedButton(
      onPressed: () async {
        bool validated=this._formKey.currentState?.validate()??false;
        if(!validated)
        return;
       else{
          try {
             setState(() {
             _iscreating=true;
              });
              final User? user = _auth.currentUser;
              final userID = user?.uid;
              final QuerySnapshot snaps= await FirebaseFirestore.instance.collection('class').where('created-by', isEqualTo: userID).get();
              final QuerySnapshot snap= await FirebaseFirestore.instance.collection('users').where('personal-id', isEqualTo: userID).get();
              final List<DocumentSnapshot> docs=snap.docs;
              final List<DocumentSnapshot> cdocs = snaps.docs;
              print(cdocs.length);
              if(cdocs.length<10)
              {
                if(docs.length!=0){
              DocumentSnapshot<Object?>? userDoc=docs.last;
              var uuid=Uuid(); //uniqueid
              var v4 = uuid.v4();//random unique id
              sectionname.isEmpty?
              await FirebaseFirestore.instance.collection('class').add({
              'Class-name': this.classname,
              'Subject-name':this.subjectname,
              'Section-name':'',
              'created-by': userID,
              'class-code': v4,
              'createdby(name)': userDoc['name'],
              'enrolled-by': [],
              'enrolled-roll':[],
              'tokens':[],
              'notification_time':Timestamp.now(),
              'created_time':Timestamp.now(),
              'allow_comment':'disable',
              'enrolled_length':0,
                }):
               await FirebaseFirestore.instance.collection('class').add({
              'Class-name': this.classname,
              'Subject-name':this.subjectname,
              'Section-name':this.sectionname,
              'created-by': userID,
              'class-code': v4,
              'createdby(name)': userDoc['name'],
              'enrolled-by': [],
              'tokens':[],
              'notification_time':Timestamp.now(),
              'created_time':Timestamp.now(),
              'allow_comment':'disable',
              'enrolled_length':0,
              }); 
              
                Fluttertoast.showToast(msg: "Class created Successfully");
              await Navigator.of(context).push(MaterialPageRoute(builder: (context)=> TDashboard(userDoc['name'])));
                }
                else {
                  setState(() {
                    _iscreating=false;
                  });
                }
              }
              else{
              Fluttertoast.showToast(msg: "Cannot create, Limit Reached");
              }
             }
              on FirebaseAuthException catch (e) {
                 setState(() {
                  _iscreating=false;
                });
             print(e);
             if (!RegExp(
                  r"^[a-zA-Z0-9]").hasMatch(e.code)) {
                  print('invalid names');
             ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.redAccent,
                content:Text('invalid names',
                              style: TextStyle(fontSize: 20.0),
                 )
                )
             );
              }
        }
         catch (e) {
         print(e);
          }
       }
      },

      child: _iscreating?
      Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
             Text("Creating...",
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
        Text(
        'CREATE',
        style: TextStyle(
          color: Color(0xFF212121),
          fontSize: size.width*0.05,
          fontWeight: FontWeight.bold
        ),
      ),
      style: ElevatedButton.styleFrom(
              primary: Colors.blueGrey,
              onPrimary: Colors.orange,
              elevation: 3,
	    ),
    ),
  );
  }

  Widget buildSection(){
    Size size=MediaQuery.of(context).size;
    return Column(
       crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
     Container(
       alignment: Alignment.centerLeft,
       height: 60,
       child: TextFormField(
         onChanged: (val){
           this.sectionname=val;
         },
          validator: (input)
          {   
              if(input==null|| input=='')
                 return 'section name cannot be empty';
              else if (!RegExp(
                  r"^[a-zA-Z0-9](5)").hasMatch(input))
               return 'Enter valid section name';
          },
         keyboardType: TextInputType.name,
         style:const TextStyle(
           color: Colors.black87
         ),
         decoration: InputDecoration(
           focusedBorder:const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.orange)),
           contentPadding:const EdgeInsets.only(top:15),
           prefixIcon:const Padding(
             padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
             child: Icon(
               Icons.badge,
               color: Color(0xff212121)
             ),
           ),
           helperText: '',
           hintText:'section',
           hintStyle: TextStyle(
             color: Colors.black54,
             fontSize: size.width*0.045,
             ),
           )
       )
     )
    ],
   );
  }

  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
       backgroundColor:const Color(0xFF9E9E9E),
       elevation: 0,
       //title:const Text('Create Class')
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
                     Color(0xFF9E9E9E),
                      Color(0xFF757575),
                      Color(0xFF616161),
                      Color(0xFF424242),
                      Color(0xFF212121),
                    ]
                  )
                ),
               child: SingleChildScrollView(
                 physics:const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                 padding:const EdgeInsets.symmetric(
                   horizontal: 25,
                 ),
                 child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                  SizedBox(height:size.height*0.01 ),
                    Text( 
                      'Create Class',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: size.width*0.08,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    SizedBox(height: size.height*0.05),
                    Form(key:_formKey, child: Column(children: [ buildClassname(), 
                    SizedBox(height: size.width*0.04),
                    buildSubject(),
                    SizedBox(height: size.width*0.04),
                    ],)),
                    buildSection(),
                    SizedBox(height: size.width*0.08),
                    buildCreateclassbtn(),

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