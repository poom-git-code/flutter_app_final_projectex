class covid {
  String id;
  String image;
  String locationName;
  String date;
  String time;
  String goWith;

  covid(
      {
        this.id,
        this.image,
        this.locationName,
        this.date,
        this.time,
        this.goWith
      });

  covid.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    locationName = json['location_name'];
    date = json['date'];
    time = json['time'];
    goWith = json['go_with'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['location_name'] = this.locationName;
    data['date'] = this.date;
    data['time'] = this.time;
    data['go_with'] = this.goWith;
    return data;
  }
}