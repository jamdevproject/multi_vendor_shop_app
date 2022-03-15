import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:multi_vendor_shop_app/widgets/banner_widget.dart';
import 'package:multi_vendor_shop_app/widgets/brand_highlights.dart';
import 'package:multi_vendor_shop_app/widgets/category/category_widget.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade900,
      //I want to reduce this app bar height
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: AppBar(
          backgroundColor: Colors.blue.shade900,
          elevation: 0,
          centerTitle: true,
          title: const Text('Shop App',style: TextStyle(letterSpacing: 2),),
          actions: [
            IconButton(
              icon: const Icon(IconlyLight.buy),
              onPressed: (){},
            ),
          ],
        ),
      ),
      //list view is used to scroll the screen with group of widgets
      body: ListView(
        children:  const [
          SearchWidget(),
          SizedBox(height: 10,),
          BannerWidget(),
          BrandHighlights(),
          CategoryWidget()
          //Some Product list will show after this
        ],
      ),
    );
  }
}

class SearchWidget extends StatelessWidget {
  const SearchWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 55,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: const TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.fromLTRB(8, 5, 8, 0),
                  hintText: 'Search in Shop App',
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.search,size: 20,color: Colors.grey,)
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 20,
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: const [
                  Icon(IconlyLight.infoSquare,size: 12,color: Colors.white,),
                  Text(' 100% Genuine',style: TextStyle(color: Colors.white,fontSize: 12),),
                ],
              ),
              Row(
                children: const [
                  Icon(IconlyLight.infoSquare,size: 12,color: Colors.white,),
                  Text(' 4 - 7 Days Return',style: TextStyle(color: Colors.white,fontSize: 12),),
                ],
              ),
              Row(
                children: const [
                  Icon(IconlyLight.infoSquare,size: 12,color: Colors.white,),
                  Text(' Trusted Brands',style: TextStyle(color: Colors.white,fontSize: 12),),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}


//hi Welcome to my next video from the series Multi Vendor SHop App
//in this video I will show all the categories and sub categories in category screen,
//which we already saved in firestore using admin web


