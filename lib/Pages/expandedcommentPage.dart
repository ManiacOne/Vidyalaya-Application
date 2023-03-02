import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vidyalayaapp/Pages/size_config.dart';

class expandedCommentscreen extends StatefulWidget {
  const expandedCommentscreen(this.givenby,this.comment,this.sentTime,this.url,this.length) : super();
  final String givenby;
  final String comment;
  final String sentTime;
  final String url;
  final String length;
  @override
  _expandedCommentscreenState createState() => _expandedCommentscreenState();
}

class _expandedCommentscreenState extends State<expandedCommentscreen> {

  Widget showgivenby(){
    if(widget.url!='None'){
        return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal:2.0*SizeConfig.widthMultiplier,vertical:2.0*SizeConfig.heightMultiplier),
          alignment: Alignment.topLeft,
          child: Text(widget.givenby,
          style: GoogleFonts.firaSans(
                 fontSize: 2.0*SizeConfig.textMultiplier,
                 fontWeight: FontWeight.w500,
                 color: Colors.white70,
                )
          ),
        ),
         Container(
          padding: EdgeInsets.symmetric(horizontal:2.0*SizeConfig.widthMultiplier,vertical:2.0*SizeConfig.heightMultiplier),
           alignment: Alignment.topLeft,
           child: Text(
             widget.sentTime, 
             softWrap: true,
             style: GoogleFonts.firaSans(
             fontSize: 1.5*SizeConfig.textMultiplier,
             fontWeight: FontWeight.w500,
              color: Colors.white70,
               )
            ),
         ),
        
        Divider(
          color: Colors.orangeAccent,thickness: 1,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal:2.0*SizeConfig.widthMultiplier,vertical:2.5*SizeConfig.heightMultiplier),
          alignment: Alignment.topLeft,
          child: Text(widget.comment,
          style: GoogleFonts.balsamiqSans(
                   fontSize: 2.0*SizeConfig.textMultiplier,
                   fontWeight: FontWeight.w500,
                   color: Colors.white70,
                    )
          ),
          ),
          Container(
          padding: EdgeInsets.symmetric(horizontal:2.0*SizeConfig.widthMultiplier,vertical:1.5*SizeConfig.heightMultiplier),
          alignment: Alignment.topLeft,
          child: Text('Material : ',
          style: GoogleFonts.firaSans(
                   fontSize: 2.0*SizeConfig.textMultiplier,
                   fontWeight: FontWeight.w500,
                   color: Colors.white70,
                    )
          ),
          ),
          Container(
          padding: EdgeInsets.symmetric(horizontal:2.0*SizeConfig.widthMultiplier,vertical:2.0*SizeConfig.heightMultiplier),
            child: Row(
            children:<Widget>[
               Expanded(
                 child: RichText(
                   text: TextSpan(
                     children: [
                       TextSpan(
                         text: widget.url,
                         style: GoogleFonts.balsamiqSans(
                           fontSize: 2.0*SizeConfig.textMultiplier,
                           color: Colors.blue,),
                           recognizer: TapGestureRecognizer()..onTap=()async{
                             var linkurl = widget.url;
                             if(await canLaunch(linkurl)){
                               await launch(linkurl);
                             }
                             else{
                               throw "Cannot Launch url";
                             }
                           }
                       )
                     ]
                   ),
                 ),
               ),
               IconButton(
                icon: Icon(
                  Icons.copy
                ),
                tooltip: 'copy to clipboard',
                iconSize: 30,
                color: Colors.green,
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: widget.url));
                  Fluttertoast.showToast(msg: "Code Copied");
                },
                ), 
              ], 
            ),
          ),
          SizedBox(height: 1.0*SizeConfig.heightMultiplier,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal:2.0*SizeConfig.widthMultiplier,
            vertical:2.0*SizeConfig.heightMultiplier),
            child: Text('You can click on the url to navigate to your browser or you can copy the url by clicking the copy icon',
            style: GoogleFonts.firaSans(
              color: Colors.white70,
              fontSize: 2.0*SizeConfig.textMultiplier
            ),),
          )
      ],
    );
    }
    else if(widget.url=='None'){
        return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal:2.0*SizeConfig.widthMultiplier,vertical:2.0*SizeConfig.heightMultiplier),
          alignment: Alignment.topLeft,
          child: Text(widget.givenby,
          style: GoogleFonts.firaSans(
                 fontSize: 2.0*SizeConfig.textMultiplier,
                 fontWeight: FontWeight.w500,
                 color: Colors.white70,
                )
          ),
        ),
         Container(
          padding: EdgeInsets.symmetric(horizontal:2.0*SizeConfig.widthMultiplier,vertical:1.0*SizeConfig.heightMultiplier),
           alignment: Alignment.topLeft,
           child: Text(
             widget.sentTime, 
             softWrap: true,
             style: GoogleFonts.firaSans(
             fontSize: 1.5*SizeConfig.textMultiplier,
             fontWeight: FontWeight.w500,
              color: Colors.white70,
               )
            ),
         ),
        Divider(
          color: Colors.orangeAccent,thickness: 1,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal:2.0*SizeConfig.widthMultiplier,vertical:2.5*SizeConfig.heightMultiplier),
          alignment: Alignment.topLeft,
          child: Text(widget.comment,
          style: GoogleFonts.balsamiqSans(
                   fontSize: 2.0*SizeConfig.textMultiplier,
                   fontWeight: FontWeight.w500,
                   color: Colors.white70,
                    )
          ),
          ),
      ],
    );
    }
    return CircularProgressIndicator();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
        appBar: AppBar(
       backgroundColor: Colors.black,
       title:Text('')),
       body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector( 
          child: Stack(
            children: <Widget>[
              SizedBox(
                  height:double.infinity,
                  width:double.infinity ,
               child: SingleChildScrollView(
                        physics:const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()), 
                         padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                         ),
                    child: Column(
                     mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        showgivenby(),
                 ],
               ),
              ), 
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  color: Colors.grey[850],
                  height:5.5*SizeConfig.heightMultiplier,
                  width: MediaQuery.of(context).size.width,
                  child: MaterialButton(
                    onPressed: (){},
                    child: widget.length=='0'?Text('No comments were added',
                           style: GoogleFonts.roboto(
                             color: Colors.white,
                             fontSize: 2.2*SizeConfig.textMultiplier,
                           )):
                           Text(widget.length+ ' comments were added',
                           style: GoogleFonts.roboto(
                             color: Colors.white,
                             fontSize: 2.2*SizeConfig.textMultiplier,
                           )),
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