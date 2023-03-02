import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vidyalayaapp/Pages/Sdashboard.dart';
import 'package:vidyalayaapp/Pages/Tdashboard.dart';
import 'package:vidyalayaapp/Pages/demo.dart';
import 'package:vidyalayaapp/Pages/forgotpass.dart';
import 'package:vidyalayaapp/Pages/select_role.dart';
import 'package:vidyalayaapp/Pages/size_config.dart';
import 'package:vidyalayaapp/Pages/welcomepage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final CollectionReference _dref =
      FirebaseFirestore.instance.collection('users');
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  String errorMessage = '';
  bool isRememberme = false;
  String email = '';
  String password = '';
  String role = '';
  String token = '';
  bool _isloading = false;
  ImageProvider? myImage;

  Future tokengeneration() async {
    FirebaseMessaging.instance.getToken().then((value) {
      token = value!;
      if (token != null) {
        final User? user = _auth.currentUser;
        final userid = user?.uid;
        //  FirebaseDatabase.instance.reference().child('tokens').orderByChild(userid!).once().then((value) => token);
        FirebaseFirestore.instance
            .collection('tokens')
            .doc(userid)
            .set({'token-id': token});
      }
    });
  }

  Widget buildEmail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Email',
          style: TextStyle(
              color: Colors.white,
              fontSize: 1.792364990689013 * SizeConfig.textMultiplier,
              fontWeight: FontWeight.w400),
        ),
        SizedBox(height: 1.2 * SizeConfig.heightMultiplier),
        Container(
          alignment: Alignment.centerLeft,
          child: TextFormField(
            autofocus: false,
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: (input) {
              if (!RegExp(r"^[a-zA-Z0-9!#$%&'*+-/=?^_`@{|}~]")
                  .hasMatch(input ?? "")) {
                return 'Enter valid Email';
              }
            },
            style: const TextStyle(color: Colors.white70),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                  vertical: 1.8 * SizeConfig.heightMultiplier),
              border: OutlineInputBorder(
                  borderSide: new BorderSide(color: Colors.orange)),
              enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white38)),
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.cyan)),
              hintText: 'Email',
              hintStyle: TextStyle(
                  fontSize: 1.9 * SizeConfig.textMultiplier,
                  color: Colors.white54),
              prefixIcon: Icon(
                Icons.email,
                color: Colors.white54,
                size: 2.4 * SizeConfig.heightMultiplier,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildPassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Password',
          style: TextStyle(
              color: Colors.white,
              fontSize: 1.792364990689013 * SizeConfig.textMultiplier,
              fontWeight: FontWeight.w400),
        ),
        SizedBox(height: 1.2 * SizeConfig.heightMultiplier),
        Container(
            alignment: Alignment.centerLeft,
            child: TextFormField(
                textAlignVertical: TextAlignVertical.center,
                autofocus: false,
                controller: passwordController,
                obscureText: true,
                validator: (input) {
                  if (input == null) {
                    return 'Password required for login';
                  }
                },
                style: const TextStyle(color: Colors.white70),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                      vertical: 1.8 * SizeConfig.heightMultiplier),
                  border: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white38)),
                  enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white38)),
                  focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.cyan)),
                  helperText: '',
                  hintText: 'Password',
                  hintStyle: TextStyle(
                      fontSize: 1.9 * SizeConfig.textMultiplier,
                      color: Colors.white54),
                  prefixIcon: Icon(
                    Icons.lock,
                    color: Colors.white54,
                    size: 2.4 * SizeConfig.heightMultiplier,
                  ),
                )))
      ],
    );
  }

  Widget buildForgotpassBtn() {
    return Container(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => forgotPassword()));
        },
        child: Text(
          'Forgot Password ?',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 1.8 * SizeConfig.textMultiplier,
          ),
        ),
      ),
    );
  }

  Widget buildLoginBtn(context) {
    return SizedBox(
        width: SizeConfig.isMobilePortrait == true
            ? 42.0 * SizeConfig.widthMultiplier
            : 30.0 * SizeConfig.widthMultiplier,
        height: SizeConfig.isMobilePortrait == true
            ? 45
            : 6.4 * SizeConfig.heightMultiplier,
        child: ElevatedButton(
          onPressed: () async {
            bool validated = this._formKey.currentState!.validate();
            if (validated) {
              //print('${emailController.text} ${passwordController.text}');
              try {
                setState(() {
                  _isloading = true;
                });
                UserCredential user = await _auth.signInWithEmailAndPassword(
                    email: emailController.text,
                    password: passwordController.text);
                print(user);
                final QuerySnapshot snap = await this
                    ._dref
                    .where('email', isEqualTo: emailController.text)
                    .get();
                final List<DocumentSnapshot> docs = snap.docs;
                if (docs.length != 0) {
                  DocumentSnapshot<Object?>? userDoc = docs.last;
                  Fluttertoast.showToast(msg: "Login Succesful");
                  tokengeneration();
                  if (userDoc['role'] == 'teacher') {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                TDashboard(userDoc['name'])));
                  } else
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                SDashboard(userDoc['name'])));
                }
              } on FirebaseAuthException catch (error) {
                setState(() {
                  _isloading = false;
                });
                print(error.code);
                switch (error.code) {
                  case "invalid-email":
                    errorMessage =
                        "Your email address appears to be malformed.";
                    Fluttertoast.showToast(msg: "invalid-email");
                    break;

                  case "wrong-password":
                    errorMessage = "Your password is wrong.";
                    Fluttertoast.showToast(msg: "incorrect email or password");
                    break;

                  case "user-not-found":
                    errorMessage = "User with this email doesn't exist.";
                    Fluttertoast.showToast(msg: "incorrect email or password");
                    break;
                  case "user-disabled":
                    errorMessage = "User with this email has been disabled.";
                    Fluttertoast.showToast(msg: "user is disabled");

                    break;
                  case "too-many-requests":
                    errorMessage = "Too many requests";
                    Fluttertoast.showToast(msg: "too many requests");

                    break;
                  case "operation-not-allowed":
                    errorMessage =
                        "Signing in with Email and Password is not enabled.";
                    Fluttertoast.showToast(
                        msg: 'Signing in with Email and Password not enabled.');
                    break;
                  default:
                    errorMessage = "An undefined Error happened.";
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: Colors.white,
                        content: Text('An undefined Error happened.',
                            style: TextStyle(
                              color: Color(0xFF212121),
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ))));
                }
              }
            }
          },
          child: _isloading
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Loging in...",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 4.5 * SizeConfig.widthMultiplier,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.black,
                      ),
                    ),
                  ],
                )
              : Text(
                  'LOGIN',
                  style: GoogleFonts.montserrat(
                      color: const Color(0xff212121),
                      fontSize: SizeConfig.isMobilePortrait == true
                          ? 5.0 * SizeConfig.widthMultiplier
                          : 4.0 * SizeConfig.widthMultiplier,
                      fontWeight: SizeConfig.isMobilePortrait == true
                          ? FontWeight.bold
                          : FontWeight.w500),
                ),
          style: ElevatedButton.styleFrom(
            primary: Colors.cyan[300],
            onPrimary: Colors.orange,
            elevation: 3,
          ),
        ));
  }

  Widget buildSignUpBtn(context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => SelectRole()));
      },
      child: RichText(
        text: TextSpan(children: [
          TextSpan(
              text: 'Don\'t have a Account?',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: SizeConfig.isMobilePortrait == true
                      ? 1.9 * SizeConfig.textMultiplier
                      : 1.3 * SizeConfig.textMultiplier,
                  fontWeight: FontWeight.w400)),
          TextSpan(
              text: ' Sign Up',
              style: TextStyle(
                  color: Colors.lightBlueAccent,
                  fontSize: SizeConfig.isMobilePortrait == true
                      ? 2.2 * SizeConfig.textMultiplier
                      : 1.9 * SizeConfig.textMultiplier,
                  fontWeight: FontWeight.bold))
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          iconSize: 3.0 * SizeConfig.textMultiplier,
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => const welcomePage()));
          },
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          child: Stack(
            children: <Widget>[
              ShaderMask(
                shaderCallback: (rect) => const LinearGradient(
                  begin: Alignment.center,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black12],
                ).createShader(rect),
                blendMode: BlendMode.darken,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  child: Container(
                    height: size.height,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image:
                                AssetImage('assets/images/loginbackground.jpg'),
                            colorFilter: ColorFilter.mode(
                                Colors.black54, BlendMode.darken),
                            fit: BoxFit.cover,
                            opacity: 0.9)),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      padding: SizeConfig.isMobilePortrait == true
                          ? const EdgeInsets.symmetric(
                              horizontal: 25,
                            )
                          : const EdgeInsets.symmetric(
                              horizontal: 50,
                            ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: size.height * 0.15),
                          Text(
                            'Sign In',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 4.480912476722533 *
                                    SizeConfig.textMultiplier,
                                fontWeight: SizeConfig.isMobilePortrait == true
                                    ? FontWeight.w600
                                    : FontWeight.w500),
                          ),
                          SizedBox(height: size.height * 0.05),
                          Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  buildEmail(),
                                  SizedBox(
                                      height:
                                          2.2 * SizeConfig.heightMultiplier),
                                  buildPassword(),
                                ],
                              )),
                          buildForgotpassBtn(),
                          SizedBox(height: size.height * 0.04),
                          buildLoginBtn(context),
                          SizedBox(height: size.height * 0.03),
                          buildSignUpBtn(context),
                        ],
                      ),
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
