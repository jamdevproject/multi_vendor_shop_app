import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/shimmer/gf_shimmer.dart';
import 'package:multi_vendor_shop_app/widgets/banner_widget.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../firebase_service.dart';

class BrandHighlights extends StatefulWidget {
  const BrandHighlights({Key? key}) : super(key: key);

  @override
  State<BrandHighlights> createState() => _BrandHighlightsState();
}

class _BrandHighlightsState extends State<BrandHighlights> {
  double _scrollPosition = 0;
  final FirebaseService _service = FirebaseService();
  final List _brandAds = [];

  @override
  void initState() {
    getBrandAd();
    super.initState();
  }

  getBrandAd() {
    return _service.brandAd.get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        //here we get all the documents for banners
        //add those docs in a list
        setState(() {
          _brandAds.add(doc);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //will show some ad video about a brand and other details of that brand

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(
            height: 18,
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Brand Highlights',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                    fontSize: 20),
              ),
            ),
          ),
          Container(
            height: 166,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: PageView.builder(
              itemCount: _brandAds.length,
              itemBuilder: (BuildContext context, int index) {
                return Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 4, 8),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Container(
                                height: 100,
                                color: Colors.deepOrange,
                                //I will inactive this youtube player temporarily
                                child: YoutubePlayer(
                                  controller: YoutubePlayerController(
                                    initialVideoId: _brandAds[index]['youtube'],
                                    flags: const YoutubePlayerFlags(
                                      autoPlay: false,
                                      mute: true,
                                      loop: true,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 0, 4, 8),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: Container(
                                      height: 50,
                                      color: Colors.red,
                                      child: CachedNetworkImage(
                                        imageUrl: _brandAds[index]['image1'],
                                        fit: BoxFit.fill,
                                        placeholder: (context, url) =>
                                            GFShimmer(
                                          child: Container(
                                            height: 50,
                                            color: Colors.grey.shade400,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 0, 4, 8),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: Container(
                                      height: 50,
                                      color: Colors.red,
                                      child: CachedNetworkImage(
                                        imageUrl: _brandAds[index]['image2'],
                                        fit: BoxFit.fill,
                                        placeholder: (context, url) =>
                                            GFShimmer(
                                          child: Container(
                                            height: 50,
                                            color: Colors.grey.shade400,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(4, 0, 8, 8),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Container(
                            height: 160,
                            color: Colors.blue,
                            child: CachedNetworkImage(
                              imageUrl: _brandAds[index]['image3'],
                              fit: BoxFit.fill,
                              placeholder: (context, url) => GFShimmer(
                                child: Container(
                                  height: 50,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                );
              },
              onPageChanged: (val) {
                setState(() {
                  _scrollPosition = val.toDouble();
                });
              },
            ),
          ),
          //here also
          _brandAds.isEmpty
              ? Container()
              : DotsIndicatorWidget(
                  scrollPosition: _scrollPosition,
                  itemList: _brandAds,
                )
        ],
      ),
    );
  }
}


//Hi, Welcome to next part of the series
//today lets work on admin web to save some categories
//because next in our customer app, we need to show categories.
//so to save categories in firestore easily, we will make flutter web and will save all the categories
//and sub categories with image

//this is temporary admin web. later will modify that with responsive and other login features
