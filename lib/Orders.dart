import 'package:coffee_shop/Favorites.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_shop/Profile.dart';
import 'package:coffee_shop/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';                                    // new
import 'package:firebase_core/firebase_core.dart'; // new
import 'package:firebase_auth/firebase_auth.dart'; // new
import 'package:fluttertoast/fluttertoast.dart';   // new
import 'package:coffee_shop/Coffee.dart';

class getinfo extends StatelessWidget{
  final FirebaseAuth auth = FirebaseAuth.instance;

  String uid(){
    final User? user = auth.currentUser;
    final userid =user!.uid;
    String u_id = userid;
    return 'Your UID : $u_id';
  }

  @override
  Widget build(BuildContext context) {

    List<String> productname_order = <String>[];
    List<String> productdescription_order = <String>[];
    List<String> productprice_order = <String>[];
    List<bool> productfavorited_order = <bool>[];


    //favorites ->
    List<String> productname_favorites = <String>[];
    List<String> productdescription_favorites = <String>[];
    List<String> productprice_favorites = <String>[];

    //we should scrap all data from orders ->
    CollectionReference collectiontogetOrders = FirebaseFirestore.instance.collection('users').doc(uid()).collection('orders');

    Future<void> getDatafromOrders() async {
      // Get docs from collection reference
      QuerySnapshot querySnapshot = await collectiontogetOrders.get();

      // Get data from docs and it will be json string
      final allData = querySnapshot.docs.map((doc) => doc.data()).toString();
      //show json string ->
      String workingstring = allData.substring(1,allData.length-1).replaceAll(":", "").replaceAll("{", "").replaceAll("}", "");

      for (String a in workingstring.split(", ")) {
        //show data -->
        if(a!=""){
          //if we have any value -->
          String work =a.substring(7,a.length);
          if(work.substring(0,1)=="n"){
            //if value is name ->
            String data = work.substring(5,work.length);
            productname_order.add(data);
          }
          if(work.substring(0,1)=="d"){
            //if value is description ->
            String data = work.substring(12,work.length);
            productdescription_order.add(data);
          }
          if(work.substring(0,1)=="p"){
            //if value is price ->
            String data = work.substring(6,work.length);
            productprice_order.add(data);
          }
          if(work.substring(0,1)=="f"){
            //if value is favorited ->
            String data = work.substring(10,work.length);
            if(data=="true"){
              productfavorited_order.add(true);
            }
            if(data=="false"){
              productfavorited_order.add(false);
            }
          }
        }
      }
    }

    //get data only if array list are empty -->

    getDatafromOrders();
    //after we get data from firebase we should find if any data inside is favorited by user or not ->

    //we should scrap all data from favorites ->
    CollectionReference collectiontogetFavorites = FirebaseFirestore.instance.collection('users').doc(uid()).collection('favorites');

    Future<void> getDatafromFavorites() async {
      // Get docs from collection reference
      QuerySnapshot querySnapshot = await collectiontogetFavorites.get();

      // Get data from docs and it will be json string
      final allData = querySnapshot.docs.map((doc) => doc.data()).toString();
      //show json string ->
      String workingstring = allData.substring(1,allData.length-1).replaceAll(":", "").replaceAll("{", "").replaceAll("}", "");

      for (String a in workingstring.split(", ")) {
        //show data -->
        if(a!=""){
          //if we have any value -->
          String work =a.substring(7,a.length);
          if(work.substring(0,1)=="n"){
            //if value is name ->
            String data = work.substring(5,work.length);
            productname_favorites.add(data);
          }
          if(work.substring(0,1)=="d"){
            //if value is description ->
            String data = work.substring(12,work.length);
            productdescription_favorites.add(data);
          }
          if(work.substring(0,1)=="p"){
            //if value is price ->
            String data = work.substring(6,work.length);
            productprice_favorites.add(data);
          }
        }
      }
      // so now we have data from favorites -->  productname_favorites , productdescription_favorites , productprice_favorites
      // now let's change data from topweek ->
      for(int i=0;i<productname_order.length;i++){
        for(int j=0; j<productname_favorites.length;j++){
          if(productname_order.elementAt(i)==productname_favorites.elementAt(j)){
            //we should change data to favorite ->
            productfavorited_order.insert(i, true);
          }
        }
      }

      //here we should start SystemIn after changed values inside top week and assortment ->
      // Here you can write your code
      //tell to flutter that app is changed
      Future.delayed(const Duration(seconds: 0), () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>
          Orderer(
              productname_order,productdescription_order,productprice_order,productfavorited_order
          )),(route)=>false));
    }

    getDatafromFavorites();


    return Container(width: 0,height: 0);
  }

}


class Orderer extends StatefulWidget{
  //transport our order data
  final List<String> productname_order;
  final List<String> productdescription_order;
  final List<String> productprice_order;
  final List<bool> productfavorited_order;

  Orderer(
      this.productname_order,this.productdescription_order,this.productprice_order,this.productfavorited_order
      );

  OrdererState createState()=> OrdererState(
    productname_order,productdescription_order,productprice_order,productfavorited_order
  );
}

class OrdererState extends State<Orderer>{
  //transport our order data
  final List<String> productname_order;
  final List<String> productdescription_order;
  final List<String> productprice_order;
  final List<bool> productfavorited_order;

  OrdererState(
      this.productname_order,this.productdescription_order,this.productprice_order,this.productfavorited_order
      );
  //here we create our coffee shop app
  //implement methods if needed
  //methods initialize here :

  final FirebaseAuth auth = FirebaseAuth.instance;

  String text (){
    final User? user = auth.currentUser;
    final uid = user!.displayName;
    String string = uid!;
    return 'Your orders , $string ';
  }

  String uid(){
    final User? user = auth.currentUser;
    final userid =user!.uid;
    String u_id = userid;
    return 'Your UID : $u_id';
  }
  //text return to us string with welcome to user
  //here is everything building

  Widget build(BuildContext context){

    //width and height of device
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        //here we should firstly create text
        children: [
          Padding(padding: EdgeInsets.only(left: width/20,top: height/20),
              child:SizedBox(
                height: 48,
                child: Text(text(),
                    textAlign: TextAlign.start,
                    style: GoogleFonts.comicNeue(textStyle: const TextStyle(fontSize: 24,
                        fontWeight: FontWeight.bold,color: Colors.black))
                ),
              )
          ),
          Padding(padding: EdgeInsets.only(left: width/20,right: width/20,top: 20),
              child: Container(
                height: height/1.6+100,
                child: Order(productname_order, productdescription_order, productprice_order, productfavorited_order),
              )
          ),
          Padding(padding: EdgeInsets.only(left: width/20,top: 20,right: width/20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(padding: EdgeInsets.only(),
                      child: InkWell(
                        onTap: (){
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>
                             getData()
                          ),(route)=>false);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(MyFlutterApp.home, size: 24),
                            Padding(padding: EdgeInsets.only(top: 5),
                                child: Text("Home",style: GoogleFonts.comicNeue(textStyle: const TextStyle(
                                    fontSize: 18,color: Colors.grey , fontWeight: FontWeight.bold))
                                )
                            )
                          ],
                        ),
                      )
                  ),
                  Padding(padding: EdgeInsets.only(left: width/15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(MyFlutterApp.clickedcoffeecup, size: 24),
                          Padding(padding: EdgeInsets.only(top: 5),
                              child: Text("Orders",style: GoogleFonts.comicNeue(textStyle: const TextStyle(
                                  fontSize: 18,color: Colors.black , fontWeight: FontWeight.bold))
                              )
                          )
                        ],
                      )
                  ),
                  Padding(padding: EdgeInsets.only(left: width/15),
                      child: InkWell(
                        onTap: (){
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> loaddataFavorites()),(route)=>false);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(MyFlutterApp.heart, size: 24),
                            Padding(padding: EdgeInsets.only(top: 5),
                                child: Text("Favorites",style: GoogleFonts.comicNeue(textStyle: const TextStyle(
                                    fontSize: 18,color: Colors.grey , fontWeight: FontWeight.bold))
                                )
                            )
                          ],
                        ),
                      )
                  ),
                  Padding(padding: EdgeInsets.only(left: width/15),
                      child: InkWell(
                        onTap: (){
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> Profile()),(route)=>false);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(MyFlutterApp.user, size: 24),
                            Padding(padding: EdgeInsets.only(top: 5),
                                child: Text("Profile",style: GoogleFonts.comicNeue(textStyle: const TextStyle(
                                    fontSize: 18,color: Colors.grey , fontWeight: FontWeight.bold))
                                )
                            )
                          ],
                        ),
                      )
                  ),
                ],
              )
          ),
        ],
      ),
    );
  }
}
class Order extends StatefulWidget{
  final List<String> productname;
  final List<String> productdescription;
  final List<String> productprice;
  final List<bool> productfavorited;
  const Order(this.productname,this.productdescription,this.productprice,this.productfavorited);
  OrderState createState()=>OrderState(productname, productdescription, productprice, productfavorited);
}
class OrderState extends State<Order>{
  final List<String> productname;
  final List<String> productdescription;
  final List<String> productprice;
  final List<bool> productfavorited;
  OrderState(this.productname,this.productdescription,this.productprice,this.productfavorited);
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    if(productname.isNotEmpty){
      return ListView.builder(padding: EdgeInsets.all(0),scrollDirection: Axis.vertical,shrinkWrap: false,
          itemCount: productname.length,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (BuildContext context, int idx){
            if(idx==-1){
              return Container(width: 0,height: 0);
            }
            else{
              return
                _coffeeListCard("assets/images/coffee.png", productname[idx], "CoffeeShop"
                    , productdescription[idx], productprice[idx], productfavorited[idx], width, height);
            }
          });
    }
    else{
      return Container(width: 0,height: 0);
    }

  }
  _coffeeListCard(String imgPath, String coffeeName, String shopName, String description,
      String price, bool isFavorite , double width , double height) {
    //here we should check the length of array to non misunderstand programm -->

    return Padding(
        padding: EdgeInsets.only(left: width/20, right: width/20, top: 20),
        child: Container(
            height: 0.55*height,
            width: 0.8*width,
            child: Column(
              children: <Widget>[
                Stack(
                    children: [
                      Container(
                          height: 0.5*height
                      ),
                      Positioned(
                          top: 0.1*height,
                          child: Container(
                              padding: EdgeInsets.only(left: 20, right: 20),
                              height: 0.4*height,
                              width: 0.8*width,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(25)),
                                  color: (isFavorite)?Colors.pink[100]:Color(0xFFDAB68C)
                              ),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(
                                      height: 0.075*height,
                                    ),
                                    SizedBox(
                                        height: 20,
                                        child: Text(
                                          shopName + '\'s',
                                          style: GoogleFonts.comicNeue(textStyle: const TextStyle(
                                              fontSize: 20,color: Colors.white , fontWeight: FontWeight.bold)),
                                        )
                                    ),
                                    SizedBox(height: 10),
                                    SizedBox(height: 32,child: Text(
                                        coffeeName,
                                        style: GoogleFonts.comicNeue(textStyle: const TextStyle(
                                            fontSize: 28,color: Colors.white , fontWeight: FontWeight.bold))
                                    )
                                    ),
                                    SizedBox(height: 5),
                                    SizedBox(
                                      height: height*0.16,
                                      child: Text(
                                          description,
                                          style: GoogleFonts.comicNeue(textStyle: const TextStyle(
                                              fontSize: 14,color: Colors.white , fontWeight: FontWeight.bold))
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Padding(padding: EdgeInsets.only(bottom: 5),child:
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                            price,
                                            style: GoogleFonts.comicNeue(textStyle: const TextStyle(
                                                fontSize: 25,color: Color(0xFF3A4742) , fontWeight: FontWeight.bold))
                                        ),
                                        Heart(isFavorite,coffeeName,description,price)
                                      ],
                                    ))
                                  ]
                              )
                          )
                      ),
                      Positioned(
                          left: 0.3*width,
                          //bottom: 25,
                          child: Container(
                              height: 0.15*height,
                              width: 0.2*width,
                              //color: Colors.deepOrange,
                              decoration: BoxDecoration(image: DecorationImage(image: AssetImage(imgPath), fit: BoxFit.fitHeight))
                          )
                      )
                    ]
                )
              ],
            )
        )
    );
  }
}