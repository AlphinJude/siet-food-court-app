import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_court/api/shop_api.dart';
import 'package:food_court/notifier/shop_notifier.dart';
import 'package:food_court/screens/menu.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
// import 'dart:ui';

import 'package:food_court/storage_service.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    ShopNotifier shopNotifier =
        Provider.of<ShopNotifier>(context, listen: false);
    getShops(shopNotifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Storage storage = Storage();
    final Stream<QuerySnapshot> _shopStream =
        FirebaseFirestore.instance.collection('shops').snapshots();
    ShopNotifier shopNotifier = Provider.of<ShopNotifier>(context);

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: MyAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: double.infinity,
            height: size.height * 0.03,
          ),
          Text(
            'Welcome, Richard Sanchez!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            "What's on your mind for breakfast today?",
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          SizedBox(
            width: double.infinity,
            height: size.height * 0.03,
          ),
          Expanded(
            child: Container(
              child: ListView.separated(
                // shrinkWrap: true,
                itemCount: shopNotifier.shopList.length,
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    width: double.infinity,
                    height: size.height * 0.03,
                  );
                },
                itemBuilder: (BuildContext context, int index) {
                  return Flex(
                    direction: Axis.vertical,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return MenuPage(
                                  title:
                                      shopNotifier.shopList[index].displayName,
                                  name: shopNotifier.shopList[index].name,
                                  slogan: shopNotifier.shopList[index].slogan,
                                  categories:
                                      shopNotifier.shopList[index].categories,
                                );
                              },
                            ),
                          );
                        },
                        child: FutureBuilder(
                          future: storage.downloadURL(
                              shopNotifier.shopList[index].name +
                                  '-background.jpg'),
                          builder: (BuildContext context,
                              AsyncSnapshot<String> snapshot) {
                            if (snapshot.connectionState ==
                                    ConnectionState.done &&
                                snapshot.hasData) {
                              return Hero(
                                tag: 'banner' +
                                    shopNotifier.shopList[index].name,
                                child: Container(
                                  width: size.width * 0.9,
                                  height: size.height *
                                      0.7 /
                                      shopNotifier.shopList.length,
                                  alignment: Alignment.center,
                                  child: Text(
                                    shopNotifier.shopList[index].displayName,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 35,
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.black,
                                    image: DecorationImage(
                                      image: NetworkImage(snapshot.data!),
                                      colorFilter: ColorFilter.mode(
                                        Colors.black38,
                                        BlendMode.darken,
                                      ),
                                      fit: BoxFit.cover,
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
                            } else if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else {
                              return Container(
                                width: size.width * 0.9,
                                height: size.height *
                                    0.6 /
                                    shopNotifier.shopList.length,
                                alignment: Alignment.center,
                                child: Text(""),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.black,
                                  image: DecorationImage(
                                    image: AssetImage("assets/images/404.png"),
                                    fit: BoxFit.cover,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey,
                                      spreadRadius: 3,
                                      blurRadius: 5,
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: size.height * 0.02,
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
      leading: IconButton(
        icon: Icon(Icons.menu),
        tooltip: "Menu",
        onPressed: () {},
      ),
      title: Text("Sri Shakthi Food Court"),
      actions: [
        IconButton(
          icon: Icon(Icons.account_circle_rounded),
          onPressed: () {},
        ),
      ],
      backgroundColor: Colors.black,
      systemOverlayStyle: SystemUiOverlayStyle.light,
    );
  }
}


// Expanded(
//             child: InkWell(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) {
//                       return MenuPage(
//                           title: "Juice",
//                           slogan: "Need a refreshment? We've got you covered.");
//                     },
//                   ),
//                 );
//               },
//               child: FutureBuilder(
//                 future: storage.downloadURL('juice-background.jpg'),
//                 builder:
//                     (BuildContext context, AsyncSnapshot<String> snapshot) {
//                   if (snapshot.connectionState == ConnectionState.done &&
//                       snapshot.hasData) {
//                     return Container(
//                       width: size.width * 0.9,
//                       alignment: Alignment.center,
//                       child: Text(
//                         "Juice",
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 35,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(20),
//                         color: Colors.black,
//                         image: DecorationImage(
//                           image: NetworkImage(snapshot.data!),
//                           colorFilter: ColorFilter.mode(
//                             Colors.black38,
//                             BlendMode.darken,
//                           ),
//                           fit: BoxFit.cover,
//                         ),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.grey,
//                             spreadRadius: 3,
//                             blurRadius: 5,
//                           ),
//                         ],
//                       ),
//                     );
//                   } else if (snapshot.connectionState ==
//                       ConnectionState.waiting) {
//                     return Center(child: CircularProgressIndicator());
//                   } else {
//                     return Container(
//                       width: size.width * 0.9,
//                       alignment: Alignment.center,
//                       child: Text(
//                         "",
//                       ),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(20),
//                         color: Colors.black,
//                         image: DecorationImage(
//                           image: AssetImage("assets/images/404.png"),
//                           fit: BoxFit.cover,
//                         ),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.grey,
//                             spreadRadius: 3,
//                             blurRadius: 5,
//                           ),
//                         ],
//                       ),
//                     );
//                   }
//                 },
//               ),
//             ),
//           ),
//           SizedBox(
//             width: double.infinity,
//             height: size.height * 0.03,
//           ),
//           Expanded(
//             child: InkWell(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) {
//                       return MenuPage(
//                         title: "Cha'karam Cafe",
//                         slogan: "For your Chai and Kaaram",
//                       );
//                     },
//                   ),
//                 );
//               },
//               child: FutureBuilder(
//                 future: storage.downloadURL('chakaram-background.jpg'),
//                 builder:
//                     (BuildContext context, AsyncSnapshot<String> snapshot) {
//                   if (snapshot.connectionState == ConnectionState.done &&
//                       snapshot.hasData) {
//                     print(snapshot.data!);
//                     return Container(
//                       width: size.width * 0.9,
//                       alignment: Alignment.center,
//                       child: Text(
//                         "Cha'karam",
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 35,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(20),
//                         color: Colors.black,
//                         image: DecorationImage(
//                           image: NetworkImage(snapshot.data!),
//                           colorFilter: ColorFilter.mode(
//                             Colors.black38,
//                             BlendMode.darken,
//                           ),
//                           fit: BoxFit.cover,
//                         ),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.grey,
//                             spreadRadius: 3,
//                             blurRadius: 5,
//                           ),
//                         ],
//                       ),
//                     );
//                   } else if (snapshot.connectionState ==
//                       ConnectionState.waiting) {
//                     return Center(child: CircularProgressIndicator());
//                   } else {
//                     return Container(
//                       width: size.width * 0.9,
//                       alignment: Alignment.center,
//                       child: Text(
//                         "",
//                       ),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(20),
//                         color: Colors.black,
//                         image: DecorationImage(
//                           image: AssetImage("assets/images/404.png"),
//                           fit: BoxFit.cover,
//                         ),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.grey,
//                             spreadRadius: 3,
//                             blurRadius: 5,
//                           ),
//                         ],
//                       ),
//                     );
//                   }
//                 },
//               ),
//             ),
//           ),