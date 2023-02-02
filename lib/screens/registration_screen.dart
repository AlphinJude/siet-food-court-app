import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_court/screens/home_screen.dart';
import 'package:food_court/screens/otp_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String _countryCode = "+91";
  String _phoneNumber = "0";

  void _setCountryCode(data) {
    setState(() {
      _countryCode = data;
    });
  }

  void _setPhoneNumber(data) {
    setState(() {
      _phoneNumber = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MyAppBar(),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: double.infinity,
                height: size.height * 0.05,
              ),
              Image.asset(
                'assets/images/logo.png',
                scale: 1,
              ),
              SizedBox(
                width: double.infinity,
                height: size.height * 0.02,
              ),
              Text(
                'Sri Shakthi Food Court',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -2,
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: size.height * 0.05,
              ),
              Text(
                'REGISTER',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -1.5,
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: size.height * 0.01,
              ),
              Text(
                'Enter your phone number to continue,\nwe\'ll send you an OTP to verify.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                  letterSpacing: -1,
                ),
              ),
            ],
          ),
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  width: size.width * 0.9,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.0),
                    border: Border.all(width: 0.5, color: Colors.grey),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        spreadRadius: -5,
                        blurRadius: 10,
                        offset: Offset(4, 4),
                      ),
                    ],
                  ),
                  child: TextField(
                    style: TextStyle(letterSpacing: 5),
                    decoration: InputDecoration(
                      icon: CountryCodePicker(
                        initialSelection: 'IN',
                        onChanged: (data) {
                          _setCountryCode(data.dialCode);
                        },
                        // dialogBackgroundColor: backgroundColor,
                        dialogSize: Size(size.width * 0.9, size.height * 0.87),
                        flagWidth: 40,
                        padding: EdgeInsets.all(0),
                      ),
                      hintText: "Phone Number",
                      border: InputBorder.none,
                    ),
                    keyboardType: TextInputType.numberWithOptions(),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    onChanged: (data) {
                      _setPhoneNumber(data);
                    },
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: size.height * 0.13,
                ),
                RegisterButton(
                  size: size,
                  label: 'Request OTP',
                  countryCode: _countryCode,
                  phoneNumber: _phoneNumber,
                ),
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
}

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: [
        LanguageButton(),
        IconButton(onPressed: () {}, icon: Icon(Icons.more_vert_rounded)),
      ],
      backgroundColor: Colors.black,
      systemOverlayStyle: SystemUiOverlayStyle.light,
    );
  }
}

class LanguageButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: OutlinedButton.icon(
        icon: Icon(
          Icons.language_rounded,
          size: 20,
        ),
        label: Text(
          "English",
          style: TextStyle(fontSize: 14),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            width: 0.5,
            color: Colors.white,
          ),
          primary: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
        ),
        onPressed: () {},
      ),
    );
  }
}

class RegisterButton extends StatelessWidget {
  const RegisterButton({
    Key? key,
    required this.size,
    this.icon,
    required this.label,
    required this.countryCode,
    required this.phoneNumber,
  }) : super(key: key);

  final Size size;
  final Icon? icon;
  final String label;
  final String countryCode;
  final String phoneNumber;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (phoneNumber.length == 10) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return OTPScreen(
                    countryCode: countryCode, phoneNumber: phoneNumber);
                // return HomePage(title: 'Sri Shakthi Food Court');
              },
            ),
          );
        } else {
          final snackBar = SnackBar(
            content: const Text("Please provide a valid Phone Number"),
            width: size.width * 0.95,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(3),
            ),
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
              label: "OK",
              onPressed: () {},
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
      child: Text(
        label,
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
