import 'package:flutter/material.dart';
import 'package:food_court/model/item.dart';
import 'package:food_court/notifier/cart_notifier.dart';
import 'package:food_court/screens/payment_screen.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    CartNotifier cartNotifier = Provider.of<CartNotifier>(context);
    // Map<Item, int> _items = cartNotifier.allItems;
    List<Item> itemList = cartNotifier.itemList;

    return Scaffold(
      appBar: MyAppBar(),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: size.height * 0.03,
                ),
                Text(
                  'Cart',
                  style: TextStyle(fontSize: 50, fontWeight: FontWeight.w600),
                ),
                Text('Let\'s review your order'),
                SizedBox(
                  height: size.height * 0.03,
                ),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                      title: Text(
                        itemList[index].name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        '₹ ' + itemList[index].price,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.remove),
                            tooltip: "Remove Item",
                            onPressed: () => setState(() {
                              cartNotifier.removeFromCart(itemList[index]);
                            }),
                          ),
                          Text(
                            cartNotifier
                                .getItemCount(itemList[index])
                                .toString(),
                            style: TextStyle(fontSize: 20),
                          ),
                          IconButton(
                            icon: Icon(Icons.add),
                            tooltip: "Add Item",
                            onPressed: () => setState(() {
                              cartNotifier.addToCart(itemList[index]);
                            }),
                          ),
                        ],
                      ),
                    );
                  },
                  itemCount: cartNotifier.length,
                ),
                SizedBox(
                  height: size.height * 0.1,
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                CheckoutButton(size: size, total: cartNotifier.total),
                SizedBox(
                  height: size.height * 0.035,
                )
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

class CheckoutButton extends StatelessWidget {
  const CheckoutButton({
    Key? key,
    required this.size,
    required this.total,
  }) : super(key: key);

  final Size size;
  final double total;

  @override
  Widget build(BuildContext context) {
    if (total > 0)
      return ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return PaymentScreen();
              },
            ),
          );
        },
        // icon: Icon(Icons.done_rounded),
        child: Text(
          "Proceed To Pay ₹" + total.toString(),
          style: TextStyle(fontSize: 18),
        ),
        style: ElevatedButton.styleFrom(
          primary: Colors.black,
          minimumSize: Size(size.width * 0.95, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
          ),
        ),
      );
    else
      return SizedBox();
  }
}
