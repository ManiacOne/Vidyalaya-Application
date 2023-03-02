import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:vidyalayaapp/Pages/aboutClass.dart';
import 'package:vidyalayaapp/Pages/additonalComment.dart';
import 'package:vidyalayaapp/Pages/expandedcommentPage.dart';
import 'package:vidyalayaapp/Pages/preview_image.dart';
import 'package:vidyalayaapp/Pages/services.dart';
import 'package:vidyalayaapp/Pages/size_config.dart';
import 'package:vidyalayaapp/Pages/viewAttendance.dart';
import 'package:vidyalayaapp/Pages/viewUsers.dart';

class SclassPage extends StatefulWidget {
 
  SclassPage(this.classname, this.subject, this.code, this.section, this.createdby,this.image,this.createdbyid,this.allowcomment):super(); 
  final String classname;
  final String subject;
  final String code;
  final String section;
  final String createdby;
  final String image;
  final String createdbyid;
  final String allowcomment;
  
  @override
  _TclassPageState createState() => _TclassPageState();
}


class _TclassPageState extends State<SclassPage> {

  final CollectionReference _uref = FirebaseFirestore.instance.collection('users');
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _textController = new TextEditingController();
  final TextEditingController _dialogtextController = new TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _message='';
  String _dialogmessage='';
  String _givenby='';
  String deliveredby='';
  File? file;
  UploadTask? task;
  File? imageTemp;
  bool _isInputempty=true;

Widget showtextfield(){
 return  Row(
             mainAxisAlignment: MainAxisAlignment.spaceAround,
             children: <Widget>[
             Form(key:_formKey, child: Column(children: [buildmssgbox(),])),
             Flexible(child:buildsendicon(),),
           ],
       );
 
}

Widget textBox(){
   return Container(
             width: 280,
       height: 35,
       child: TextFormField(
         controller: _dialogtextController,
         keyboardType: TextInputType.multiline,
         onChanged: (val) {
           this._dialogmessage = val.trim().toString();
         },
         style: TextStyle(
           color: Colors.black87
         ),
         decoration: InputDecoration(
         // border: InputBorder.none,
           contentPadding: EdgeInsets.only(top:0),
            prefixIcon:
                    Icon(
                    Icons.comment,
                    color: Color(0xff212121)
                    ),
              suffixIcon: IconButton(
                padding: EdgeInsets.symmetric(vertical: 1.1),
                icon: Icon(Icons.attachment),
                tooltip: 'add attachment',
                color: Color(0xff212121),
                onPressed: (){
                  selectFile();
                  },
                ),       
             hintText:'type your comment here...',
             hintStyle: TextStyle(
             color: Colors.black38,
             
           ),
         ),
       )
       
          );
 }

void selectedItem(BuildContext context, item) {
    switch (item) {
      case 0:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => aboutClass(widget.classname,widget.subject,widget.code,widget.section,widget.createdby)));
        break;
      case 1:
         setState(() {
          });
         Fluttertoast.showToast(msg: "Refreshed");
        break;
    }
  }

Widget popbtn(){
  return PopupMenuButton<int>(
              icon: Icon(Icons.more_vert_outlined,color: Colors.white,
              size: 2.8*SizeConfig.heightMultiplier),
              color: Colors.black,
              itemBuilder: (context) => [
               PopupMenuItem<int>(
                  value: 0,
                  child: ListTile(
                   title: Text("About class",
                  style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 2.0*SizeConfig.textMultiplier
                   ),),
                  // trailing: Icon(Icons.settings),
                  ),
                  ),
               PopupMenuItem<int>(
                    value: 1,
                    child: ListTile(
                      title: Text("Refresh",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 2.0*SizeConfig.textMultiplier
                   ),),
                    ),
                    ),
              ],
              onSelected: (item) => selectedItem(this.context, item),
            );
}

Widget selectbtn(){
      return Container(
            child: RaisedButton(
              padding: const EdgeInsets.all(20),
              textColor: Colors.white,
              color: Colors.blueGrey,
              onPressed: () {
                selectFile();
              },
              child: Text('Select file'),
           ),
          );
  }
  
Widget uploadbtn(){
   return Flexible(
     child: Container(
            child: RaisedButton(
              padding: const EdgeInsets.all(20),
              textColor: Colors.white,
              color: Colors.blueGrey,
              onPressed: () {
                uploadFile();
              },
              child: Text('Send'),
            ),
          ), 
     );
 }

Widget uploadStatus(UploadTask task) => 
 StreamBuilder<TaskSnapshot>(
   stream: task.snapshotEvents,
   builder: (context, snapshot){
     if (snapshot.hasData) {
       final uploadsnap = snapshot.data!;
       final progress = uploadsnap.bytesTransferred / uploadsnap.totalBytes;
       final uploadpercent = (progress*100).toStringAsFixed(2);
       return Text('$uploadpercent');
     }
     else{
       return Container();
     }
   }
   
   );

Future selectFile()async{
  final result = await FilePicker.platform.pickFiles(allowMultiple: false);
  if(result==null)
    return;
  
  final path = result.files.single.path!;
  setState(() {
    file = File(path);
    
  });
}

Future uploadFile()async{
  if (file==null) {
    Fluttertoast.showToast(msg: "No file selected");
    return;
  }
  if(_dialogmessage.isEmpty){
     return Fluttertoast.showToast(msg: "Type message");
 }
 else if(_dialogmessage.isNotEmpty){
  final fileName = basename(file!.path);
  final destination = 'files/$fileName';
  task = myFirebaseStorage.uploadFile(destination, file!);
  setState(() {});
  if (task==null) {
    return;
  }
   uploadStatus(task!);
  final snapshot = await task?.whenComplete(() => {});
  final url = await snapshot?.ref.getDownloadURL();
  print(url);
  final User? Cuser = _auth.currentUser;
   final uid = Cuser?.uid;
   final QuerySnapshot Usnap= await this._uref.where('personal-id', isEqualTo: uid).get();
               final List<DocumentSnapshot> Udocs=Usnap.docs;
               if(Udocs.length!=0){
                 DocumentSnapshot<Object?>? userDoc=Udocs.last;
                 _givenby=userDoc['name'];
                 }
    await FirebaseFirestore.instance.collection('comment').add({
           'url':url,
           'comment':_dialogmessage,
           'personal-id':uid,
           'givenby': _givenby,
           'class-code':widget.code,
           'length':0,
           'sent time': Timestamp.now(),
    });
    _dialogtextController.clear();
    //fileName.clear();
    Fluttertoast.showToast(msg: "Uploaded Succesfully");
    Navigator.pushReplacement(this.context, MaterialPageRoute(
      builder: (BuildContext context) =>
       SclassPage(widget.classname,widget.subject,widget.code,widget.section,widget.createdby,widget.image,widget.createdbyid,widget.allowcomment)));
        
 }  
    
}

Widget buildsendicon(){
   return 
      IgnorePointer(
       ignoring: _isInputempty,
       child: IconButton(
         iconSize: 5.0*SizeConfig.heightMultiplier,
         icon:const Icon(Icons.send),
         color: Colors.grey,
         onPressed: ()async{
            bool validated=this._formKey.currentState?.validate()??false;
            if(!validated)
                return;
            else if(_message!=''){
            final User? Cuser = _auth.currentUser;
            final uid = Cuser?.uid;
             _textController.clear();
            final QuerySnapshot Usnap= await this._uref.where('personal-id', isEqualTo: uid).get();
                 final List<DocumentSnapshot> Udocs=Usnap.docs;
                 if(Udocs.length!=0){
                   DocumentSnapshot<Object?>? userDoc=Udocs.last;
                   _givenby=userDoc['name'];
                   }
                   setState(() {
                     _isInputempty=true;
                   });
                   await FirebaseFirestore.instance.collection('comment').add({
                   'comment':_message,
                   'personal-id':uid,
                   'givenby': _givenby,
                   'class-code':widget.code,
                   'sent time': Timestamp.now(),
                   'url': 'None',
                   'length':0,
                  });
                 }
         else{
            Fluttertoast.showToast(msg: "Not a valid text!!");
              }
         },
       ),
     );
 }

Widget buildmssgbox(){
    return Column(
     children:<Widget> [
       Container(
       width: SizeConfig.isMobilePortrait==true?80.0*SizeConfig.widthMultiplier:
       85.0*SizeConfig.widthMultiplier,
       constraints: BoxConstraints(minHeight: 6.0*SizeConfig.heightMultiplier),
       decoration: BoxDecoration(
         color: Colors.grey,
         borderRadius: BorderRadius.circular(5),
         boxShadow:const [
           BoxShadow(
           color: Colors.black26,
         ),
        ],
       ),
       child: ConstrainedBox(
         constraints: const BoxConstraints(
         maxHeight: 120.0,),
         child: TextFormField(
           maxLines: null,
           controller: _textController,
           keyboardType: TextInputType.multiline,
           onChanged: (val) {
             val=_textController.text.toString();
             _message = val.trim().toString();
               if(_message.isNotEmpty){
                  _isInputempty=false;}
               else{
                 _isInputempty=true;}
           },
           style:const TextStyle(
             color: Colors.black87
           ),
           decoration: InputDecoration(
            border: InputBorder.none,
             contentPadding: EdgeInsets.symmetric(vertical:1.6*SizeConfig.heightMultiplier,
                              horizontal:2.5*SizeConfig.widthMultiplier),
               hintText:'type your message.....',
             hintStyle: TextStyle(
               color: Colors.black38,
             fontSize: 2.0*SizeConfig.textMultiplier,
             ),
             suffixIcon: IconButton(
                  padding: EdgeInsets.symmetric(horizontal:2.0*SizeConfig.widthMultiplier),
                  icon:const Icon(Icons.attachment),
                  tooltip: 'add attachment',
                  color:const Color(0xff212121),
                  onPressed: (){
                   showModalBottomSheet(
                     backgroundColor: Colors.transparent,
                     context: this.context,
                      builder:(builder)=> sheet());
                  },
                  )
              ),
         ),
       )
       
          ),
      ],
    );
  }

Widget sheet(){
  return Container(
    height: 120,
     width: MediaQuery.of(this.context).size.width,
     child: Card(
       margin: EdgeInsets.all(18),
       child: Padding(
         padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 8),
         child: Row(
           mainAxisAlignment: MainAxisAlignment.center,
           
           children:<Widget> [
              documenticon(),
              SizedBox(width: 25,),
              cameraicon(),
              SizedBox(width: 25,),
              galleryicon(),
              SizedBox(width: 25,),
           ],
         ),
       ),
     ),
  );
}

Widget imageview(){
    return Container(
      child: imageTemp == null ? Text('No iamge selected'): Image.file(imageTemp!),
    );
  }

Future pickimage()async{
    try {
     final image = await ImagePicker().pickImage(source: ImageSource.gallery);
     if(image==null)return;
     else if(image!=null){
        final file = File(image.path);
         Navigator.of(this.context).push(MaterialPageRoute(builder: (context) =>
                                         previewimage(file,widget.code,widget.classname,
                                         widget.subject,widget.section,widget.createdby,widget.image,widget.createdbyid,widget.allowcomment)));
     }
    }
    on PlatformException catch (e) {
       print('Failed to pick iamge : $e');
    }
  }

Future clickimage()async{
     try {
     final image = await ImagePicker().pickImage(source: ImageSource.camera);
     if(image==null)return;
     else if(image!=null){
        final file = File(image.path);
         Navigator.of(this.context).push(MaterialPageRoute(builder: (context) =>
                                         previewimage(file,widget.code,widget.classname,
                                         widget.subject,widget.section,widget.createdby,widget.image,widget.createdbyid,widget.allowcomment)));
     }
    }
    on PlatformException catch (e) {
       print('Failed to pick iamge : $e');
    }
  }

Widget documenticon(){
  final fileName = file !=null? basename(file!.path): 'No File Selected';
  return InkWell(
    onTap: (){
      showDialog(context: this.context,
       builder: (context){
         return Dialog(
      shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),),
      backgroundColor: Colors.white,
      child: Container(
        width: double.infinity,
        height: 220,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
             SizedBox(height: 20),
            textBox(),
           SizedBox(height: 5),
             Text(fileName),
            SizedBox(height: 30),
             uploadbtn(),
                task!=null ? uploadStatus(task!) : Container(),
              
          ],
          ),
        ),
      )
      );
       }
       );
   },

    child:Column(
    children:<Widget> [
    CircleAvatar(
      radius: 25,
      backgroundColor: Colors.indigo,
      child: Icon(
        Icons.insert_drive_file,
        size: 29,
      ),
    ), 
    Text('Document',
    style: GoogleFonts.ubuntu(
      fontSize: 1.8*SizeConfig.textMultiplier,
    ),),
    ],
  ),
  );
}

Widget cameraicon(){
  return InkWell(
    onTap: (){
      clickimage();
    },
    child:Column(
    children: [
    CircleAvatar(
      radius: 25,
      backgroundColor: Colors.pink,
      child: Icon(
        Icons.camera_alt,
        size: 29,
      ),
    ), 
    Text('camera',
    style: GoogleFonts.ubuntu(
      fontSize: 1.8*SizeConfig.textMultiplier,
    ),) 
   ],
  ),
  );
}

Widget galleryicon(){
  return InkWell(
    onTap: (){
      pickimage();
    },
    child:Column(
    children: [
     CircleAvatar(
      radius: 25,
      backgroundColor: Colors.purple,
      child: Icon(
        Icons.insert_photo,
        size: 29,
      ),
    ),  
    Text('gallery',
    style: GoogleFonts.ubuntu(
      fontSize: 1.8*SizeConfig.textMultiplier,
    ),) 
    ],
  ),
  );
}

Widget buildbanner(){
  return Container(
                                height: SizeConfig.isMobilePortrait==true?19.0*SizeConfig.heightMultiplier:
                                 23.0*SizeConfig.heightMultiplier,
                                width: MediaQuery.of(this.context).size.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                     image: DecorationImage(
                                        image: AssetImage(widget.image),
                                        colorFilter:const ColorFilter.mode(Colors.black54, BlendMode.darken),
                                        fit: BoxFit.fill,
                                        opacity: 0.9
                                      ),
                                   ),
                                    child:Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children:<Widget> [
                                        Align(
                                           alignment: Alignment.topRight,
                                           child: popbtn(),
                                        ), 
                                        Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical:15,horizontal: 10),
                                          child: Text(widget.subject+" "+widget.section,
                                          style: TextStyle(color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontStyle: FontStyle.normal ,
                                          fontSize: 2.5*SizeConfig.textMultiplier
                                          ),
                                          ),
                                        ),
                                       ),
                                      ],
                                    ),
                                  
                                );
}

Widget builddisplaycomment(){
  Size size = MediaQuery.of(this.context).size;
 return StreamBuilder<QuerySnapshot> (
                      stream: FirebaseFirestore.instance.collection('comment').where('class-code',isEqualTo: widget.code)
                      .orderBy('sent time').snapshots(),  
                      builder: (BuildContext context, snapshot){ 
                        if(!snapshot.hasData){
                            return  Text('no Data');        
                         }
                          if(snapshot.hasData&&snapshot.data!.docs.length<1){
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 60),
                              child: Column(
                              children: [
                                Transform.rotate(
                                  angle: 50,
                                  child: Icon(Icons.message,
                                  color: Colors.black87.withOpacity(0.1),
                                  size: size.width*0.4,
                                  ),
                                ),
                                SizedBox(height: size.height*0.02),   
                                Text(
                                    'No messages yet',
                                    style: GoogleFonts.ubuntu(
                                      color: Colors.black54,
                                      fontSize: size.width*0.04
                                    ),
                                  ),
  
                                Text(
                                    'Be the first one to share your thoughts',
                                    style: GoogleFonts.ubuntu(
                                      color: Colors.black54,
                                      fontSize: size.width*0.04
                                    ),
                                  ),
                              ],
                          ),
                            );                     
                         }
                          if(snapshot.connectionState==ConnectionState.waiting)
                             return  CircularProgressIndicator();
                          else {
                            return SingleChildScrollView(
                                  child: ListView.builder( 
                                      physics:const  NeverScrollableScrollPhysics(),
                                      reverse: true,
                                      shrinkWrap: true,
                                      itemCount: snapshot.data?.docs.length,
                                      itemBuilder: (context, i )
                                      {
                                      DateTime currentTime= DateTime.now();
                                      Timestamp senttime =snapshot.data?.docs[i]['sent time'];
                                      DateTime sendertime = senttime.toDate();
                                      String todaytime = DateFormat.jm().format(sendertime);
                                      String fulltime = DateFormat('kk:mm  yyyy-MM-dd').format(sendertime);
                                      String streammessage = snapshot.data?.docs[i]['comment'];
                                      int length = snapshot.data?.docs[i]['length'];
                                      String stringlength = length.toString();
                                      if(length==0){
                                      if((currentTime.year == sendertime.year)
                                          && (currentTime.month == sendertime.month)
                                          && (currentTime.day == sendertime.day))
                                        {
                                      return Padding(
                                      padding: EdgeInsets.symmetric(vertical:1.2*SizeConfig.heightMultiplier ),
                                      child: Container(
                                      padding: EdgeInsets.symmetric(vertical:0.0*SizeConfig.heightMultiplier,
                                      horizontal:2.2*SizeConfig.widthMultiplier),
                                      decoration: BoxDecoration(
                                        color: Colors.white10,
                                        borderRadius: BorderRadius.circular(5),
                                        boxShadow: [
                                        BoxShadow(
                                        color: Colors.black45,
                                        blurRadius: 3,
                                        offset: Offset(0,2)
                                         ),
                                        ],
                                       ),
                                      child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                      Row(
                                      children:<Widget>[
                                      Text(
                                      "${snapshot.data?.docs[i]['givenby']}", 
                                      softWrap: true,
                                      style: GoogleFonts.firaSans(
                                      fontSize: 2.0*SizeConfig.textMultiplier,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white70,
                                     )
                                     ),
                                     Expanded(
                                        flex: 1,
                                        child:  Align(
                                          alignment: Alignment.topRight,
                                          child: IconButton(
                                          color: Colors.orangeAccent,
                                          iconSize:2.5*SizeConfig.heightMultiplier,
                                           onPressed:(){
                                           Navigator.of(context)
                                          .push(MaterialPageRoute(builder: (context) =>
                                           expandedCommentscreen("${snapshot.data?.docs[i]['givenby']}",
                                           "${snapshot.data?.docs[i]['comment']}",
                                           fulltime,
                                           "${snapshot.data?.docs[i]['url']}",
                                           stringlength,
                                           )));
                                               },
                                            icon: Icon(Icons.arrow_forward,
                                            ),
                                            ),
                                        ),
                                         ),
                                        ],
                                        ),
                                        Text(
                                          todaytime, 
                                          softWrap: true,
                                          style: GoogleFonts.firaSans(
                                          fontSize: 1.7*SizeConfig.textMultiplier,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white70,
                                        )
                                        ),
                                        SizedBox(height: 1.0*SizeConfig.heightMultiplier),
                                         Stack(
                                             children: [
                                                 Padding(
                                                   padding: const EdgeInsets.all(2.0),
                                                   child: Text(
                                                    "${snapshot.data?.docs[i]['comment']}",
                                                     style: GoogleFonts.hindSiliguri(
                                                      fontSize: 2.0*SizeConfig.textMultiplier,
                                                      color: Colors.white60,
                                                     ),
                                                    ),
                                                   ), 
                                                ],
                                          ),
                                          const Divider(
                                            color: Colors.orangeAccent,thickness: 1,
                                          ),
                                          MaterialButton(
                                            onPressed: ()async{
                                               final QuerySnapshot snap = await FirebaseFirestore.instance.collection('comment').
                                               where('class-code',isEqualTo: widget.code)
                                               .where('sent time',isEqualTo: snapshot.data?.docs[i]['sent time'])
                                               .get();
                                               final List<DocumentSnapshot> snapdocs=snap.docs;
                                               if(snapdocs.length!=0){
                                               for(var  snapshot in snapdocs){
                                               var documentID= snapshot.id;
                                               print(documentID);
                                              Navigator.of(context)
                                              .push(MaterialPageRoute(builder: (context) => 
                                              additionalComment(
                                              streammessage,
                                              documentID,
                                              widget.code,
                                              )));
                                            }
                                          }
                                        },
                                        child: Container(
                                              width:double.infinity ,
                                             child: Text('Add Comment....',
                                                    style: GoogleFonts.hindSiliguri(
                                                    fontSize: 2.0*SizeConfig.textMultiplier,
                                                    color: Colors.white60,
                                                     ),
                                                    ),
                                            ),
                                          )
                                         ],
                                       ),
                                     ),
                                    );

                                        }
                                      if((currentTime.year==sendertime.year)&&(currentTime.month == sendertime.month)){
                                        if((currentTime.day - sendertime.day) == 1){
                                          return Padding(
                                      padding: EdgeInsets.symmetric(vertical:1.2*SizeConfig.heightMultiplier ),
                                      child: Container(
                                      padding: EdgeInsets.symmetric(vertical:0.0*SizeConfig.heightMultiplier,
                                      horizontal:2.2*SizeConfig.widthMultiplier),
                                      decoration: BoxDecoration(
                                        color: Colors.white10,
                                        borderRadius: BorderRadius.circular(5),
                                        boxShadow: [
                                        BoxShadow(
                                        color: Colors.black45,
                                        blurRadius: 3,
                                        offset: Offset(0,2)
                                         ),
                                        ],
                                       ),
                                      child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                      Row(
                                      children:<Widget>[
                                      Text(
                                      "${snapshot.data?.docs[i]['givenby']}", 
                                      softWrap: true,
                                      style: GoogleFonts.firaSans(
                                      fontSize: 2.0*SizeConfig.textMultiplier,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white70,
                                     )
                                     ),
                                     Expanded(
                                        flex: 1,
                                        child: Align(
                                        alignment: Alignment.topRight,
                                        child:  IconButton(
                                         iconSize: 2.5*SizeConfig.heightMultiplier,
                                         color: Colors.orangeAccent,
                                         onPressed:(){
                                         Navigator.of(context)
                                        .push(MaterialPageRoute(builder: (context) =>
                                         expandedCommentscreen("${snapshot.data?.docs[i]['givenby']}",
                                         "${snapshot.data?.docs[i]['comment']}",
                                         fulltime,
                                         "${snapshot.data?.docs[i]['url']}",
                                         stringlength,
                                         )));
                                             },
                                          icon: Icon(Icons.arrow_forward,
                                          ),
                                          ),
                                          ),
                                         ),
                                        ],
                                        ),
                                        Text(
                                          "Yesterday", 
                                          softWrap: true,
                                          style: GoogleFonts.firaSans(
                                          fontSize: 1.7*SizeConfig.textMultiplier,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white70,
                                        )
                                        ),
                                        SizedBox(height: 1.0*SizeConfig.heightMultiplier,),
                                         Stack(
                                             children: [
                                                 Padding(
                                                   padding: const EdgeInsets.all(2.0),
                                                   child: Text(
                                                    "${snapshot.data?.docs[i]['comment']}",
                                                     style: GoogleFonts.hindSiliguri(
                                                      fontSize: 2.0*SizeConfig.textMultiplier,
                                                      color: Colors.white60,
                                                     ),
                                                    ),
                                                   ), 
                                                ],
                                          ),
                                          const Divider(
                                            color: Colors.orangeAccent,thickness: 1,
                                          ),
                                          MaterialButton(
                                            onPressed: ()async{
                                               final QuerySnapshot snap = await FirebaseFirestore.instance.collection('comment').
                                               where('class-code',isEqualTo: widget.code)
                                               .where('sent time',isEqualTo: snapshot.data?.docs[i]['sent time'])
                                               .get();
                                               final List<DocumentSnapshot> snapdocs=snap.docs;
                                               if(snapdocs.length!=0){
                                               for(var  snapshot in snapdocs){
                                               var documentID= snapshot.id;
                                               print(documentID);
                                              Navigator.of(context)
                                              .push(MaterialPageRoute(builder: (context) => 
                                              additionalComment(
                                              streammessage,
                                              documentID,
                                              widget.code
                                              )));
                                            }
                                          }
                                        },
                                        child: Container(
                                              width:double.infinity ,
                                             child: Text('Add Comment....',
                                                    style: GoogleFonts.hindSiliguri(
                                                    fontSize: 2.0*SizeConfig.textMultiplier,
                                                    color: Colors.white60,
                                                     ),
                                                    ),
                                            ),
                                          )
                                         ],
                                       ),
                                     ),
                                    );
                                          }
                                        else if((currentTime.day - sendertime.day) == -1){
                                          return Text('Tommorow') ;}
                                      else{
                                          return Padding(
                                       padding: EdgeInsets.symmetric(vertical:1.2*SizeConfig.heightMultiplier ),
                                      child: Container(
                                      padding: EdgeInsets.symmetric(vertical:0.0*SizeConfig.heightMultiplier,
                                      horizontal:2.2*SizeConfig.widthMultiplier),
                                      decoration: BoxDecoration(
                                        color: Colors.white10,
                                        borderRadius: BorderRadius.circular(5),
                                        boxShadow: [
                                        BoxShadow(
                                        color: Colors.black45,
                                        blurRadius: 3,
                                        offset: Offset(0,2)
                                         ),
                                        ],
                                       ),
                                      child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                      Row(
                                      children:<Widget>[
                                      Text(
                                      "${snapshot.data?.docs[i]['givenby']}", 
                                      softWrap: true,
                                      style: GoogleFonts.firaSans(
                                      fontSize: 2.0*SizeConfig.textMultiplier,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white70,
                                     )
                                     ),
                                     Expanded(
                                        flex: 1,
                                        child: Align(
                                        alignment: Alignment.topRight,
                                        child:  IconButton(
                                        iconSize: 2.5*SizeConfig.heightMultiplier,
                                        color: Colors.orangeAccent,
                                         onPressed:(){
                                         Navigator.of(context)
                                        .push(MaterialPageRoute(builder: (context) =>
                                         expandedCommentscreen("${snapshot.data?.docs[i]['givenby']}",
                                         "${snapshot.data?.docs[i]['comment']}",
                                         fulltime,
                                         "${snapshot.data?.docs[i]['url']}",
                                         stringlength
                                         )));
                                             },
                                          icon: Icon(Icons.arrow_forward,
                                          ),
                                          ),
                                          ),
                                         ),
                                        ],
                                        ),
                                        Text(
                                          fulltime, 
                                          softWrap: true,
                                          style: GoogleFonts.firaSans(
                                          fontSize: 1.7*SizeConfig.textMultiplier,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white70,
                                        )
                                        ),
                                        SizedBox(height: 1.0*SizeConfig.heightMultiplier,),
                                         Stack(
                                             children: [
                                                 Padding(
                                                   padding: const EdgeInsets.all(2.0),
                                                   child: Text(
                                                    "${snapshot.data?.docs[i]['comment']}",
                                                     style: GoogleFonts.hindSiliguri(
                                                      fontSize: 2.0*SizeConfig.textMultiplier,
                                                      color: Colors.white60,
                                                     ),
                                                    ),
                                                   ), 
                                                ],
                                          ),
                                        const Divider(
                                            color: Colors.orangeAccent,thickness: 1,
                                          ),
                                          MaterialButton(
                                            onPressed: ()async{
                                               final QuerySnapshot snap = await FirebaseFirestore.instance.collection('comment').
                                               where('class-code',isEqualTo: widget.code)
                                               .where('sent time',isEqualTo: snapshot.data?.docs[i]['sent time'])
                                               .get();
                                               final List<DocumentSnapshot> snapdocs=snap.docs;
                                               if(snapdocs.length!=0){
                                               for(var  snapshot in snapdocs){
                                               var documentID= snapshot.id;
                                               print(documentID);
                                              Navigator.of(context)
                                              .push(MaterialPageRoute(builder: (context) => 
                                              additionalComment(
                                              streammessage,
                                              documentID,
                                              widget.code
                                              )));
                                            }
                                          }
                                        },
                                        child: Container(
                                              width:double.infinity ,
                                             child: Text('Add Comment....',
                                                    style: GoogleFonts.hindSiliguri(
                                                    fontSize: 2.0*SizeConfig.textMultiplier,
                                                    color: Colors.white60,
                                                     ),
                                                    ),
                                            ),
                                          ),
                                         ],
                                       ),
                                     ),
                                    );
                                  }
                                }
                                      }
                                      if(length>0){
                                      if((currentTime.year == sendertime.year)
                                          && (currentTime.month == sendertime.month)
                                          && (currentTime.day == sendertime.day))
                                        {
                                      return Padding(
                                     padding: EdgeInsets.symmetric(vertical:1.2*SizeConfig.heightMultiplier ),
                                      child: Container(
                                      padding: EdgeInsets.symmetric(vertical:0.0*SizeConfig.heightMultiplier,
                                      horizontal:2.2*SizeConfig.widthMultiplier),
                                      decoration: BoxDecoration(
                                        color: Colors.white10,
                                        borderRadius: BorderRadius.circular(5),
                                        boxShadow: [
                                        BoxShadow(
                                        color: Colors.black45,
                                        blurRadius: 3,
                                        offset: Offset(0,2)
                                         ),
                                        ],
                                       ),
                                      child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                      Row(
                                      children:<Widget>[
                                      Text(
                                      "${snapshot.data?.docs[i]['givenby']}", 
                                      softWrap: true,
                                      style: GoogleFonts.firaSans(
                                      fontSize: 2.0*SizeConfig.textMultiplier,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white70,
                                     )
                                     ),
                                     Expanded(
                                        flex: 1,
                                        child: Align(
                                          alignment: Alignment.topRight,
                                        child:  IconButton(
                                        iconSize:2.5*SizeConfig.heightMultiplier,
                                          color: Colors.orangeAccent,
                                         onPressed:(){
                                         Navigator.of(context)
                                        .push(MaterialPageRoute(builder: (context) =>
                                         expandedCommentscreen("${snapshot.data?.docs[i]['givenby']}",
                                         "${snapshot.data?.docs[i]['comment']}",
                                         fulltime,
                                         "${snapshot.data?.docs[i]['url']}",
                                         stringlength,
                                         )));
                                             },
                                          icon: Icon(Icons.arrow_forward,
                                          ),
                                          ),
                                          ),
                                         ),
                                        ],
                                        ),
                                        Text(
                                          todaytime, 
                                          softWrap: true,
                                          style: GoogleFonts.firaSans(
                                          fontSize: 1.7*SizeConfig.textMultiplier,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white70,
                                        )
                                        ),
                                        SizedBox(height: 1.0*SizeConfig.heightMultiplier),
                                         Stack(
                                             children: [
                                                 Padding(
                                                   padding: const EdgeInsets.all(2.0),
                                                   child: Text(
                                                    "${snapshot.data?.docs[i]['comment']}",
                                                     style: GoogleFonts.hindSiliguri(
                                                      fontSize: 2.0*SizeConfig.textMultiplier,
                                                      color: Colors.white60,
                                                     ),
                                                    ),
                                                   ), 
                                                ],
                                          ),
                                          const Divider(
                                            color: Colors.orangeAccent,thickness: 1,
                                          ),
                                          MaterialButton(
                                            onPressed: ()async{
                                               final QuerySnapshot snap = await FirebaseFirestore.instance.collection('comment').
                                               where('class-code',isEqualTo: widget.code)
                                               .where('sent time',isEqualTo: snapshot.data?.docs[i]['sent time'])
                                               .get();
                                               final List<DocumentSnapshot> snapdocs=snap.docs;
                                               if(snapdocs.length!=0){
                                               for(var  snapshot in snapdocs){
                                               var documentID= snapshot.id;
                                               print(documentID);
                                              Navigator.of(context)
                                              .push(MaterialPageRoute(builder: (context) => 
                                              additionalComment(
                                              streammessage,
                                              documentID,
                                              widget.code
                                              )));
                                            }
                                          }
                                        },
                                        child: Container(
                                              width:double.infinity ,
                                             child: Text(stringlength+'  class comment...',
                                                    style: GoogleFonts.hindSiliguri(
                                                    fontSize: 2.0*SizeConfig.textMultiplier,
                                                    color: Colors.white60,
                                                     ),
                                                    ),
                                            ),
                                          )
                                         ],
                                       ),
                                     ),
                                    );

                                        }
                                      if((currentTime.year==sendertime.year)&&(currentTime.month == sendertime.month)){
                                        if((currentTime.day - sendertime.day) == 1){
                                          return Padding(
                                      padding: EdgeInsets.symmetric(vertical:1.2*SizeConfig.heightMultiplier ),
                                      child: Container(
                                      padding: EdgeInsets.symmetric(vertical:0.0*SizeConfig.heightMultiplier,
                                      horizontal:2.2*SizeConfig.widthMultiplier),
                                      decoration: BoxDecoration(
                                        color: Colors.black38,
                                        borderRadius: BorderRadius.circular(5),
                                        boxShadow: [
                                        BoxShadow(
                                        color: Colors.white10,
                                        blurRadius: 3,
                                        offset: Offset(0,2)
                                         ),
                                        ],
                                       ),
                                      child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                      Row(
                                      children:<Widget>[
                                      Text(
                                      "${snapshot.data?.docs[i]['givenby']}", 
                                      softWrap: true,
                                      style: GoogleFonts.firaSans(
                                      fontSize: 2.0*SizeConfig.textMultiplier,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white70,
                                     )
                                     ),
                                     Expanded(
                                        flex: 1,
                                        child: Align(
                                          alignment: Alignment.topRight,
                                        child:  IconButton(
                                        iconSize: 2.5*SizeConfig.heightMultiplier,
                                          color: Colors.orangeAccent,
                                         onPressed:(){
                                         Navigator.of(context)
                                        .push(MaterialPageRoute(builder: (context) =>
                                         expandedCommentscreen("${snapshot.data?.docs[i]['givenby']}",
                                         "${snapshot.data?.docs[i]['comment']}",
                                         fulltime,
                                         "${snapshot.data?.docs[i]['url']}",
                                         stringlength
                                         )));
                                             },
                                          icon: Icon(Icons.arrow_forward,
                                          ),
                                          ),
                                          ),
                                         ),
                                        ],
                                        ),
                                        Text(
                                          
                                          "Yesterday", 
                                          softWrap: true,
                                          style: GoogleFonts.firaSans(
                                          fontSize: 1.7*SizeConfig.textMultiplier,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white70,
                                        )
                                        ),
                                        SizedBox(height: 1.0*SizeConfig.heightMultiplier,),
                                         Stack(
                                             children: [
                                                 Padding(
                                                   padding: const EdgeInsets.all(2.0),
                                                   child: Text(
                                                    "${snapshot.data?.docs[i]['comment']}",
                                                     style: GoogleFonts.hindSiliguri(
                                                      fontSize: 2.0*SizeConfig.textMultiplier,
                                                      color: Colors.white60,
                                                     ),
                                                    ),
                                                   ), 
                                                ],
                                          ),
                                          const Divider(
                                            color: Colors.orangeAccent,thickness: 1,
                                          ),
                                          MaterialButton(
                                            onPressed: ()async{
                                               final QuerySnapshot snap = await FirebaseFirestore.instance.collection('comment').
                                               where('class-code',isEqualTo: widget.code)
                                               .where('sent time',isEqualTo: snapshot.data?.docs[i]['sent time'])
                                               .get();
                                               final List<DocumentSnapshot> snapdocs=snap.docs;
                                               if(snapdocs.length!=0){
                                               for(var  snapshot in snapdocs){
                                               var documentID= snapshot.id;
                                               print(documentID);
                                              Navigator.of(context)
                                              .push(MaterialPageRoute(builder: (context) => 
                                              additionalComment(
                                              streammessage,
                                              documentID,
                                              widget.code
                                              )));
                                            }
                                          }
                                        },
                                        child: Container(
                                              width:double.infinity ,
                                             child: Text(stringlength+'  class comment...',
                                                    style: GoogleFonts.hindSiliguri(
                                                    fontSize: 2.0*SizeConfig.textMultiplier,
                                                    color: Colors.white60,
                                                     ),
                                                    ),
                                            ),
                                          )
                                         ],
                                       ),
                                     ),
                                    );
                                          }
                                        else if((currentTime.day - sendertime.day) == -1){
                                          return Text('Tommorow') ;}
                                      else{
                                          return Padding(
                                      padding: EdgeInsets.symmetric(vertical:1.2*SizeConfig.heightMultiplier ),
                                      child: Container(
                                      padding: EdgeInsets.symmetric(vertical:0.0*SizeConfig.heightMultiplier,
                                      horizontal:2.2*SizeConfig.widthMultiplier),
                                      decoration: BoxDecoration(
                                        color: Colors.white10,
                                        borderRadius: BorderRadius.circular(5),
                                        boxShadow: [
                                        BoxShadow(
                                        color: Colors.black45,
                                        blurRadius: 3,
                                        offset: Offset(0,2)
                                         ),
                                        ],
                                       ),
                                      child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                      Row(
                                      children:<Widget>[
                                      Text(
                                      "${snapshot.data?.docs[i]['givenby']}", 
                                      softWrap: true,
                                      style: GoogleFonts.firaSans(
                                      fontSize: 2.0*SizeConfig.textMultiplier,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white70,
                                     )
                                     ),
                                     Expanded(
                                        flex: 1,
                                        child: Align(
                                          alignment: Alignment.topRight,
                                        child:  IconButton(
                                        iconSize: 2.5*SizeConfig.heightMultiplier,
                                          color: Colors.orangeAccent,
                                         onPressed:(){
                                         Navigator.of(context)
                                        .push(MaterialPageRoute(builder: (context) =>
                                         expandedCommentscreen("${snapshot.data?.docs[i]['givenby']}",
                                         "${snapshot.data?.docs[i]['comment']}",
                                         fulltime,
                                         "${snapshot.data?.docs[i]['url']}",
                                         stringlength
                                         )));
                                             },
                                          icon: Icon(Icons.arrow_forward,
                                          ),
                                          ),
                                          ),
                                         ),
                                        ],
                                        ),
                                        Text(
                                          fulltime, 
                                          softWrap: true,
                                          style: GoogleFonts.firaSans(
                                          fontSize: 1.7*SizeConfig.textMultiplier,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white70,
                                        )
                                        ),
                                        SizedBox(height: 1.0*SizeConfig.heightMultiplier,),
                                         Stack(
                                             children: [
                                                 Padding(
                                                   padding: const EdgeInsets.all(2.0),
                                                   child: Text(
                                                    "${snapshot.data?.docs[i]['comment']}",
                                                     style: GoogleFonts.hindSiliguri(
                                                      fontSize: 2.0*SizeConfig.textMultiplier,
                                                      color: Colors.white60,
                                                     ),
                                                    ),
                                                   ), 
                                                ],
                                          ),
                                        const Divider(
                                            color: Colors.orangeAccent,thickness: 1,
                                          ),
                                          MaterialButton(
                                            onPressed: ()async{
                                               final QuerySnapshot snap = await FirebaseFirestore.instance.collection('comment').
                                               where('class-code',isEqualTo: widget.code)
                                               .where('sent time',isEqualTo: snapshot.data?.docs[i]['sent time'])
                                               .get();
                                               final List<DocumentSnapshot> snapdocs=snap.docs;
                                               if(snapdocs.length!=0){
                                               for(var  snapshot in snapdocs){
                                               var documentID= snapshot.id;
                                               print(documentID);
                                              Navigator.of(context)
                                              .push(MaterialPageRoute(builder: (context) => 
                                              additionalComment(
                                              streammessage,
                                              documentID,
                                              widget.code
                                              )));
                                            }
                                          }
                                        },
                                        child: Container(
                                              width:double.infinity ,
                                             child: Text(stringlength+'  class comment...',
                                                    style: GoogleFonts.hindSiliguri(
                                                    fontSize: 2.0*SizeConfig.textMultiplier,
                                                    color: Colors.white60,
                                                     ),
                                                    ),
                                             ),
                                            ),
                                            ],
                                           ),
                                           ),
                                         );
                                        }
                                        }
                                      }
                                 return const Text('');//for non nullable statement
                                }
                              ),
                            );
                          }
                     },
 );

}

Widget floatingsheet(){
  return SizedBox(
     height: SizeConfig.isMobilePortrait==true?15.0*SizeConfig.heightMultiplier:
              13.0*SizeConfig.heightMultiplier,
     width: MediaQuery.of(this.context).size.width,
     child: Container(
       color: Colors.grey[350],
       margin:const EdgeInsets.all(18),
       child: Padding(
         padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 8),
         child: Column(
           mainAxisAlignment: MainAxisAlignment.start,
           children:<Widget> [
             SizedBox(height: 1.1*SizeConfig.heightMultiplier),
             GestureDetector(
              onTap: (){
                Navigator.of(this.context).push(MaterialPageRoute(builder: (context)=> viewAttendance(widget.code)));
              },
              child: Align(
               alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 1.5*SizeConfig.widthMultiplier),
                  child: RichText(
                    text: TextSpan(
                          text: ' View Attendance',
                          style: GoogleFonts.ubuntu(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize:2.0*SizeConfig.textMultiplier,
                          )
                        )
                      ),
                ),
              ),
              ),
              SizedBox(height:1.5*SizeConfig.heightMultiplier),
              GestureDetector(
              onTap: (){
                Navigator.of(this.context).push(MaterialPageRoute(builder: (context)=> viewUsers(widget.code)));
              },
              child: Align(
               alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 1.5*SizeConfig.widthMultiplier),
                  child: RichText(
                    text: TextSpan(
                          text: ' View People',
                          style: GoogleFonts.ubuntu(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize:2.0*SizeConfig.textMultiplier,
                          )
                        )
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
       appBar: AppBar(
       backgroundColor: Colors.black,
       title:Text(widget.classname,
       style: TextStyle(
          color: Colors.white,
          fontWeight:SizeConfig.isMobilePortrait==true?FontWeight.bold:
          FontWeight.w700,
          fontSize: 2.5*SizeConfig.textMultiplier))),
       body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector( 
          child: Stack(
            children: <Widget>[
              Container(
                  height:double.infinity,
                  width:double.infinity ,
               child: SingleChildScrollView(
                        physics:const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()), 
                        padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.isMobilePortrait==true?1.5*SizeConfig.heightMultiplier:
                        1.8*SizeConfig.heightMultiplier,
                        vertical: 1.5*SizeConfig.heightMultiplier,
                      ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        buildbanner(),
                        SizedBox(height: 1.5*SizeConfig.heightMultiplier,),
                        widget.allowcomment=='disable'? Column(children: [
                        showtextfield(),
                         SizedBox(height: 0.5*SizeConfig.heightMultiplier),
                        builddisplaycomment(),
                        ],):
                        builddisplaycomment(),
                 ],
               ),
              ), 
              ),
        

            ],  
          ),
        ),
     ),
     floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
     floatingActionButton: Padding(
       padding: EdgeInsets.symmetric(vertical: 2.0*SizeConfig.heightMultiplier,
       horizontal:2.0*SizeConfig.widthMultiplier),
       child: SizedBox(
         width: SizeConfig.isMobilePortrait==true?13.0*SizeConfig.widthMultiplier:
                10.0*SizeConfig.widthMultiplier,
         height: 15.0*SizeConfig.widthMultiplier,
         child: FloatingActionButton(
            child: Icon(Icons.add),
            backgroundColor: Colors.blueGrey,
            onPressed: () {
              showModalBottomSheet(
                     backgroundColor: Colors.transparent,
                     barrierColor: Colors.transparent,
                     context: this.context,
                      builder:(builder)=> floatingsheet());
            },
          ),
       ),
     ),
    );
   }
}