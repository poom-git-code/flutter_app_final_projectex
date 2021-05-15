import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app_final_projectex/model/covid.dart';

Future<bool> apiInsertTimeline(String locationName, String goWith, String date, String image, String time) async{
  //สร้าง object เพื่อนไปเก็บที่ firestore database
  covid timeline = covid(
      locationName: locationName,
      goWith: goWith,
      date: date,
      time: time,
      image: image
  );

  //นำ object แปลงเป็น json แล้วส่งไปที่ firestore database
  try{
    await FirebaseFirestore.instance.collection("covid").add(timeline.toJson());
    return true;
  }catch(ex){
    return false;
  }
}

Stream<QuerySnapshot> apiGetAllLocation(){
  try{
    return FirebaseFirestore.instance.collection('covid').snapshots();
  }catch(ex){
    return null;
  }
}

Future<bool> apiUpdateLocation(String id, String locationName, String goWith, String date, String time, String image) async{
  //สร้าง object เพื่อนไปเก็บที่ firestore database

  covid timeline = covid(
      locationName: locationName,
      goWith: goWith,
      date: date,
      time: time,
      image: image
  );

  //นำ object แปลงเป็น json แล้วส่งไปที่ firestore database
  try{
    await FirebaseFirestore.instance.collection("covid").doc(id).update(timeline.toJson());
    return true;
  }catch(ex){
    return false;
  }

}

Future<bool> apiDeleteLocation(String id) async{
  try{
    await FirebaseFirestore.instance.collection('covid').doc(id).delete();
    return true;
  }catch(ex){
    return false;
  }
}