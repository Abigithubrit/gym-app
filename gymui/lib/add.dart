import 'package:cloud_firestore/cloud_firestore.dart';

class Menus
{
  String? menuID;
  String? sellerUID;
  String? Title;
  String? level;
  String? bodyfocus;
  String? shortInfo;
  String? duration;
  Timestamp? publishedDate;
  String? thumbnailUrl;
  String? status;

  Menus({
    this.menuID,
    this.sellerUID,
    this.Title,
    this.duration,
    this.level,
    this.bodyfocus,
    this.shortInfo,
    this.publishedDate,
    this.thumbnailUrl,
    this.status,
  });

  Menus.fromJson(Map<String, dynamic> json)
  {
    menuID = json["menuID"];
    sellerUID = json['sellerUID'];
    Title = json['Title'];
    level = json['level'];
    duration = json['duration'];
    bodyfocus = json['partsfocus'];
    shortInfo = json['shortinfo'];
    publishedDate = json['publishedDate'];
    thumbnailUrl = json['thumbnailUrl'];
    status = json['status'];
  }

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["menuID"] = menuID;
    data['sellerUID'] = sellerUID;
    data['Title'] = Title;
    data['shortinfo'] = shortInfo;
    data['duration'] = duration;
     data['partsfocus'] = bodyfocus;
    data['publishedDate'] = publishedDate;
    data['thumbnailUrl'] = thumbnailUrl;
    data['status'] = status;

    return data;
  }
}