import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_shop/Favorites.dart';
import 'package:coffee_shop/Orders.dart';
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
import 'package:fluttertoast/fluttertoast.dart';

import 'Details.dart';   // new

//we create class to download all data which we need , after data will setted we start our needed activity ==>
class getData extends StatelessWidget{
  final FirebaseAuth auth = FirebaseAuth.instance;

  String uid(){
    final User? user = auth.currentUser;
    final userid =user!.uid;
    String u_id = userid;
    return 'Your UID : $u_id';
  }

  @override
  Widget build(BuildContext context) {
    //top week arrays
    List<String> productname_topweek = <String>[];
    List<String> productdescription_topweek = <String>[];
    List<String> productprice_topweek = <String>[];
    List<bool> productfavorited_topweek = <bool>[];

    //assortment

    List<String> productname_assortment = <String>[];
    List<String> productdescription_assortment = <String>[];
    List<String> productprice_assortment = <String>[];
    List<bool> productfavorited_assortment = <bool>[];


    //favorites ->
    List<String> productname_favorites = <String>[];
    List<String> productdescription_favorites = <String>[];
    List<String> productprice_favorites = <String>[];

    //let's here work with our database ==>
    // users -> user ->
    //let's get data from mainpage ->
    CollectionReference collectiontogetMainPageAssortments = FirebaseFirestore.instance.collection('data').doc('assortments').collection('data');
    CollectionReference collectiontogetMainPageTopWeek = FirebaseFirestore.instance.collection('data').doc('topweek').collection('data');

    Future<void> getDatafromMainPageTopWeek() async {
      // Get docs from collection reference
      QuerySnapshot querySnapshot = await collectiontogetMainPageTopWeek.get();

      // Get data from docs and it will be json string
      final allData = querySnapshot.docs.map((doc) => doc.data()).toString();
      //show json string ->
      String workingstring = allData.substring(1,allData.length-1).replaceAll(":", "").replaceAll("{", "").replaceAll("}", "");

      for (String a in workingstring.split(", ")) {
        //show data -->
        String work =a.substring(7,a.length);
        if(work.substring(0,1)=="n"){
          //if value is name ->
          String data = work.substring(5,work.length);
          productname_topweek.add(data);
        }
        if(work.substring(0,1)=="d"){
          //if value is description ->
          String data = work.substring(12,work.length);
          productdescription_topweek.add(data);
        }
        if(work.substring(0,1)=="p"){
          //if value is price ->
          String data = work.substring(6,work.length);
          productprice_topweek.add(data);
        }
        if(work.substring(0,1)=="f"){
          //if value is favorited ->
          String data = work.substring(10,work.length);
          if(data=="true"){
            productfavorited_topweek.add(true);
          }
          if(data=="false"){
            productfavorited_topweek.add(false);
          }
        }
      }
    }
    Future<void> getDatafromMainPageAssortments() async {
      // Get docs from collection reference
      QuerySnapshot querySnapshot = await collectiontogetMainPageAssortments.get();

      // Get data from docs and it will be json string
      final allData = querySnapshot.docs.map((doc) => doc.data()).toString();
      //show json string ->
      String workingstring = allData.substring(1,allData.length-1).replaceAll(":", "").replaceAll("{", "").replaceAll("}", "");

      for (String a in workingstring.split(", ")) {
        //show data -->
        String work =a.substring(7,a.length);
        if(work.substring(0,1)=="n"){
          //if value is name ->
          String data = work.substring(5,work.length);
          productname_assortment.add(data);
        }
        if(work.substring(0,1)=="d"){
          //if value is description ->
          String data = work.substring(12,work.length);
          productdescription_assortment.add(data);
        }
        if(work.substring(0,1)=="p"){
          //if value is price ->
          String data = work.substring(6,work.length);
          productprice_assortment.add(data);
        }
        if(work.substring(0,1)=="f"){
          //if value is favorited ->
          String data = work.substring(10,work.length);
          if(data=="true"){
            productfavorited_assortment.add(true);
          }
          if(data=="false"){
            productfavorited_assortment.add(false);
          }
        }
      }
    }

    getDatafromMainPageTopWeek();
    getDatafromMainPageAssortments();

    //we should change values from top week and assortments favorite value by find is this value inside favorites or not ->

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
      for(int i=0;i<productname_topweek.length;i++){
        for(int j=0; j<productname_favorites.length;j++){
          if(productname_topweek.elementAt(i)==productname_favorites.elementAt(j)){
            //we should change data to favorite ->
            productfavorited_topweek.insert(i, true);
          }
        }
      }
      //change assortment -->
      for(int i=0;i<productname_assortment.length;i++){
        for(int j=0; j<productname_favorites.length;j++){
          if(productname_assortment.elementAt(i)==productname_favorites.elementAt(j)){
            //we should change data to favorite ->
            productfavorited_assortment.insert(i, true);
          }
        }
      }

      //here we should start SystemIn after changed values inside top week and assortment ->

      Future.delayed(const Duration(seconds: 0), () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>
          SystemIN(
              productname_topweek,productdescription_topweek,productprice_topweek,productfavorited_topweek,
              productname_assortment,productdescription_assortment,productprice_assortment,productfavorited_assortment
          )),(route)=>false));
    }

    getDatafromFavorites();

    return  Container(height: 0,width: 0,);
  }
}

class SystemIN extends StatefulWidget{
  //get data from getdata class
  final List<String> productname_top;
  final List<String> productdescription_top;
  final List<String> productprice_top;
  final List<bool> productfavorited_top;

  final List<String> productname_assrt;
  final List<String> productdescription_assrt;
  final List<String> productprice_assrt;
  final List<bool> productfavorited_assrt;

  SystemIN(this.productname_top,this.productdescription_top,this.productprice_top,this.productfavorited_top,
      this.productname_assrt,this.productdescription_assrt,this.productprice_assrt,this.productfavorited_assrt
      );
  //create var to host only one time read ==>
  SystemINState createState()=> SystemINState(
    productname_top,productdescription_top,productprice_top,productfavorited_top,
    productname_assrt,productdescription_assrt,productprice_assrt,productfavorited_assrt
  );
}

class SystemINState extends State<SystemIN>{
  final List<String> productname_top;
  final List<String> productdescription_top;
  final List<String> productprice_top;
  final List<bool> productfavorited_top;

  final List<String> productname_assrt;
  final List<String> productdescription_assrt;
  final List<String> productprice_assrt;
  final List<bool> productfavorited_assrt;

  SystemINState(this.productname_top,this.productdescription_top,this.productprice_top,this.productfavorited_top,
      this.productname_assrt,this.productdescription_assrt,this.productprice_assrt,this.productfavorited_assrt);
  //here we create our coffee shop app
  //implement methods if needed
  //methods initialize here :

  final FirebaseAuth auth = FirebaseAuth.instance;

  //text return to us string with welcome to user
  //here is everything building
  String text (){
    final User? user = auth.currentUser;
    final uid = user!.displayName;
    String string = uid!;
    return 'Welcome , $string ';
  }

  Widget build(BuildContext context){
    //width and height of device
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    //create lists here ==>

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
          Padding(padding: EdgeInsets.only(left: width/20,top: 10),
              child: SizedBox(
                height: 44,
                child: Text("Let's select the best taste for your next coffee break!",
                    style: GoogleFonts.comicNeue(textStyle: const TextStyle(fontSize: 20,color: Colors.grey))
                ),
              )
          ),
          Padding(padding: EdgeInsets.only(left: width/20,top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Taste of the week",
                    style: GoogleFonts.comicNeue(textStyle: const TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.bold))
                ),
              ],
            )
          ),
          Padding(padding: EdgeInsets.only(left: width/20,right: width/20,top: 20),
              child: Container(
                height: height/1.6+6,
                child: ListView(
                  addAutomaticKeepAlives: false,
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  padding: EdgeInsets.all(0),
                  children: [
                    //here we create  Container which will consist listview which will be scrollable horizontal
                    Container(
                      height: 0.6*height,
                      child: TopWeek(productname_top, productdescription_top, productprice_top, productfavorited_top)
                    ),
                    Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Assortment",
                                style: GoogleFonts.comicNeue(textStyle: const TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.bold))
                            )
                          ],
                        ),
                    Padding(padding: EdgeInsets.only(top: 10),
                      child: Container(
                        height: 0.6*height,
                        child: Assortment(productname_assrt,productdescription_assrt,productprice_assrt,productfavorited_assrt)
                      ),),
                  ],
                ),
              )
          ),
          Padding(padding: EdgeInsets.only(left: width/20,top: 20,right: width/20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(padding: EdgeInsets.only(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(MyFlutterApp.clickedhome, size: 24),
                      Padding(padding: EdgeInsets.only(top: 5),
                          child: Text("Home",style: GoogleFonts.comicNeue(textStyle: const TextStyle(
                          fontSize: 18,color: Colors.black , fontWeight: FontWeight.bold))
                      )
                      )
                    ],
                    )
                    ),
                  Padding(padding: EdgeInsets.only(left: width/15),
                    child: InkWell(
                      onTap: (){
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>
                            getinfo()),(route)=>false);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(MyFlutterApp.coffeecup, size: 24),
                          Padding(padding: EdgeInsets.only(top: 5),
                              child: Text("Orders",style: GoogleFonts.comicNeue(textStyle: const TextStyle(
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
                      child:  Column(
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
class Buy extends StatelessWidget{
  final String coffeename;
  final String coffeedescription;
  final String coffeeprice;
  final bool coffeefavorited;

  Buy(this.coffeename,this.coffeedescription,this.coffeeprice,this.coffeefavorited);

  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Padding(padding: EdgeInsets.only(top: 15),
      child: InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => DetailsPage(coffeename,coffeedescription,coffeeprice,coffeefavorited)
            ));
          },
          child: Container(
              height: height/20,
              width: width/2,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.0),
                  color: Color(0xFF473D3A)
              ),
              child: Center(
                  child: Text(
                      'Order Now',
                      style: GoogleFonts.comicNeue(textStyle: const TextStyle(
                          fontSize: 16,color: Colors.white , fontWeight: FontWeight.bold))
                  )
              )
          )
      ));
  }
}
class Heart extends StatefulWidget{
  final bool favorite;
  final String coffeename;
  final String coffeedescription;
  final String coffeeprice;

  const Heart(this.favorite,this.coffeename,this.coffeedescription,this.coffeeprice);
  HeartState createState()=> HeartState(favorite,coffeename,coffeedescription,coffeeprice);
}
class HeartState extends State<Heart>{
   late bool fav;
   late String coffeename;
   late String coffeedescription;
   late String coffeeprice;

   HeartState(this.fav,this.coffeename,this.coffeedescription,this.coffeeprice);

   final FirebaseAuth auth = FirebaseAuth.instance;
  //get uid -->
  String uid(){
    final User? user = auth.currentUser;
    final userid =user!.uid;
    String u_id = userid;
    return 'Your UID : $u_id';
  }
    Widget build(BuildContext context){
      // initialize where we will write or delete datas
      CollectionReference collectiontogetFavorites = FirebaseFirestore.instance.collection('users').doc(uid()).collection('favorites');

      return InkWell(
        onTap: (){
          setState(() {
            if(fav==true){
              //delete data from collection favorites ->
              fav=false;
              collectiontogetFavorites.where('productname', isEqualTo: coffeename).get().then((value) => value.docs.forEach((element) {
                FirebaseFirestore.instance.collection('users').doc(uid()).collection('favorites').doc(element.id).delete();
              }));
            }
            else{
              // write data to collection favorites ->
              fav=true;
              collectiontogetFavorites.add({
                'productname': coffeename,
                'productdescription':coffeedescription,
                'productprice':coffeeprice,
                'productfavorited':fav
              });
            }
          });
        },
        child: Container(
          height: 40, width: 40,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0), color: Colors.white),
          child: Center(
              child: Icon(Icons.favorite,
                  color: (fav) ? Colors.red: Colors.grey, size: 20.0)
          )
      ),
    );
  }
}
class TopWeek extends StatefulWidget{
  final List<String> productname;
  final List<String> productdescription;
  final List<String> productprice;
  final List<bool> productfavorited;
  const TopWeek(this.productname,this.productdescription,this.productprice,this.productfavorited);
  TopWeekState createState()=>TopWeekState(productname, productdescription, productprice, productfavorited);
}
class TopWeekState extends State<TopWeek>{
  final List<String> productname;
  final List<String> productdescription;
  final List<String> productprice;
  final List<bool> productfavorited;
  TopWeekState(this.productname,this.productdescription,this.productprice,this.productfavorited);
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return ListView.builder(padding: EdgeInsets.all(0),scrollDirection: Axis.horizontal,shrinkWrap: false,
        itemCount: productname.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (BuildContext context, int idx){
      if(idx==-1){
        return Container(width: 0,height: 0);
      }
      else{
        return _coffeeListCard("assets/images/coffee.png", productname[idx], "CoffeeShop"
            , productdescription[idx], productprice[idx], productfavorited[idx], width, height);
      }
    });
  }
  _coffeeListCard(String imgPath, String coffeeName, String shopName, String description,
      String price, bool isFavorite , double width , double height) {
    return Padding(
        padding: EdgeInsets.only(left: width/20, right: width/20),
        child: Container(
            height: 0.55*height,
            width: width/2,
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
                              width: width/2,
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
                          left: 0.15*width,
                          //bottom: 25,
                          child: Container(
                              height: 0.15*height,
                              width: 0.2*width,
                              //color: Colors.deepOrange,
                              decoration: BoxDecoration(image: DecorationImage(image: AssetImage(imgPath), fit: BoxFit.fitHeight))
                          )
                      )
                    ]
                ),
                Buy(coffeeName,description,price,isFavorite)
              ],
            )
        )
    );
  }
}
class Assortment extends StatefulWidget{
  final List<String> productname;
  final List<String> productdescription;
  final List<String> productprice;
  final List<bool> productfavorited;
  const Assortment(this.productname,this.productdescription,this.productprice,this.productfavorited);
  AssortmentState createState()=>AssortmentState(productname, productdescription, productprice, productfavorited);
}
class AssortmentState extends State<Assortment>{
  final List<String> productname;
  final List<String> productdescription;
  final List<String> productprice;
  final List<bool> productfavorited;
  AssortmentState(this.productname,this.productdescription,this.productprice,this.productfavorited);
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return ListView.builder(padding: EdgeInsets.all(0),scrollDirection: Axis.horizontal,shrinkWrap: false,
        itemCount: productname.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (BuildContext context, int idx){
        if(idx==-1){
          return Container(width: 0,height: 0);
        }
        else{
          return _coffeeListCard("assets/images/coffee.png", productname[idx], "CoffeeShop"
                , productdescription[idx], productprice[idx], productfavorited[idx], width, height);
        }
        });
  }
  _coffeeListCard(String imgPath, String coffeeName, String shopName, String description,
      String price, bool isFavorite , double width , double height) {
    return Padding(
        padding: EdgeInsets.only(left: width/20, right: width/20),
        child: Container(
            height: 0.55*height,
            width: width/2,
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
                              width: width/2,
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
                          left: 0.15*width,
                          //bottom: 25,
                          child: Container(
                              height: 0.15*height,
                              width: 0.2*width,
                              //color: Colors.deepOrange,
                              decoration: BoxDecoration(image: DecorationImage(image: AssetImage(imgPath), fit: BoxFit.fitHeight))
                          )
                      )
                    ]
                ),
                Buy(coffeeName,description,price,isFavorite)
              ],
            )
        )
    );
  }
}