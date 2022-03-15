import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:multi_vendor_shop_app/models/sub_category_model.dart';



class SubCategoryWidget extends StatelessWidget {
  final String? selectedSubCat;

  const SubCategoryWidget({this.selectedSubCat, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return FirestoreQueryBuilder<SubCategory>(
      query: subCategoryCollection(
        selectedSubCat: selectedSubCat
      ),
      builder: (context, snapshot, _) {
        if (snapshot.isFetching) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Text('error ${snapshot.error}');
        }

        return GridView.builder(
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: snapshot.docs.length==0 ? 1/.1 : 1/1.1
          ),
          itemCount: snapshot.docs.length,
          itemBuilder: (context, index) {

            final subCat = snapshot.docs[index].data();
            return InkWell(
              onTap: (){
                //move to products screen
              },
              child: Column(
                children: [
                  SizedBox(
                    height: 60,
                    width: 60,
                    child: FittedBox(
                        fit: BoxFit.contain,
                        child: CachedNetworkImage(
                          imageUrl: subCat.image!,
                          placeholder: (context,_){
                            return Container(
                              height: 60,
                              width: 60,
                              color: Colors.grey.shade300,
                            );
                          },
                        ),),
                  ),
                  Text(subCat.subCatName!,style: const TextStyle(fontSize: 12),
                  textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}


