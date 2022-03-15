import 'package:multi_vendor_shop_app/firebase_service.dart';

class SubCategory {
  SubCategory({this.mainCategory, this.subCatName, this.image});

  SubCategory.fromJson(Map<String, Object?> json)
      : this(
    mainCategory: json['mainCategory']! as String,
    subCatName: json['subCatName']! as String,
    image: json['image']! as String,
  );

  final String? mainCategory;
  final String? subCatName;
  final String? image;

  Map<String, Object?> toJson() {
    return {
      'mainCategory': mainCategory,
      'subCatName': subCatName,
      'image': image,
    };
  }


}
FirebaseService _service = FirebaseService();
subCategoryCollection({selectedSubCat}){
  return _service.subCategories.where('active',isEqualTo: true).where('mainCategory',isEqualTo:selectedSubCat ).withConverter<SubCategory>(
    fromFirestore: (snapshot, _) => SubCategory.fromJson(snapshot.data()!),
    toFirestore: (movie, _) => movie.toJson(),
  );
}

//now we have a model to retrieve datas from firestore.
