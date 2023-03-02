import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart';
import 'package:vidyalayaapp/Pages/Sclasspage.dart';
import 'package:vidyalayaapp/Pages/Tclasspage.dart';
import 'package:vidyalayaapp/Pages/services.dart';

class previewimage extends StatefulWidget {
  const previewimage(this.file, this.code,this.classname, this.subject, this.section, this.createdby,this.image,this.createdbyid,this.allowcomment) : super();
  final File file;
  final String code;
  final String classname;
  final String subject;
  final String section;
  final String createdby;
  final String image;
  final String createdbyid;
  final String allowcomment;
  @override
  _previewimageState createState() => _previewimageState();
}

class _previewimageState extends State<previewimage> {

   final CollectionReference _uref = FirebaseFirestore.instance.collection('users');
   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
   final TextEditingController _textController = new TextEditingController();
   final TextEditingController _dialogtextController = new TextEditingController();
   final FirebaseAuth _auth = FirebaseAuth.instance;
  String _dialogmessage='';
  String _givenby='';
  String deliveredby='';
  File? file;
  File? imageTemp;
  UploadTask? task;
  bool _isInputempty=true; 
  Timer? _timer;
  String role='';

  void initState() {
    super.initState();
    EasyLoading.addStatusCallback((status) {
      print('EasyLoading Status $status');
      if (status == EasyLoadingStatus.dismiss) {
        _timer?.cancel();
      }
    });
  }

 Future uploadFile()async{
  final fileName = basename(widget.file.path);
  final destination = 'files/$fileName';
  task = myFirebaseStorage.uploadFile(destination, widget.file);
  setState(() {});
  if (task==null) {
    return;
  }
  EasyLoading.show(status: 'uploading...');
  final snapshot = await task?.whenComplete(() => {});
  final url = await snapshot?.ref.getDownloadURL();
  final User? Cuser = _auth.currentUser;
   final uid = Cuser?.uid;
   final QuerySnapshot Usnap= await this._uref.where('personal-id', isEqualTo: uid).get();
               final List<DocumentSnapshot> Udocs=Usnap.docs;
               if(Udocs.length!=0){
                 DocumentSnapshot<Object?>? userDoc=Udocs.last;
                 _givenby=userDoc['name'];
                 role = userDoc['role'];
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
    EasyLoading.showSuccess('Uploaded Successfully');
    //Fluttertoast.showToast(msg: "Uploaded Succesfully");
    EasyLoading.dismiss();
    role=='teacher'?Navigator.pushReplacement(this.context, MaterialPageRoute(
      builder: (BuildContext context) =>
       TclassPage(widget.classname,widget.subject,widget.code,widget.section,widget.createdby,widget.image,widget.createdbyid,widget.allowcomment)))
       :
       Navigator.pushReplacement(this.context, MaterialPageRoute(
      builder: (BuildContext context) =>
       SclassPage(widget.classname, widget.subject, widget.code, widget.section, widget.createdby,widget.image,widget.createdbyid,widget.allowcomment)));
    
        
}

 Widget buildmssgbox(){
   Size size=MediaQuery.of(this.context).size;
    return Column(
     children:<Widget> [
      Container(
       width: size.width*0.82,
       decoration: BoxDecoration(
         color: Colors.grey,
         borderRadius: BorderRadius.circular(0),
         boxShadow:const [
           BoxShadow(
           color: Colors.black26,
         ),
        ],
       ),
        child:  ConstrainedBox(
        constraints: const BoxConstraints(
        maxHeight: 100.0,),
        child: TextFormField(
         maxLines: 2,
         controller: _textController,
         keyboardType: TextInputType.multiline,
         onChanged: (val) {
             setState(() {
                _dialogmessage = val.trim().toString();
                if(_dialogmessage.isNotEmpty){  
                     _isInputempty = false;
                  } else {
                     _isInputempty = true;
                  }
             });
         },
         validator: (input)
          {   
             if(input==null|| input==''){
               return 'type comment first';
               }
           },
         style:const TextStyle(
           color: Colors.black87,
         ),
         decoration:const InputDecoration(
         border: InputBorder.none,
         contentPadding:const EdgeInsets.only(top:13),
            prefixIcon:
                     Padding(
                       padding: EdgeInsets.only(bottom: 1),
                       child: Icon(
                    Icons.comment,
                    color: Color(0xff212121)
                    ),
                     ),
             hintText:'type your message.....',
           hintStyle: TextStyle(
             color: Colors.black38
           ),
            ),
             )
          ),
         ),
      ],
    );
  }

 Widget buildsendicon(){
   return 
     Transform.scale(
       scale: 1.6,
     child: IgnorePointer(
       ignoring: _isInputempty,
       child: IconButton(
         icon:const Icon(Icons.send),
         color:  _isInputempty ? Colors.grey[800] : Colors.grey,
         onPressed: ()async{
           uploadFile();
         },
       ),
     ),
    );
 }

 Widget imageviewer(){
   Size size=MediaQuery.of(this.context).size;
   return Column(
     children: [
       Container(
         child: widget.file==null ? const Text('No image selected'): Image.file(widget.file),
      ),
     
     ],
   );
 }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xDD000000),
        elevation: 0,
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
                        physics:const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()), 
                        padding:const EdgeInsets.symmetric(
                        horizontal: 10,
                       ),
                      child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: size.height*0.01,),
                        Align(alignment: Alignment.topLeft,
                        child: Text('Your image will appear below..',
                        style: GoogleFonts.firaSans(
                                color: Colors.white,
                                fontSize: size.width*0.05,
                        ),
                        )),
                        SizedBox(height: size.height*0.05,),
                        imageviewer(),
                  ],
               ),
              ), 
              ),
               Align(
                      alignment: Alignment.bottomCenter,
                        child: Container(
                          alignment: Alignment.bottomCenter,
                         decoration: const BoxDecoration(
                          color: Colors.transparent,
                            ),
                          height:70,
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                            child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Form(key:_formKey, child: Column(children: [
                              Flexible(child: buildmssgbox()),])),
                              Flexible(child:buildsendicon(),),
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