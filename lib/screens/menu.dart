import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_court/api/item_api.dart';
import 'package:food_court/notifier/cart_notifier.dart';
import 'package:food_court/notifier/item_notifier.dart';
import 'package:food_court/notifier/shop_notifier.dart';
import 'package:food_court/screens/cart_screen.dart';
import 'package:food_court/storage_service.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_court/model/item.dart';

class MenuPage extends StatefulWidget {
  MenuPage({
    Key? key,
    required this.title,
    required this.name,
    required this.slogan,
    required this.categories,
  }) : super(key: key);

  final String title;
  final String name;
  final String slogan;
  final List<String> categories;

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  void initState() {
    ItemNotifier itemNotifier =
        Provider.of<ItemNotifier>(context, listen: false);
    getItems(itemNotifier, widget.name);
    CartNotifier cartNotifier =
        Provider.of<CartNotifier>(context, listen: false);
    print(widget.name + 'menu-page');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final Stream<QuerySnapshot> _itemStream = FirebaseFirestore.instance
    //     .collection(widget.title + '/menu')
    //     .snapshots();
    ItemNotifier itemNotifier = Provider.of<ItemNotifier>(context);
    final Storage storage = Storage();
    Size size = MediaQuery.of(context).size;
    Map<Item, int> cart = {};

    CartNotifier cartNotifier = Provider.of<CartNotifier>(context);

    return Scaffold(
      appBar: MyAppBar(),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            // child: StreamBuilder<QuerySnapshot>(
            //   stream: _itemStream,
            //   builder: (BuildContext context,
            //       AsyncSnapshot<QuerySnapshot> snapshot) {
            //     if (snapshot.hasError) {
            //       return Text('Something went wrong');
            //     }

            //     if (snapshot.connectionState == ConnectionState.waiting) {
            //       return Text("Loading");
            //     }

            //     return ListView(
            //       shrinkWrap: true,
            //       children:
            //           snapshot.data!.docs.map((DocumentSnapshot document) {
            //         Map<String, dynamic> data =
            //             document.data()! as Map<String, dynamic>;
            //         return ListTile(
            //           title: Text(data['name']),
            //           subtitle: Text(data['price']),
            //         );
            //       }).toList(),
            //     );
            //   },
            // ),
            child: Column(
              children: [
                FutureBuilder(
                  future: storage.downloadURL(widget.name + '-background.jpg'),
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.hasData) {
                      return ShopBanner(
                        widget: widget,
                        size: size,
                        image: CachedNetworkImageProvider(snapshot.data!),
                      );
                      // NetworkImage(snapshot.data!)
                    } else {
                      return ShopBanner(widget: widget, size: size);
                    }
                  },
                ),
                SizedBox(
                  height: 30,
                ),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int _index) {
                    List<Item> _items = [];
                    itemNotifier.itemList.forEach((_item) {
                      if (_item.category == widget.categories[_index])
                        _items.add(_item);
                    });
                    return Column(
                      children: [
                        Container(
                          width: size.width * 0.95,
                          child: Text(
                            widget.categories[_index],
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 20),
                              title: Text(
                                _items[index].name,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                '₹ ' + _items[index].price,
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
                                      cartNotifier
                                          .removeFromCart(_items[index]);
                                    }),
                                  ),
                                  Text(
                                    cartNotifier
                                        .getItemCount(_items[index])
                                        .toString(),
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.add),
                                    tooltip: "Add Item",
                                    onPressed: () => setState(() {
                                      cartNotifier.addToCart(_items[index]);
                                    }),
                                  ),
                                ],
                              ),
                            );

                            // return CircularProgressIndicator();
                          },
                          itemCount: _items.length,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    );
                  },
                  itemCount: widget.categories.length,
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
              children: [
                ProceedButton(
                  size: size,
                  icon: Icon(Icons.shopping_cart_rounded),
                  label: "Proceed To Cart",
                  cart: cartNotifier.allItems,
                ),
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

class MenuList extends StatelessWidget {
  const MenuList({
    Key? key,
    required this.widget,
    required this.size,
  }) : super(key: key);

  final MenuPage widget;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ShopBanner(widget: widget, size: size),
        SizedBox(
          height: 30,
        ),
        Container(
          width: size.width * 0.95,
          child: Text(
            "Drinks",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 20),
          title: Text(
            "Apple Juice",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            "₹ 40.00",
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
                onPressed: () {},
              ),
              Text(
                "0",
                style: TextStyle(fontSize: 20),
              ),
              IconButton(
                icon: Icon(Icons.add),
                tooltip: "Add Item",
                onPressed: () {},
              ),
            ],
          ),
        ),
        ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 20),
          title: Text(
            "Apple Juice",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            "₹ 40.00",
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
                onPressed: () {},
              ),
              Text(
                "0",
                style: TextStyle(fontSize: 20),
              ),
              IconButton(
                icon: Icon(Icons.add),
                tooltip: "Add Item",
                onPressed: () {},
              ),
            ],
          ),
        ),
        ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 20),
          title: Text(
            "Pineapple Juice",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            "₹ 40.00",
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
                onPressed: () {},
              ),
              Text(
                "0",
                style: TextStyle(fontSize: 20),
              ),
              IconButton(
                icon: Icon(Icons.add),
                tooltip: "Add Item",
                onPressed: () {},
              ),
            ],
          ),
        ),
        ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 20),
          title: Text(
            "Apple Juice",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            "₹ 40.00",
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
                onPressed: () {},
              ),
              Text(
                "0",
                style: TextStyle(fontSize: 20),
              ),
              IconButton(
                icon: Icon(Icons.add),
                tooltip: "Add Item",
                onPressed: () {},
              ),
            ],
          ),
        ),
        ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 20),
          title: Text(
            "Apple Juice",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            "₹ 40.00",
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
                onPressed: () {},
              ),
              Text(
                "0",
                style: TextStyle(fontSize: 20),
              ),
              IconButton(
                icon: Icon(Icons.add),
                tooltip: "Add Item",
                onPressed: () {},
              ),
            ],
          ),
        ),
        ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 20),
          title: Text(
            "Apple Juice",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            "₹ 40.00",
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
                onPressed: () {},
              ),
              Text(
                "0",
                style: TextStyle(fontSize: 20),
              ),
              IconButton(
                icon: Icon(Icons.add),
                tooltip: "Add Item",
                onPressed: () {},
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          width: size.width * 0.95,
          child: Text(
            "Snack",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 20),
          title: Text(
            "Apple Juice",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            "₹ 40.00",
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
                onPressed: () {},
              ),
              Text(
                "0",
                style: TextStyle(fontSize: 20),
              ),
              IconButton(
                icon: Icon(Icons.add),
                tooltip: "Add Item",
                onPressed: () {},
              ),
            ],
          ),
        ),
        ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 20),
          title: Text(
            "Apple Juice",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            "₹ 40.00",
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
                onPressed: () {},
              ),
              Text(
                "0",
                style: TextStyle(fontSize: 20),
              ),
              IconButton(
                icon: Icon(Icons.add),
                tooltip: "Add Item",
                onPressed: () {},
              ),
            ],
          ),
        ),
        ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 20),
          title: Text(
            "Apple Juice",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            "₹ 40.00",
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
                onPressed: () {},
              ),
              Text(
                "0",
                style: TextStyle(fontSize: 20),
              ),
              IconButton(
                icon: Icon(Icons.add),
                tooltip: "Add Item",
                onPressed: () {},
              ),
            ],
          ),
        ),
        SizedBox(
          height: size.height * 0.15,
        )
      ],
    );
  }
}

class ProceedButton extends StatelessWidget {
  const ProceedButton({
    Key? key,
    required this.size,
    required this.icon,
    required this.label,
    required this.cart,
  }) : super(key: key);

  final Size size;
  final Icon icon;
  final String label;
  final Map<Item, int> cart;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return CartScreen();
            },
          ),
        );
      },
      icon: icon,
      label: Text(
        label,
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
  }
}

class ShopBanner extends StatelessWidget {
  const ShopBanner({
    Key? key,
    required this.widget,
    required this.size,
    this.image = const AssetImage('assets/images/black.jpg'),
  }) : super(key: key);

  final MenuPage widget;
  final Size size;
  final ImageProvider image;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'banner' + widget.name,
      child: Container(
        height: 100,
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              widget.title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.none,
              ),
            ),
            SizedBox(
              height: size.height * 0.002,
            ),
            Text(widget.slogan,
                style: TextStyle(
                  color: Colors.grey[350],
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.none,
                )),
          ],
        ),
        decoration: BoxDecoration(
          color: Colors.black,
          image: DecorationImage(
            image: image,
            colorFilter: ColorFilter.mode(
              Colors.black54,
              BlendMode.darken,
            ),
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              spreadRadius: 3,
              blurRadius: 5,
            ),
          ],
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
      actions: [
        IconButton(
          icon: Icon(Icons.account_circle_rounded),
          onPressed: () {},
        ),
      ],
      backgroundColor: Colors.black,
      brightness: Brightness.dark,
    );
  }
}
