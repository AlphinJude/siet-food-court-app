// import 'dart:html';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_court/screens/home_screen.dart';

enum Status { Waiting, Error }

class OTPScreen extends StatefulWidget {
  const OTPScreen({
    Key? key,
    required this.countryCode,
    required this.phoneNumber,
  }) : super(key: key);

  final String countryCode;
  final String phoneNumber;

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final _formKey = GlobalKey<FormState>();
  String verificationId = "";
  String otp = "", authStatus = "";
  Status _status = Status.Waiting;

  FirebaseAuth auth = FirebaseAuth.instance;
  PhoneAuthCredential credential =
      PhoneAuthProvider.credential(verificationId: "", smsCode: "");

  FocusNode focusNode = FocusNode();

  @override
  void dispose() {
    focusNode.dispose();

    super.dispose();
  }

  Future<void> verifyPhoneNumber(BuildContext context) async {
    await auth.verifyPhoneNumber(
      phoneNumber: widget.countryCode + widget.phoneNumber,
      timeout: const Duration(seconds: 120),
      verificationCompleted: (PhoneAuthCredential cred) {
        credential = cred;
        setState(() {
          authStatus = "Your account is successfully verified";
        });
      },
      verificationFailed: (FirebaseAuthException authException) {
        if (authException.code == 'invalid-phone-number') {
          authStatus = 'The provided phone number is not valid.';
          print('The provided phone number is not valid.');
        }
        setState(() {
          authStatus = 'Authentication failed!';
        });
      },
      codeSent: (String verId, int? forceCodeResent) {
        String smsCode = otp;

        setState(() {
          credential = PhoneAuthProvider.credential(
            verificationId: verId,
            smsCode: smsCode,
          );
          verificationId = verId;
          authStatus = "OTP has been successfully sent!";
        });
      },
      codeAutoRetrievalTimeout: (String verId) {
        verificationId = verId;
        setState(() {
          authStatus = "TIMEOUT";
        });
      },
    );
  }

  Future<void> signIn(String? code) async {
    var _credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: code!,
    );

    await auth
        .signInWithCredential(_credential)
        .then((value) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return HomePage(title: 'Sri Shakthi Food Court');
              },
            ),
          );
        })
        .whenComplete(() {})
        .onError((error, stackTrace) {
          setState(() {
            _status = Status.Error;
          });
        });
    setState(() {
      authStatus = "Your account is successfully verified";
    });
  }

  @override
  void initState() {
    super.initState();
    verifyPhoneNumber(context);
  }

  void setOTP(data) {
    setState(() {
      otp = data;
    });
    print(otp);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: MyAppBar(),
      body: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: double.infinity,
                height: size.height * 0.1,
              ),
              Text(
                "Enter your OTP",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -2,
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: size.height * 0.01,
              ),
              Text(
                'We have sent a verification code to\n' +
                    widget.countryCode +
                    " " +
                    widget.phoneNumber,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                  letterSpacing: -1,
                  height: 1.5,
                ),
              ),
              SizedBox(height: size.height * 0.03),
              buildOTPForm(context, _formKey, focusNode, otp),
              SizedBox(
                height: 20,
              ),
              Text("Test $otp"),
            ],
          ),
          Container(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                buildVerifyButton(size, credential),
                SizedBox(
                  width: double.infinity,
                  height: size.height * 0.07,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildOTPForm(context, formKey, focusNode, otp) {
    Size size = MediaQuery.of(context).size;

    String pin1 = "", pin2 = "", pin3 = "", pin4 = "", pin5 = "", pin6 = "";

    _setOTP() {
      String data = pin1 + pin2 + pin3 + pin4 + pin5 + pin6;
      setOTP(data);
    }

    return Form(
      key: formKey,
      child: Container(
        width: size.width * 0.9,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(
              height: 51,
              width: 52,
              child: TextFormField(
                autofocus: true,
                focusNode: focusNode,
                onSaved: (value) {
                  pin1 = value!;
                },
                onChanged: (value) {
                  if (value.length == 1) {
                    focusNode.nextFocus();
                  } else if (value.length == 0) {
                    setState(() {
                      otp = "";
                    });
                  }
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(0),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                  hintText: "0",
                  filled: true,
                  fillColor: Colors.black12,
                  focusColor: Colors.black38,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.transparent,
                      width: 1,
                    ),
                  ),
                ),
                style: Theme.of(context).textTheme.headline6,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(1),
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
            ),
            SizedBox(
              height: 51,
              width: 52,
              child: TextFormField(
                onSaved: (value) {
                  pin2 = value!;
                },
                onChanged: (value) {
                  if (value.length == 1) {
                    focusNode.nextFocus();
                  } else if (value.length == 0) {
                    focusNode.previousFocus();
                  }
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(0),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                  hintText: "0",
                  filled: true,
                  fillColor: Colors.black12,
                  focusColor: Colors.black38,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.transparent,
                      width: 1,
                    ),
                  ),
                ),
                style: Theme.of(context).textTheme.headline6,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(1),
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
            ),
            SizedBox(
              height: 51,
              width: 52,
              child: TextFormField(
                onSaved: (value) {
                  pin3 = value!;
                },
                onChanged: (value) {
                  if (value.length == 1) {
                    focusNode.nextFocus();
                  } else if (value.length == 0) {
                    focusNode.previousFocus();
                  }
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(0),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                  hintText: "0",
                  filled: true,
                  fillColor: Colors.black12,
                  focusColor: Colors.black38,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.transparent,
                      width: 1,
                    ),
                  ),
                ),
                style: Theme.of(context).textTheme.headline6,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(1),
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
            ),
            SizedBox(
              height: 51,
              width: 52,
              child: TextFormField(
                onSaved: (value) {
                  pin4 = value!;
                },
                onChanged: (value) {
                  if (value.length == 1) {
                    focusNode.nextFocus();
                  } else if (value.length == 0) {
                    focusNode.previousFocus();
                  }
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(0),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                  hintText: "0",
                  filled: true,
                  fillColor: Colors.black12,
                  focusColor: Colors.black38,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.transparent,
                      width: 1,
                    ),
                  ),
                ),
                style: Theme.of(context).textTheme.headline6,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(1),
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
            ),
            SizedBox(
              height: 51,
              width: 52,
              child: TextFormField(
                onSaved: (value) {
                  pin5 = value!;
                },
                onChanged: (value) {
                  if (value.length == 1) {
                    focusNode.nextFocus();
                  } else if (value.length == 0) {
                    focusNode.previousFocus();
                  }
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(0),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                  hintText: "0",
                  filled: true,
                  fillColor: Colors.black12,
                  focusColor: Colors.black38,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.transparent,
                      width: 1,
                    ),
                  ),
                ),
                style: Theme.of(context).textTheme.headline6,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(1),
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
            ),
            SizedBox(
              height: 51,
              width: 52,
              child: TextFormField(
                onSaved: (value) {
                  pin6 = value!;
                },
                onChanged: (value) {
                  if (value.length == 1) {
                    _formKey.currentState!.save();
                    _setOTP();
                    print(otp);
                    signIn(otp);
                  }
                  if (value.length == 0) {
                    focusNode.previousFocus();
                  }
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(0),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                  hintText: "0",
                  filled: true,
                  fillColor: Colors.black12,
                  focusColor: Colors.black38,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.transparent,
                      width: 1,
                    ),
                  ),
                ),
                style: Theme.of(context).textTheme.headline6,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(1),
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildVerifyButton(size, PhoneAuthCredential cred) {
    return ElevatedButton(
      onPressed: () {
        print(otp);
        signIn(otp);
        // if (authStatus == "Your account is successfully verified") {
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) {
        //         return HomePage(title: 'Sri Shakthi Food Court');
        //       },
        //     ),
        //   );
        // } else {
        //   final snackBar = SnackBar(
        //     content: Text(authStatus),
        //   );
        //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
        // }
      },
      child: Text(
        "Verify",
        style: TextStyle(fontSize: 18),
      ),
      style: ElevatedButton.styleFrom(
        primary: Colors.black,
        minimumSize: Size(size.width * 0.9, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
      ),
    );
  }
}

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text("Sri Shakthi Food Court"),
      backgroundColor: Colors.black,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    );
  }
}
