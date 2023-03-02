import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class teacherViewusers extends StatefulWidget {
  const teacherViewusers(this.code) : super();
  final String code;
  @override
  _teacherViewusersState createState() => _teacherViewusersState();
}

class _teacherViewusersState extends State<teacherViewusers> {

final _uref = FirebaseFirestore.instance.collection('users');
final _ref = FirebaseFirestore.instance.collection('class');
final TextEditingController _rolltext =new TextEditingController();
String _stuid = '';
String _roll='';
int arraylength=0;


void selectedItem(BuildContext context, item)async {
    switch (item) {
      case 0:
          showDialog(
            context: this.context,
                builder: (context) {
               return AlertDialog(
                 backgroundColor: Colors.black,
                  title: Text('Which user do you want to remove?',
                                    style: GoogleFonts.roboto(
                                      color: Colors.white,
                                    ),
                                    ),
                  content: TextField(
                    cursorWidth: 1,
                    keyboardType: TextInputType.emailAddress,
                    //autofocus: true,
                    controller: _rolltext,
                            onChanged: (value) {
                              this._roll = value;
                            },
                            decoration:
                            const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide:  BorderSide(color: Colors.orangeAccent),
                            ),
                            contentPadding: EdgeInsets.fromLTRB(15, 8, 0, 0),
                            hintText:'User roll/id',
                            hintStyle: TextStyle(
                              color: Colors.white70,
                              )
                            )
                          ),
                          
                  actions: <Widget>[
                    TextButton(
                    onPressed: () async{
                     print(_roll);
                    if(this._roll!=null){
                     final QuerySnapshot snap = await FirebaseFirestore.instance.collection('class').where('class-code',isEqualTo: widget.code).get();
                     final List<DocumentSnapshot> docs=snap.docs;
                     if(docs.length!=0){
                       final QuerySnapshot snaps = await FirebaseFirestore.instance.collection('users')
                       .where('enrolled-in',arrayContains: widget.code).where('roll',isEqualTo: this._roll).get();
                       final List<DocumentSnapshot> enrolldocs = snaps.docs;
                       DocumentSnapshot<Object?>? userDoc=docs.last;
                      if (enrolldocs.isEmpty) {
                        Fluttertoast.showToast(msg: "No enrolled user");
                        }
                     else{
                         DocumentSnapshot<Object?>? enrolleddocs=enrolldocs.last;
                         _stuid=enrolleddocs['personal-id'];
                              if(_stuid.isNotEmpty)
                                  {
                                  for(var  snapshot in docs){
                                  var documentID= snapshot.id;
                                  _ref.doc(documentID)
                                  .update({ 'enrolled-roll': FieldValue.arrayRemove([_roll]), 'enrolled-by':FieldValue
                                  .arrayRemove([_stuid])});
                                  }  
                                  for(var snapshots in enrolldocs){
                                    var docID = snapshots.id;
                                    _uref.doc(docID)
                                    .update({'enrolled-in': FieldValue.arrayRemove([widget.code])})
                                    .then(
                                  (value) => Fluttertoast.showToast(msg: "Successfully Removed"),
                                        );
                                   }
                                  }  
                         
                     }
                     }
                     else return;
                     Navigator.pop(context);
                     _rolltext.clear();
                      } 
                  },// end of onpressed
                  child: Text('Remove',
                          style: GoogleFonts.firaSans(
                            color: Colors.orange,
                            fontSize: 18,
                          )
                  )),
                    ]  
                    );
                   }
                );
        break;
        case 1 : 
              final QuerySnapshot snap = await FirebaseFirestore.instance.collection('class')
              .where('class-code',isEqualTo: widget.code).get();
              final QuerySnapshot snaps = await FirebaseFirestore.instance.collection('users')
              .where('enrolled-in',arrayContains: widget.code).get();
              final List<DocumentSnapshot> docs=snap.docs;
              final List<DocumentSnapshot> edocs=snaps.docs;
              if(snap.docs.isNotEmpty&&snaps.docs.isNotEmpty){
                 DocumentSnapshot<Object?>? userDoc=docs.last;
                 DocumentSnapshot<Object?>? eDoc=edocs.last;
                 var roll = userDoc['enrolled-roll'];
                 var id = userDoc['enrolled-by'];
                 if(roll!=null&&id!=null&&eDoc['enrolled-in']!=null){
                 showDialog(
                 context: this.context,
                 builder: (context) {
                 return AlertDialog(
                 backgroundColor: Colors.amber[50],
                  title: Text('Are you sure?'),
                  actions: <Widget>[
                    TextButton(
                    onPressed: () async{
                         for(var snapshot in docs){
                         var documentID = snapshot.id;
                         _ref.doc(documentID)
                         .update({'enrolled-roll': FieldValue.arrayRemove(roll), 'enrolled-by': FieldValue.arrayRemove(id)});
                       }
                       for(var snapsh in edocs){
                         var docID = snapsh.id;
                         _uref.doc(docID)
                         .update({'enrolled-in': FieldValue.arrayRemove([widget.code])})
                         .then((value) => Fluttertoast.showToast(msg: "Removed"));
                         Navigator.pop(context);
                       }
                      },
                  child: Text('YES')),
                    ]  
                    );
                   }
                );
              }
              else{
                Fluttertoast.showToast(msg: "No enrolled users");
              }
            }
            else{
                Fluttertoast.showToast(msg: "No enrolled users");
            }
            break;
    }
  }

Widget popbtn(){
  return PopupMenuButton<int>(
              color: Colors.black,
              itemBuilder: (context) => [
              const  PopupMenuItem<int>(
                  value: 0,
                  child: ListTile(
                   title: Text("Remove",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800
                      ),),
                  ),
                  ),
              const PopupMenuItem<int>(
                    value: 1,
                    child: ListTile(
                      title: Text("Remove All",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800
                      ),),
                    ),
                    ),
              ],
              onSelected: (item) => selectedItem(this.context, item),
            );
}   

Widget titleheader(){
    return  Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("ENROLLED  ",
            style: GoogleFonts.firaSans(
                        fontSize: 25,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                     )
            ),
            popbtn(),
          ],
        ),
      ),
    );
   
  }
  
  Widget showUsersAddOption(){
    Size size=MediaQuery.of(context).size;
    return StreamBuilder<QuerySnapshot> (
                      stream: FirebaseFirestore.instance.collection('class').where('class-code',isEqualTo: widget.code ).snapshots(), 
                      builder: (BuildContext context, snapshot){
                         if(!snapshot.hasData){
                            return 
                            const Text('no data',
                                        style:TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25,
                                          color: Colors.amber,
                                        ) ,    
                                     );        
                         }
                          if(snapshot.hasData&&snapshot.data!.docs.last['enrolled_length']==0){
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 10),
                            child: Column(children: [
                              Transform.rotate(
                                  angle: 00,
                                  child: Icon(Icons.people,
                                  color: Colors.black87.withOpacity(0.2),
                                  size: size.width*0.3,
                                  ),
                                ),
                                SizedBox(height: size.height*0.02,),
                                Text('There are no enrolled users yet in this class.',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.ubuntu(
                                  color: Colors.black54,
                                  fontSize: size.width*0.047,
                                ),
                                ),
                            ],)
                          );
                         }
                          if(snapshot.connectionState==ConnectionState.waiting)
                             return  CircularProgressIndicator();
                          else {
                             return  ListView.builder(
                                shrinkWrap: true,
                                physics: ClampingScrollPhysics(),
                                itemCount: snapshot.data?.docs.length,
                                itemBuilder: (context, i) {
                                  return Column(
                                    children: [
                                      ...snapshot.data?.docs[i]['enrolled-roll'].map((usersenrolled)=>
                                      Card( 
                                        child: ListTile(
                                        title: Text(usersenrolled,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                ),
                                        leading: Icon(Icons.person),
                                        
                                            ),
                                      ),
                                      ),
                                      
                                    ],
                                  );
                                },
                              );
                          }
                      }
          );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        backgroundColor: Colors.black,
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
                 physics: const BouncingScrollPhysics(parent:  AlwaysScrollableScrollPhysics()),
                 padding: EdgeInsets.symmetric(
                   horizontal: 10,
                   vertical: 10,
                  ),
                 child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      titleheader(),
                      const Divider(
                                thickness: 2, 
                                color: Colors.black, 
                                height: 30, 
                             ),
                      showUsersAddOption(),
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