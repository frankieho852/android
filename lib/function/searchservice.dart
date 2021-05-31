
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchService{
  String sortrequirement = "";
  searchfunctionshop(String searchField){
    return FirebaseFirestore.instance.collection('shops')
        .where('searchKeywords', arrayContains: searchField)
        .get();
  }

  searchfunctionproduct(String searchField){
    return FirebaseFirestore.instance.collection('products')
        .where('searchKeywords', arrayContains: searchField)
        .get();
  }

  searchfunctionsort(String searchField, String sort){

    if(sort == 'Price'){
      sortrequirement = "price";
    }else{
      sortrequirement  = "rating";
    }

    print("the value sortrequirement: " + sortrequirement);

    return FirebaseFirestore.instance.collection('products')
        .where('searchKeywords', arrayContains: searchField)
        .orderBy(sortrequirement, descending: true)
        .get();
  }


}