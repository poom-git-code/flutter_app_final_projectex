import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_final_projectex/service/api_covid.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:intl/intl.dart';

class UpdateDeleteLocationTimeline extends StatefulWidget {

  String id;
  String locationName;
  String goWith;
  String time;
  String date;
  String image;

  UpdateDeleteLocationTimeline(this.id, this.locationName, this.goWith,
      this.time, this.date, this.image);

  @override
  _UpdateDeleteLocationTimelineState createState() => _UpdateDeleteLocationTimelineState();
}

class _UpdateDeleteLocationTimelineState extends State<UpdateDeleteLocationTimeline> {

  File _image;
  TimeOfDay time;
  DateTime date;

  TextEditingController namelocationCtrl = TextEditingController(text: '');
  TextEditingController goWithCtrl = TextEditingController(text: '');
  TextEditingController dateCtrl = TextEditingController(text: '');
  TextEditingController timeCtrl = TextEditingController(text: '');

  String getTextTime() {
    if (time == null) {
      return 'Select Time';
    } else {
      final hours = time.hour.toString().padLeft(2, '0');
      final minutes = time.minute.toString().padLeft(2, '0');

      return '$hours:$minutes';
    }
  }

  String getTextDate() {
    if (date == null) {
      return 'Select Date';
    } else {
      return DateFormat('dd/MM/yyyy').format(date);
//       return '${date.day}/${date.month}/${date.year}';
    }
  }

  Future pickDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: date ?? initialDate,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
    );

    if (newDate == null) return;

    setState(() => date = newDate);
  }

  Future pickTime(BuildContext context) async {
    final initialTime = TimeOfDay(hour: 9, minute: 0);
    final newTime = await showTimePicker(
      context: context,
      initialTime: time ?? initialTime,
    );

    if (newTime == null) return;

    setState(() => time = newTime);
  }

  showBottomSheetForSelectImage(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 28.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: TextButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    showSelectImageFromCamera();
                  },
                  style: TextButton.styleFrom(
                    primary: Colors.pink,
                  ),
                  icon: Icon(Icons.camera_alt),
                  label: Text('กล้อง'),
                ),
              ),
              SizedBox(
                width: 16.0,
              ),
              Expanded(
                child: TextButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    showSelectImageFormGallery();
                  },
                  style: TextButton.styleFrom(
                    primary: Colors.deepPurpleAccent,
                  ),
                  icon: Icon(Icons.camera),
                  label: Text('แกลอรี่'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  showSelectImageFormGallery() async {
    PickedFile imageFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      imageQuality: 75,
    );
    if (imageFile == null) return;
    setState(() {
      _image = File(imageFile.path);
    });
  }

  showSelectImageFromCamera() async {
    PickedFile imageFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      imageQuality: 75,
    );
    if (imageFile == null) return;
    setState(() {
      _image = File(imageFile.path);
    });
  }

  showWarningDialog(String msg) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: Container(
              width: double.infinity,
              color: Color(0xFFEC4646),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 8.0,
                ),
                child: Text(
                  'คำเตือน',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                msg,
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 16.0,
                  left: 32.0,
                  right: 32.0,
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                          padding: EdgeInsets.symmetric(
                            vertical: 12.0,
                          ),
                        ),
                        child: Text(
                          'ตกลง',
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ignore: non_constant_identifier_names
  ShowResultInsertDialog(String msg) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: Container(
              width: double.infinity,
              color: Color(0xFFEC4646),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 8.0,
                ),
                child: Text(
                  'ผลการทำงาน',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                msg,
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 16.0,
                  left: 32.0,
                  right: 32.0,
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).popUntil((route) => route.isFirst);
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                          padding: EdgeInsets.symmetric(
                            vertical: 12.0,
                          ),
                        ),
                        child: Text(
                          'ตกลง',
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  showResultDeleteDialog(String msg) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: Container(
              width: double.infinity,
              color: Color(0xFFEC4646),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 8.0,
                ),
                child: Text(
                  'ผลการทำงาน',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                msg,
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 16.0,
                  left: 32.0,
                  right: 32.0,
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).popUntil((route) => route.isFirst);
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                          padding: EdgeInsets.symmetric(
                            vertical: 12.0,
                          ),
                        ),
                        child: Text(
                          'ตกลง',
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ignore: non_constant_identifier_names
  ShowResultUpdateDialog(String msg) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: Container(
              width: double.infinity,
              color: Color(0xFFEC4646),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 8.0,
                ),
                child: Text(
                  'ผลการทำงาน',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                msg,
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 16.0,
                  left: 32.0,
                  right: 32.0,
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).popUntil((route) => route.isFirst);
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                          padding: EdgeInsets.symmetric(
                            vertical: 12.0,
                          ),
                        ),
                        child: Text(
                          'ตกลง',
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  showConfirmUpdateDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: Container(
              width: double.infinity,
              color: Color(0xFFEC4646),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 8.0,
                ),
                child: Text(
                  'ยืนยัน',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'ต้องการแก้ไข้ข้อมูลหรือไม่ ?',
                style: TextStyle(),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 16.0,
                  left: 32.0,
                  right: 32.0,
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          updateLocation();
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                          padding: EdgeInsets.symmetric(
                            vertical: 12.0,
                          ),
                        ),
                        child: Text(
                          'ตกลง',
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 16.0,
                    ),
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red,
                          padding: EdgeInsets.symmetric(
                            vertical: 12.0,
                          ),
                        ),
                        child: Text(
                          'ยกเลิก',
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  showConfirmDeleteDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: Container(
              width: double.infinity,
              color: Color(0xFFEC4646),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 8.0,
                ),
                child: Text(
                  'ยืนยัน',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'ต้องการบลบข้อมูลหรือไม่ ?',
                style: TextStyle(),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 16.0,
                  left: 32.0,
                  right: 32.0,
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          deleteLocation();
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                          padding: EdgeInsets.symmetric(
                            vertical: 12.0,
                          ),
                        ),
                        child: Text(
                          'ตกลง',
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 16.0,
                    ),
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red,
                          padding: EdgeInsets.symmetric(
                            vertical: 12.0,
                          ),
                        ),
                        child: Text(
                          'ยกเลิก',
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  deleteLocation() async{
    bool result = await apiDeleteLocation(widget.id);

    //ลบไฟล์ออกจาก Storage
    FirebaseStorage.instance.refFromURL(widget.image).delete();

    //นำผลที่ได้จากการทำงานมาตรวจสอบเเล้วแสดง
    if(result == true){
      showResultDeleteDialog('ลบข้อมูลเรียบร้อยเเล้ว');
    }else{
      showResultDeleteDialog('มีปัญหาในการลบข้อมูลกรุณารองใหม่อีกครั้ง');
    }
  }

  updateLocation() async{
    if(_image != null){
      //อัปโหลดรูปรูปไปไว้ที่ storage ของ Firebase เพราะเราต้องการตำแหน่งรูปมาใช้เพื่อเก็บใน firestore
      //ชื่อรูป
      String imageName = Path.basename(_image.path);
      FirebaseStorage.instance.refFromURL(widget.image).delete();

      //อัปโหลดรุปไปที่ storage ที่ firebase
      Reference ref =  FirebaseStorage.instance.ref().child('imageTimeline/' + imageName);
      UploadTask uploadTask = ref.putFile(_image);
      //เมื่ออัปโหลดรูปเสร็จเราจะได้ที่อยู่ของรูป แล้วเราก็จะส่งที่อยู่อยู่ของรูปไปพร้อมกับข้อมูลอื่นๆ ไปเก็บที่ Firestore Database ของ Firebase
      uploadTask.whenComplete(() async{
        String imgeUrl = await ref.getDownloadURL();

        //ทำการอัปโหลดที่อยู่ของรูปพร้อมกับข้อมูลอื่นๆ โดยจะเรียกใช้ api
        bool resultInsertFriend = await apiUpdateLocation(
            widget.id,
            namelocationCtrl.text.trim(),
            goWithCtrl.text.trim(),
            dateCtrl.text.trim(),
            timeCtrl.text.trim(),
            imgeUrl
        );
        if(resultInsertFriend == true)
        {
          ShowResultUpdateDialog("บันทึกเการแก้ไขเรียบร้อยเเล้ว");
        }
        else
        {
          ShowResultUpdateDialog("พบปัญหาในการทำงานกรุณาลองใหม่อีกครั้ง");
        }
      });
    }else{
      bool resultInsertFriend = await apiUpdateLocation(
          widget.id,
          namelocationCtrl.text.trim(),
          goWithCtrl.text.trim(),
          dateCtrl.text.trim(),
          timeCtrl.text.trim(),
          widget.image
      );
      if(resultInsertFriend == true)
      {
        ShowResultUpdateDialog("บันทึกเการแก้ไขเรียบร้อยเเล้ว");
      }
      else
      {
        ShowResultUpdateDialog("พบปัญหาในการทำงานกรุณาลองใหม่อีกครั้ง");
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    namelocationCtrl.text = widget.locationName;
    goWithCtrl.text = widget.goWith;
    dateCtrl.text = widget.date;
    timeCtrl.text = widget.time;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "เพิ่ม Covid Timeline App",
          style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white
          ),
        ),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 26,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    CircleAvatar(
                      radius: 100.0,
                      backgroundColor: Color(0xffd55e2d),
                      child: ClipOval(
                        child: SizedBox(
                          width: 180.0,
                          height: 180.0,
                          child: _image != null
                              ?
                          Image.file(
                            _image,
                            fit: BoxFit.cover,
                          )
                              :
                          FadeInImage.assetNetwork(
                            placeholder: 'assets/images/location.png',
                            image: widget.image,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 60.0),
                      child: IconButton(
                        onPressed: () {
                          showBottomSheetForSelectImage(context);
                        },
                        icon: Icon(
                          Icons.add_a_photo,
                          size: 30.0,
                          color: Color(0xffd55e2d),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 26,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40.0,
                  vertical: 5.0,
                ),
                child: TextField(
                  controller: namelocationCtrl,
                  decoration: InputDecoration(
                    labelText: "ชื่อสถานที่",
                    hintText: "ป้อนสถานที่",
                    hintStyle: TextStyle(
                      color: Colors.grey[300],
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    suffixIcon: Icon(Icons.account_balance_rounded),
                  ),
                  keyboardType: TextInputType.text,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40.0,
                  vertical: 10.0,
                ),
                child: TextField(
                  controller: goWithCtrl,
                  decoration: InputDecoration(
                    labelText: "ชื่อคนที่ไปด้วย",
                    hintText: "ป้อนชื่อ",
                    hintStyle: TextStyle(
                      color: Colors.grey[300],
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    suffixIcon: Icon(Icons.wc),
                  ),
                  keyboardType: TextInputType.text,
                ),
              ),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40.0,
                        vertical: 5.0,
                      ),
                      child: TextField(
                        controller: dateCtrl,
                        decoration: InputDecoration(
                          hintText: getTextDate(),
                          hintStyle: TextStyle(
                            color: Colors.black,
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          suffixIcon: Icon(Icons.date_range),
                        ),
                        keyboardType: TextInputType.text,
                        enabled: false,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 35),
                    child: ElevatedButton(
                      onPressed: (){
                        pickDate(context);
                        dateCtrl.text = '';
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.deepOrangeAccent,
                      ),
                      child: Text(
                        "+",
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.black
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40.0,
                        vertical: 5.0,
                      ),
                      child: TextField(
                        controller: timeCtrl,
                        decoration: InputDecoration(
                          hintText: getTextTime(),
                          hintStyle: TextStyle(
                            color: Colors.black,
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          suffixIcon: Icon(Icons.more_time),
                        ),
                        keyboardType: TextInputType.text,
                        enabled: false,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 35),
                    child: ElevatedButton(
                      onPressed: (){
                        pickTime(context);
                        timeCtrl.text = '';
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.deepOrangeAccent,
                      ),
                      child: Text(
                        "+",
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.black
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40.0,
                  vertical: 40.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (namelocationCtrl.text.trim().length == 0) {
                            showWarningDialog('กรุณาใส่ชื่อสถานที่ด้วย');
                          }
                          else if (goWithCtrl.text.trim().length == 0) {
                            showWarningDialog('กรุณาใส่ชื่อคนที่ไปด้วย');
                          }
                          else {
                            showConfirmUpdateDialog();
                            if(time == null && date == null){
                              dateCtrl.text = widget.date;
                              timeCtrl.text = widget.time;
                            }else{
                              dateCtrl.text = getTextDate();
                              timeCtrl.text = getTextTime();
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                          padding: EdgeInsets.symmetric(
                            vertical: 12.0,
                          ),
                        ),
                        child: Text(
                          'แก้ไข้',
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 16.0,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          showConfirmDeleteDialog();
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red,
                          padding: EdgeInsets.symmetric(
                            vertical: 12.0,
                          ),
                        ),
                        child: Text(
                          'ลบ',
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
