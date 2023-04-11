import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gymui/authentication/loginscreen.dart';
import 'package:gymui/homescreen.dart';
import 'package:gymui/next.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
startTimer() {
    Timer(const Duration(seconds: 1), () async {
      //if seller is loggedin already
      if (FirebaseAuth.instance.currentUser != null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => const HomeScreen()));
      }
      //if seller is NOT loggedin already
      else {
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => const Login()));
      }
    });
  }
  @override
  void initState() {
    super.initState();

    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Stack(
        children: [
          Image.asset('images/1.jfif',
          fit: BoxFit.fill,
          height: double.infinity,
          width: double.infinity,),
          Positioned(
          top: 400,
          left: 20,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Workout Day and Night',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold
                ),),
                SizedBox(height: 10,),
                Text('Carlos \nFernandez',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold
                ),),
                Container(
                  width: MediaQuery.of(context).size.width-30,
                  child: Text('Build Muscle,arms growth, thigh muscles biceps triceps arms dhoulders with in a shoet period of time.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold
                  ),),
                ),
                SizedBox(height: 10,),
                GestureDetector(
                  onTap: () {
                    next(context, Login());
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.green,
                              shape: BoxShape.circle
                      
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.arrow_forward),
                    ),
                  ),
                )
              ],
            ))
        ],
      )
    );
  }
}