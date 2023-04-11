import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gymui/add.dart';
import 'package:gymui/addexercisedesign.dart';
import 'package:gymui/addexercisescreen.dart';
import 'package:gymui/circularprogress.dart';
import 'package:gymui/next.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20,),
              Text('Eat Sleep And Gym',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Exercises',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.bold
                ),),
                Icon(Icons.search)
                  ],
                ),
                 Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Add Exercises',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.bold
                ),),
                IconButton(onPressed: (){
                  next(context, AddExercise());
                },
                 icon: Icon(Icons.add))
                  ],
                ),
                 Container(
              
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('sellers')
           
                .orderBy('publishedDate',descending: true)
                .snapshots(),
            
                builder:(context, snapshot) {
                  return !snapshot.hasData? 
                  Center(child: circularProgress(),)
                  :ListView.builder(
                    shrinkWrap: true,
                    primary: true,
                    physics: NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data!.docs.length,
                   
                    itemBuilder:(context, index) {
                    Menus sModel = Menus.fromJson(
                        snapshot.data!.docs[index].data() as Map<String,dynamic>
                      );
                      //design for display sellers cafes
                      return SellersDesignWidget(
                        model: sModel,
                        context: context,
                      );
                    },);
                }, ),
            )
            ],
          ),
        ),
      ),
    );
  }
}