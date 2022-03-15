import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:multi_vendor_shop_app/models/product_model.dart';
import 'package:multi_vendor_shop_app/screens/product_details_screen.dart';


class HomeProductList extends StatelessWidget {
  final String? category;
  const HomeProductList({this.category,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade200,
      child: FirestoreQueryBuilder<Product>(
        query: productQuery(
          category: category
        ),
        builder: (context, snapshot, _) {
          // ...
          return GridView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 1/1.4
            ),
            itemCount: snapshot.docs.length,
            itemBuilder: (context, index) {
              // if we reached the end of the currently obtained items, we try to
              // obtain more items
              if (snapshot.hasMore && index + 1 == snapshot.docs.length) {
                // Tell FirestoreQueryBuilder to try to obtain more items.
                // It is safe to call this function from within the build method.
                snapshot.fetchMore();
              }

              var productIndex =snapshot.docs[index] ;
              Product product = productIndex.data();
              String productID = productIndex.id;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: (){
                    Navigator.push (
                      context,
                      PageRouteBuilder(
                          transitionDuration: Duration(milliseconds: 500),
                          //I will give 2 secons now
                          //now lets reduce speed
                          //ok it works fine
                          pageBuilder: (context,__,___){
                            return ProductDetailsScreen(productId: productID,
                            product: product,
                            );
                          }),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    height: 80,
                    width: 80,
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Container(
                              height: 60,
                              width: 80,
                              child: Hero(
                                  //wrap this image widget with hero widget
                                //it needs a tag
                                tag: product.imageUrls![0],
                                  //will give first image url as tag
                                  child: CachedNetworkImage(imageUrl: product.imageUrls![0],fit: BoxFit.cover,))),
                        ),
                        SizedBox(height: 10,),
                        Text(product.productName!,textAlign: TextAlign.center,style: TextStyle(fontSize: 10),maxLines: 2,),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
