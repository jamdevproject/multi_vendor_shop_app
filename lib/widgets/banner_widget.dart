import 'package:cached_network_image/cached_network_image.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:getwidget/components/shimmer/gf_shimmer.dart';

import '../firebase_service.dart';


class BannerWidget extends StatefulWidget {
  const BannerWidget({Key? key}) : super(key: key);

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {

  final FirebaseService _service = FirebaseService();
  double scrollPosition = 0;
  final List _bannerImage = [];
  //while starting this banner, banner list is empty. so dots count is null

  @override
  void initState() {
    getBanners();
    super.initState();
  }

  getBanners(){
    return _service.homeBanner
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        //here we get all the documents for banners
        //add those docs in a list
        setState(() {
          _bannerImage.add(doc['image']);
        });
      });
    });
  }



  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Container(
              color: Colors.grey.shade200,
              height: 140,
              width: MediaQuery.of(context).size.width,
              child: PageView.builder(
                itemCount: _bannerImage.length,
                itemBuilder: (BuildContext context, int index){
                  return CachedNetworkImage(
                    imageUrl: _bannerImage[index],
                    fit: BoxFit.fill,

                    placeholder: (context, url) =>GFShimmer(
                      showShimmerEffect: true,
                      mainColor: Colors.grey.shade500,
                      secondaryColor: Colors.grey.shade300,
                      child: Container(
                        color: Colors.grey.shade300,
                        height: 140,
                        width: MediaQuery.of(context).size.width,
                      ),
                    ) ,
                  );
                },
                onPageChanged: (val){
                  setState(() {
                    scrollPosition = val.toDouble();
                  });
                },
              ),
            ),
          ),
        ),
        //so dont want to show dots if list is empty
        _bannerImage.isEmpty ? Container():
        Positioned(
          bottom: 10.0,
          child: DotsIndicatorWidget(scrollPosition: scrollPosition,
            itemList: _bannerImage,
          ),
        )
      ],
    );
  }
}

class DotsIndicatorWidget extends StatelessWidget {
  const DotsIndicatorWidget({
    Key? key,
    required this.scrollPosition,
    required this.itemList,
  }) : super(key: key);

  final double scrollPosition;
  final List itemList;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: DotsIndicator(
            position: scrollPosition,
            dotsCount: itemList.length,
            decorator: DotsDecorator(
                activeColor: Colors.blue.shade900,
                spacing: const EdgeInsets.all(2),
                size: const Size.square(6),
                activeSize: const Size(12,6),
                activeShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)
                )
            ),
          ),
        ),
      ],
    );
  }
}


//Hi all, welcome to next video,
//this video , I will bring brand highlights data from firestore
//for time I will copy some image link from google
//ony video id from youtube