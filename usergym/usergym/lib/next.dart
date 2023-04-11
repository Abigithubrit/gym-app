import 'package:flutter/material.dart';

next(context,page){
  Navigator.push(context, MaterialPageRoute(builder: (context) => page,));
}