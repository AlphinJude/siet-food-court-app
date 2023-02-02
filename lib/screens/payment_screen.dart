import 'package:flutter/material.dart';
import 'package:food_court/notifier/cart_notifier.dart';
import 'package:pay/pay.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter_customui/razorpay_flutter_customui.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late Razorpay _razorpay = Razorpay();
  final _paymentItems = <PaymentItem>[];
  String? upiID;

  void initState() {
    _razorpay = Razorpay();

    super.initState();
  }

  void onGooglePayResult(paymentResult) {
    debugPrint(paymentResult.toString());
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    CartNotifier cartNotifier = Provider.of<CartNotifier>(context);
    _paymentItems.add(
      PaymentItem(
        amount: cartNotifier.total.toString(),
        label: "Sri Shakthi Food Court",
        status: PaymentItemStatus.final_price,
      ),
    );
    return Scaffold(
      appBar: MyAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: size.height * 0.02),
          ListView(
            shrinkWrap: true,
            children: [
              ListTile(
                minVerticalPadding: 10,
                title: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "UPI",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                subtitle: TextField(
                  decoration: InputDecoration(
                    hintText: "Enter your UPI ID",
                    prefixIcon: Image.asset(
                      "assets/images/upi-logo.png",
                      scale: 10,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: 15,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black38,
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black45,
                        width: 2,
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    this.upiID = value;
                  },
                ),
              ),
              ListTile(
                minVerticalPadding: 10,
                title: GooglePayButton(
                  paymentConfigurationAsset:
                      'default_payment_profile_google_pay.json',
                  paymentItems: _paymentItems,
                  height: 50,
                  type: GooglePayButtonType.pay,
                  // margin: const EdgeInsets.only(top: 15.0),
                  onPaymentResult: onGooglePayResult,
                  loadingIndicator: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
              ListTile(
                minVerticalPadding: 10,
                contentPadding: EdgeInsets.symmetric(horizontal: 20),
                horizontalTitleGap: 2,
                leading: Icon(
                  Icons.currency_rupee_rounded,
                  size: 30,
                ),
                title: Text(
                  "Cash",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text("Pay with cash"),
                trailing: Icon(
                  Icons.navigate_next_rounded,
                  size: 30,
                ),
              ),
              ListTile(
                minVerticalPadding: 10,
                title: ApplePayButton(
                  paymentConfigurationAsset:
                      'default_payment_profile_apple_pay.json',
                  paymentItems: _paymentItems,
                  height: 45,
                  style: ApplePayButtonStyle.black,
                  type: ApplePayButtonType.order,
                  // margin: const EdgeInsets.only(top: 15.0),
                  onPaymentResult: (data) {
                    print(data);
                  },
                  loadingIndicator: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            ],
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
      title: Text("Sri Shakthi Food Court"),
      actions: [
        IconButton(
          icon: Icon(Icons.more_vert_rounded),
          onPressed: () {},
        ),
      ],
      backgroundColor: Colors.black,
      brightness: Brightness.dark,
    );
  }
}
