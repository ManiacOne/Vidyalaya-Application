import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class additionalComment extends StatefulWidget{
  const additionalComment(this.message,this.documentID,this.code, {Key? key}) : super(key: key);
  final String message;
  final String documentID;
  final String code;
  @override
  _additionalCommentState createState() => _additionalCommentState();
}

class _additionalCommentState extends State<additionalComment> {

 final FirebaseAuth _auth = FirebaseAuth.instance;
 final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
 TextEditingController _textController = new TextEditingController();
 String _message=''; 
 String _givenby='';
 bool isInputEmpty=true;

Widget builddisplaycomment(){
  Size size = MediaQuery.of(context).size;
 return StreamBuilder<QuerySnapshot> (
                      stream: FirebaseFirestore.instance.collection('additionalComment').where('reference_documentid',isEqualTo: widget.documentID)
                      .where('class-code',isEqualTo: widget.code)
                      .orderBy('sent_time').snapshots(),  
                      builder: (BuildContext context, snapshot){ 
                         if(!snapshot.hasData)
                        {
                          return Text('data');        
                         }
                         if(snapshot.hasData&&snapshot.data!.docs.length<1){
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 80),
                              child: Column(
                              children: [
                                Transform.rotate(
                                  angle: 50,
                                  child: Icon(Icons.comment_outlined,
                                  color: Colors.black87.withOpacity(0.2),
                                  size: size.width*0.3,
                                  ),
                                ),
                                SizedBox(height: size.height*0.02),   
                                Text(
                                    'No comments yet',
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
                             {
                               return  CircularProgressIndicator();
                             }
                        if(snapshot.hasData) {
                            return SingleChildScrollView(
                                  child: ListView.builder(  
                                     physics:const  NeverScrollableScrollPhysics(),
                                     reverse: true,
                                     shrinkWrap: true,
                                     itemCount: snapshot.data?.docs.length,
                                     itemBuilder: (context, i )
                                     {
                                      DateTime currentTime= DateTime.now();
                                      Timestamp senttime =snapshot.data?.docs[i]['sent_time'];
                                      DateTime sendertime = senttime.toDate();
                                      String todaytime = DateFormat.jm().format(sendertime);
                                      String fulltime = DateFormat('hh:mm:ss  yyyy-MM-dd').format(sendertime);
                                      String streammessage = snapshot.data?.docs[i]['addtional_comment'];
                                      if((currentTime.year == sendertime.year)
                                          && (currentTime.month == sendertime.month)
                                          && (currentTime.day == sendertime.day))
                                        {
                                      return Padding(
                                      padding: const EdgeInsets.symmetric(vertical:4 ),
                                      child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.black38,
                                        borderRadius: BorderRadius.circular(5),
                                        boxShadow:const [
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
                                      "${snapshot.data?.docs[i]['given_by']}", 
                                      softWrap: true,
                                      style: GoogleFonts.firaSans(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white70,
                                     )
                                     ),
                                        ],
                                        ),
                                         SizedBox(height:10 ),
                                        Text(
                                          todaytime, 
                                          softWrap: true,
                                          style: GoogleFonts.firaSans(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white70,
                                        )
                                        ),
                                        const Divider(
                                            color: Colors.orangeAccent,
                                          ),
                                         Stack(
                                             children: [
                                                 Padding(
                                                   padding: const EdgeInsets.all(2.0),
                                                   child: Text(
                                                    "${snapshot.data?.docs[i]['addtional_comment']}",
                                                     style: GoogleFonts.hindSiliguri(
                                                      fontSize: 18,
                                                      color: Colors.white60,
                                                     ),
                                                    ),
                                                   ), 
                                                ],
                                          ),
                                         ],
                                       ),
                                     ),
                                    );

                                        }
                                      if((currentTime.year==sendertime.year)&&(currentTime.month == sendertime.month)){
                                        if((currentTime.day - sendertime.day) == 1){
                                          return Padding(
                                      padding: const EdgeInsets.symmetric(vertical:4 ),
                                      child: Container(
                                      padding: EdgeInsets.symmetric(vertical: 8,horizontal: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.black38,
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
                                      "${snapshot.data?.docs[i]['given_by']}", 
                                      softWrap: true,
                                      style: GoogleFonts.firaSans(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white70,
                                     )
                                     ),
                                        ],
                                        ),
                                        SizedBox(height:10 ),
                                        Text(
                                          "Yesterday", 
                                          softWrap: true,
                                          style: GoogleFonts.firaSans(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white70,
                                        )
                                        ),
                                        Divider(
                                          color: Colors.orangeAccent,
                                        ),
                                         Stack(
                                             children: [
                                                 Padding(
                                                   padding: const EdgeInsets.all(2.0),
                                                   child: Text(
                                                    "${snapshot.data?.docs[i]['addtional_comment']}",
                                                     style: GoogleFonts.hindSiliguri(
                                                      fontSize: 18,
                                                      color: Colors.white60,
                                                     ),
                                                    ),
                                                   ), 
                                                ],
                                          ),
                                       ],
                                       ),
                                     ),
                                    );
                                          }
                                        else if((currentTime.day - sendertime.day) == -1){
                                          return Text('Tommorow') ;}
                                      else{
                                          return Padding(
                                      padding: const EdgeInsets.symmetric(vertical:4 ),
                                      child: Container(
                                      padding: EdgeInsets.symmetric(vertical: 8,horizontal: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.black38,
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
                                      "${snapshot.data?.docs[i]['given_by']}", 
                                      softWrap: true,
                                      style: GoogleFonts.firaSans(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white70,
                                     )
                                     ),
                                        ],
                                        ),
                                         SizedBox(height:10 ),
                                        Text(
                                          fulltime, 
                                          softWrap: true,
                                          style: GoogleFonts.firaSans(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white70,
                                        )
                                        ),
                                        Divider(
                                          color: Colors.orangeAccent,
                                        ),
                                         Stack(
                                             children: [
                                                 Padding(
                                                   padding: const EdgeInsets.all(2.0),
                                                   child: Text(
                                                    "${snapshot.data?.docs[i]['addtional_comment']}",
                                                     style: GoogleFonts.hindSiliguri(
                                                      fontSize: 18,
                                                      color: Colors.white60,
                                                     ),
                                                    ),
                                                   ), 
                                                ],
                                          ),
                                      
                                         ],
                                       ),
                                     ),
                                    );
                                  }
                                 }
                                return Text("No messages yet!!");  //for non nullable statement
                               },
                              ),
                            );
                          }
                          return Text('no data');
                      },
         );
    }

Widget sendicon(){
  return 
     Transform.scale(
     scale: 1.8,
     child: IgnorePointer(
       ignoring: isInputEmpty,
       child: IconButton(
         icon:const Icon(Icons.send),
         color: isInputEmpty ? Colors.grey : Colors.black,
         onPressed: ()async{
            bool validated=_formKey.currentState?.validate()??false;
            if(!validated)
           return;
            else {
            final User? Cuser = _auth.currentUser;
            final uid = Cuser?.uid;
            _textController.clear();
            final QuerySnapshot Usnap= await  FirebaseFirestore.instance.collection('users').where('personal-id', isEqualTo: uid).get();
            final List<DocumentSnapshot> Udocs=Usnap.docs;
            if(Udocs.length!=0){
                   DocumentSnapshot<Object?>? userDoc=Udocs.last;
                   _givenby=userDoc['name'];
            }
            setState(() {
             isInputEmpty=true;
            });
                 await FirebaseFirestore.instance.collection('additionalComment').add({
                'addtional_comment': _message,
                'personal-id':uid,
                'sent_time':Timestamp.now(),
                'given_by': _givenby,
                'class-code': widget.code,
                'reference_documentid': widget.documentID,
                  });   
                FirebaseFirestore.instance.collection("additionalComment").where('reference_documentid',isEqualTo: widget.documentID).
                get().then((QuerySnapshot querySnapshot){
                int length = querySnapshot.docs.length;
                if(length!=0){
                FirebaseFirestore.instance.collection('comment').doc(widget.documentID).update({'length': length});
                }
                 });
           }
           _textController.clear();
          },
       ),
     ),
    );
}

 Widget textbox(){
   Size size=MediaQuery.of(context).size;
   return Container(
       width: size.width*0.82,
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
            maxHeight: 300,
          ),
          child: TextFormField(
          maxLengthEnforced: true,
          maxLines: 3,
         controller: _textController,
         keyboardType: TextInputType.multiline,
         onChanged: (val) {
           setState(() {
                  _message = val.trim().toString();
                  if(_message.isNotEmpty){  
                     isInputEmpty = false;
                  } else {
                     isInputEmpty = true;
                  }
              });
         },
         style: const TextStyle(
           color: Colors.black87,
         ),
          decoration:const InputDecoration(
           contentPadding: EdgeInsets.fromLTRB(0, 11, 0, 5),
           border: InputBorder.none,
            prefixIcon: Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 26),
              child: Icon(
               Icons.comment,
               color: Colors.black45,
           ),
            ),
          hintText:'Enter your Comment...',
           hintStyle: TextStyle(
             color: Colors.black45,
             
             )
           ),
            validator: (input)
          {   
            if(input!.isEmpty){
                return 'Enter comment!!!';
                 }
             else{
               return null;
             }    
           },
       ) ,
        ),
   );
 }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       backgroundColor: Colors.black,
       title:Text('Comments'),
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
                      Color(0xFF757575),
                      Color(0xFF757575),
                      Color(0xFF757575),
                    ]
                  )
                ),
               child: SingleChildScrollView(
                        physics:const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()), 
                        padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                        ),
                    child: Column(
                     children: <Widget>[
                     builddisplaycomment(),
                    ],
                  ),
                  ), 
                  ),
                    Align(
                      alignment: Alignment.bottomCenter,
                        child: Container(
                          alignment: Alignment.bottomCenter,
                         decoration: const BoxDecoration(
                          gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                              Color(0xFF757575),
                              Color(0xFF757575),
                              Color(0xFF757575),
                            ]
                             )
                            ),
                              height:85,
                              width: MediaQuery.of(context).size.width,
                             child: Padding(
                               padding: const EdgeInsets.symmetric(horizontal: 10,vertical:10),
                               child: Row(
                               mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children:<Widget> [
                                          Form(key:_formKey, child:  Column(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children:<Widget> [
                                             Flexible(
                                                 child: textbox(),
                                             ),])
                                          ),
                                           Flexible(
                                               child: Padding(
                                                 padding: const EdgeInsets.symmetric(vertical: 4),
                                                 child: Align(
                                                   alignment: Alignment.bottomRight,
                                                     child: sendicon(),
                                                   ),
                                               ),
                                               ),
                                           
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