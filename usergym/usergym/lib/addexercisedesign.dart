import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';



import 'dart:math' as Math;

import 'package:usergym/add.dart';








class SellersDesignWidget extends StatefulWidget {
  Menus? model;
  BuildContext? context;

  SellersDesignWidget({this.model, this.context});

  @override
  _SellersDesignWidgetState createState() => _SellersDesignWidgetState();
}

class _SellersDesignWidgetState extends State<SellersDesignWidget> {





  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (c) => ItemScreen(model: widget.model)));
      },
      splashColor: Colors.red,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Container(
          height: 200,
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.network(
                      widget.model!.thumbnailUrl!,
                      height: 200.0,
                      width: double.infinity,
                      fit: BoxFit.fill,
                    ),
              ),
              Positioned(
                top: 20,
                left: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                      Text(
                  widget.model!.level!+' level',
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: 20,
                    fontFamily: "Signatra",
                  ),
                ),
                     Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  Text(
                  widget.model!.Title!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: "Signatra",
                  ),
                ),
                SizedBox(width: 5,),
                 
                ],),
                SizedBox(height: 60,),
                 Text(
                  widget.model!.shortInfo!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: "Signatra",
                  ),
                ),
                 Text(
                  widget.model!.bodyfocus!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: "Signatra",
                  ),
                ),
                 Text(
                  'Duration: '+widget.model!.duration!+' min',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: "Signatra",
                  ),
                ),
                
                  ],
                )),
                Positioned(
                  bottom: 20,
                  right: 20,
                  child:Container(
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(16)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14,vertical: 6),
                      child: Text('Start',
                      style: TextStyle(fontSize: 18,
                      fontWeight: FontWeight.bold),),
                    ),
                  ))
            ],
          ),
        ),
      )
    );
  }




}

