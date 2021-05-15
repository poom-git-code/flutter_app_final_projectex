import 'package:flutter/material.dart';
import 'package:flutter_app_final_projectex/screens/insert_place_ui.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app_final_projectex/screens/update_delete_location_timeline.dart';
import 'package:flutter_app_final_projectex/service/api_covid.dart';

class HomeUI extends StatefulWidget {
  @override
  _HomeUIState createState() => _HomeUIState();
}

class _HomeUIState extends State<HomeUI> {

  Stream<QuerySnapshot> allLocationName;

  getAllLocation() {
    allLocationName = apiGetAllLocation();
  }

  @override
  void initState() {
    // TODO: implement initState
    getAllLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Covid Timeline App",
          style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white
          ),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => InsertPlaceUI()
              )
          );
        },
        backgroundColor: Color(0xffd55e2d),
        label: Text(
          "เพิ่มสถานที่",
          style: TextStyle(
              fontWeight: FontWeight.bold
          ),
        ),
        icon: Icon(
            Icons.add
        ),
      ),
      body: StreamBuilder(
        stream: allLocationName,
        // ignore: missing_return
        builder: (context, snapshot){
          if(snapshot.hasError)
          {
            return Center(
              child: Text('พบข้อผิดพลาดกรุณาลองใหม่อีกครั้ง'),
            );
          }
          if(snapshot.connectionState == ConnectionState.waiting)
          {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.separated(
            // ignore: missing_return
            separatorBuilder: (context, index){
              return Container(
                height: 2,
                width: double.infinity,
                color: Colors.grey,
              );
            },
            itemCount: snapshot.data.docs.length,

            // ignore: missing_return
            itemBuilder: (context, index){
              return ListTile(
                onTap: (){
                  //เปืดไปหน้า update delete
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UpdateDeleteLocationTimeline(
                            snapshot.data.docs[index].id.toString(),
                            snapshot.data.docs[index]['location_name'],
                            snapshot.data.docs[index]['go_with'],
                            snapshot.data.docs[index]['time'],
                            snapshot.data.docs[index]['date'],
                            snapshot.data.docs[index]['image'],
                          )
                      )
                  ).then((value) => getAllLocation());
                },
                leading: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.transparent,
                  child: ClipOval(
                    child: FadeInImage.assetNetwork(
                      placeholder: 'assets/images/location.png',
                      image: snapshot.data.docs[index]['image'],
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                title: Text(
                  snapshot.data.docs[index]['location_name'],
                ),
                subtitle: Text(
                  snapshot.data.docs[index]['date'],
                ),
                trailing: IconButton(
                    icon: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.pink,
                    )
                ),
              );
            },

          );
        },
      ),

    );
  }
}
