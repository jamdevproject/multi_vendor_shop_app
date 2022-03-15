import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get_storage/get_storage.dart';
import 'package:multi_vendor_shop_app/models/product_model.dart';
import 'package:multi_vendor_shop_app/widgets/product_bottom_sheet.dart';

import '../firebase_service.dart';
import 'confirmation_screen.dart';
import 'google_map_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product? product;
  final String? productId;

  const ProductDetailsScreen({this.product, this.productId, Key? key})
      : super(key: key);

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final FirebaseService _service = FirebaseService();
  final store = GetStorage();
  ScrollController? _scrollController;
  int? pageNumber = 0;
  bool _isScrollDown = false;
  bool _showAppBar = true;
  String ? _selectedSize;
  String? _address;

  @override
  void initState() {
    getSize();
    getDeliveryAddress();
    _scrollController = ScrollController();
    _scrollController!.addListener(() {

      if(_scrollController!.position.userScrollDirection==ScrollDirection.reverse){
        if(!_isScrollDown){
          setState(() {
            _isScrollDown = true;
            _showAppBar = false;
          });
        }
      }
      if(_scrollController!.position.userScrollDirection==ScrollDirection.forward){
        if(_isScrollDown){
          setState(() {
            _isScrollDown = false;
            _showAppBar = true;
          });
        }
      }

    });
    super.initState();
  }

  getSize(){
    if(widget.product!.size!=null){
      setState(() {
        _selectedSize = widget.product!.size![0];
      });
    }
  }

  Widget _sizedBox({double? height, double? width}){
    return SizedBox(
      height: height ?? 0,
      width: width ??0,
    );
  }

  Widget _divider(){
    return Divider(
      color: Colors.grey.shade400,
      thickness: 1,
    );
  }

  Widget _headText(String? text){
    return Text(
      text!,
      style: const TextStyle(fontSize: 14, color: Colors.grey),
    );
  }

  getDeliveryAddress(){
    String? address = store.read('address');
    if(address!=null){
      setState(() {
        _address = address;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _showAppBar ? AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.grey),
        actions: [
          const CircleAvatar(
            radius: 18,
            backgroundColor: Colors.black26,
            child: Icon(
              IconlyLight.buy,
              color: Colors.white,
            ),
          ),
          _sizedBox(width: 8),
          const CircleAvatar(
            radius: 18,
            backgroundColor: Colors.black26,
            child: Icon(
              Icons.more_horiz,
              color: Colors.white,
            ),
          ),
          _sizedBox(width: 10),
        ],
      ) : null,
      //it will show app only if you scroll down
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 300,
                child: Stack(
                  children: [
                    Hero(
                      //give same tage here
                      //actually there is an animation and it happens very fastly
                      //lets reduce the speed
                      tag: widget.product!.imageUrls![0],
                      child: PageView(
                        onPageChanged: (value) {
                          setState(() {
                            pageNumber = value;
                          });
                        },
                        children: widget.product!.imageUrls!.map((e) {
                          return CachedNetworkImage(
                            imageUrl: e,
                          );
                        }).toList(),
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      right: MediaQuery.of(context).size.width / 2,
                      child: CircleAvatar(
                        radius: 14,
                        backgroundColor: Colors.black45,
                        child: Text(
                          '${pageNumber! + 1}/${widget.product!.imageUrls!.length}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Rs. ${widget.product!.salesPrice != null ? _service.formatedNumber(widget.product!.salesPrice) : _service.formatedNumber(widget.product!.regularPrice!)}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                              fontSize: 16),
                        ),
                        Row(
                          children: [
                            IconButton(
                              splashRadius: 20,
                              icon: const Icon(IconlyLight.heart,size: 18,color: Colors.grey,),
                              onPressed: (){},
                            ),
                            IconButton(
                              splashRadius: 20,
                              icon: const Icon(Icons.share,size: 18,color: Colors.grey),
                              onPressed: (){},
                            ),
                          ],
                        )
                      ],
                    ),
                    if (widget.product!.salesPrice != null)
                      Row(
                        children: [
                          Text(
                            'Rs. ${_service.formatedNumber(widget.product!.regularPrice!)}',
                            style: const TextStyle(
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey),
                          ),
                          _sizedBox(width: 10),
                          Text(
                              '${(((widget.product!.regularPrice! - widget.product!.salesPrice!) / widget.product!.regularPrice!) * 100).toStringAsFixed(0)}%')
                        ],
                      ),
                    _sizedBox(height:10),
                    Text(widget.product!.productName!),
                    _sizedBox(height:10),
                    Row(
                      children: [
                        Icon(
                          IconlyBold.star,
                          color: Theme.of(context).primaryColor,
                          size: 14,
                        ),
                        Icon(
                          IconlyBold.star,
                          color: Theme.of(context).primaryColor,
                          size: 14,
                        ),
                        Icon(
                          IconlyBold.star,
                          color: Theme.of(context).primaryColor,
                          size: 14,
                        ),
                        Icon(
                          IconlyBold.star,
                          color: Theme.of(context).primaryColor,
                          size: 14,
                        ),
                        Icon(
                          IconlyBold.star,
                          color: Theme.of(context).primaryColor,
                          size: 14,
                        ),
                        _sizedBox(width:4),
                        const Text(
                          '(5)',
                          style: TextStyle(fontSize: 12),
                        )
                      ],
                    ),
                    _sizedBox(height: 10),
                    Text(widget.product!.description!),
                    if(widget.product!.size!=null && widget.product!.size!.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _sizedBox(height: 10),
                        _headText('Variations'),
                          SizedBox(
                            height: 50,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: widget.product!.size!.map((e) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: OutlinedButton(
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(
                                        _selectedSize==e ? Theme.of(context).primaryColor : Colors.white
                                      ),
                                    ),
                                    child: Text(e,style: TextStyle(color:  _selectedSize ==e ?  Colors.white:Colors.black ),),
                                    onPressed: (){
                                      setState(() {
                                        _selectedSize = e;
                                      });
                                    },
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                      ],
                    ),
                    _divider(),
                    InkWell(
                      onTap: () {
                        showModalBottomSheet(context: context, builder: (context){
                          return ProductBottomSheet(
                            product: widget.product,
                          );
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 6,bottom: 6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _headText('Specifications'),
                            const Icon(
                              IconlyLight.arrowRight2,
                              size: 14,
                            )
                          ],
                        ),
                      ),
                    ),
                    _divider(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         Expanded(
                          flex: 2,
                          child: _headText('Delivery'),
                        ),
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push (
                                    context,
                                    MaterialPageRoute (
                                      builder: (BuildContext context) => const MapScreen(),
                                    ),
                                  );
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        _address ?? 'Delivery address not set..',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.red),
                                      ),
                                    ),
                                    Icon(
                                      IconlyLight.location,
                                      size: 16,
                                      color: Colors.red,
                                    )
                                  ],
                                ),
                              ),
                                    _sizedBox(height:6),
                              const Text(
                                'Home Delivery 3-5 day(s)',
                                style: TextStyle(fontSize: 14),
                              ),
                              Text(
                                'Delivery charge : ${widget.product!.chargeShipping! ? 'Rs.${widget.product!.shippingCharge!}' : 'Free'}',
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 14),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    _divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _headText('Rating & Reviews (10)'),
                        const Text(
                          'View all..',
                          style: TextStyle(color: Colors.red),
                        )
                      ],
                    ),
                    _sizedBox(height:10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Jam dev - 11 Feb 2022',
                          style:
                              TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        Row(
                          children: [
                            Icon(
                              IconlyBold.star,
                              size: 12,
                              color: Theme.of(context).primaryColor,
                            ),
                            Icon(
                              IconlyBold.star,
                              size: 12,
                              color: Theme.of(context).primaryColor,
                            ),
                            Icon(
                              IconlyBold.star,
                              size: 12,
                              color: Theme.of(context).primaryColor,
                            ),
                            Icon(
                              IconlyBold.star,
                              size: 12,
                              color: Theme.of(context).primaryColor,
                            ),
                            Icon(
                              IconlyLight.star,
                              size: 12,
                              color: Theme.of(context).primaryColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Text('Good product, good quality\nOn time delivery'),
                    _sizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Jam dev - 11 Feb 2022',
                          style:
                              TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        Row(
                          children: [
                            Icon(
                              IconlyBold.star,
                              size: 12,
                              color: Theme.of(context).primaryColor,
                            ),
                            Icon(
                              IconlyBold.star,
                              size: 12,
                              color: Theme.of(context).primaryColor,
                            ),
                            Icon(
                              IconlyBold.star,
                              size: 12,
                              color: Theme.of(context).primaryColor,
                            ),
                            Icon(
                              IconlyBold.star,
                              size: 12,
                              color: Theme.of(context).primaryColor,
                            ),
                            Icon(
                              IconlyLight.star,
                              size: 12,
                              color: Theme.of(context).primaryColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Text('Good product, good quality. On time delivery'),
                    _sizedBox(height:20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Jam dev - 11 Feb 2022',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        Row(
                          children: [
                            Icon(
                              IconlyBold.star,
                              size: 12,
                              color: Theme.of(context).primaryColor,
                            ),
                            Icon(
                              IconlyBold.star,
                              size: 12,
                              color: Theme.of(context).primaryColor,
                            ),
                            Icon(
                              IconlyBold.star,
                              size: 12,
                              color: Theme.of(context).primaryColor,
                            ),
                            Icon(
                              IconlyBold.star,
                              size: 12,
                              color: Theme.of(context).primaryColor,
                            ),
                            Icon(
                              IconlyLight.star,
                              size: 12,
                              color: Theme.of(context).primaryColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Text(
                        'Good product, good quality. On time delivery. This is a text review from jam dev. Item received with in greed date'),
                    _sizedBox(height:20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Jam dev - 11 Feb 2022',
                          style:
                              TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        Row(
                          children: [
                            Icon(
                              IconlyBold.star,
                              size: 12,
                              color: Theme.of(context).primaryColor,
                            ),
                            Icon(
                              IconlyBold.star,
                              size: 12,
                              color: Theme.of(context).primaryColor,
                            ),
                            Icon(
                              IconlyBold.star,
                              size: 12,
                              color: Theme.of(context).primaryColor,
                            ),
                            Icon(
                              IconlyBold.star,
                              size: 12,
                              color: Theme.of(context).primaryColor,
                            ),
                            Icon(
                              IconlyLight.star,
                              size: 12,
                              color: Theme.of(context).primaryColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Text('Good product, good quality. On time delivery'),
                    _sizedBox(height:30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Jam dev - 11 Feb 2022',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        Row(
                          children: [
                            Icon(
                              IconlyBold.star,
                              size: 12,
                              color: Theme.of(context).primaryColor,
                            ),
                            Icon(
                              IconlyBold.star,
                              size: 12,
                              color: Theme.of(context).primaryColor,
                            ),
                            Icon(
                              IconlyBold.star,
                              size: 12,
                              color: Theme.of(context).primaryColor,
                            ),
                            Icon(
                              IconlyBold.star,
                              size: 12,
                              color: Theme.of(context).primaryColor,
                            ),
                            Icon(
                              IconlyLight.star,
                              size: 12,
                              color: Theme.of(context).primaryColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Text('Good product, good quality. On time delivery'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey.shade400)),
        ),
        height: 60,
        child: FittedBox(
          child: Row(
            children: [
              const SizedBox(width: 20,),
              Column(
                children: [
                  const SizedBox(height: 10,),
                  Icon(
                    Icons.store_mall_directory_outlined,
                    color: Theme.of(context).primaryColor,
                  ),
                  Text(
                    'Store',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 12
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 60,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: VerticalDivider(
                    color: Colors.black,
                  ),
                ),
              ),
              Column(
                children: [
                  _sizedBox(height:10),
                  Icon(
                    IconlyLight.chat,
                    color: Theme.of(context).primaryColor,
                  ),
                  Text(
                    'Chat',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 12
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: VerticalDivider(
                  color: Colors.grey,
                ),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.orange)
                ),
                child: const Text('Buy now'),
                onPressed: (){
                  _address==null ? Navigator.push (
                    context,
                    MaterialPageRoute (
                      builder: (BuildContext context) => const MapScreen(),
                    ),
                  ).whenComplete((){
                    setState(() {

                    });
                  }):Navigator.push (
                    context,
                    MaterialPageRoute (
                      builder: (BuildContext context) => const ConfirmationScreen(),
                    ),
                  );
                  //go to confirmation screen;
                },
              ),
              _sizedBox(width:10),
              ElevatedButton(
                child: const Text('Add to Cart'),
                onPressed: (){},
              ),
              _sizedBox(width:20),
            ],
          ),
        ),
      ),
    );
  }
}


//Hi. Welcome back to new video.
//due to sound disturbance here, I cant talk now in some videos.
//still I will try to come back with sounds again later.
//last video we worked on product details screen
//here I will make more changes now.
// first I will apply a hero animation with product image
