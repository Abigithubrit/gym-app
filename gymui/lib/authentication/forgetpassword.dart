
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gymui/servises/globalvarianles.dart';
class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> with TickerProviderStateMixin {
 late Animation<double> _animation;
late  AnimationController _animationController;
TextEditingController _emailTextController = TextEditingController(text: '');


@override
void dispose() {
  _animationController.dispose();
  _emailTextController.dispose();
 
    super.dispose();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController = AnimationController(vsync: this,duration: const Duration(seconds: 20));
    _animation = CurvedAnimation(parent: _animationController, curve:Curves.linear)
    ..addListener((){
        setState(() {
          
        });
    })

    ..addStatusListener((animationStatus) {
      if(animationStatus == AnimationStatus.completed)
      {
        _animationController.reset();
        _animationController.forward();
      }
     });
     _animationController.forward();
  }
Future passwordreset()async{
try{
    await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailTextController.text.trim());
showDialog(context: context,
   builder: (context){
    return AlertDialog(
      content: Text('Password reset Sent email'),
    );
   });
} on FirebaseAuthException catch (e){
  print(e);
  showDialog(context: context,
   builder: (context){
    return AlertDialog(
      content: Text(e.message.toString()),
    );
   });
}
}
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: forgetUrlImage,
            fit: BoxFit.cover,
            placeholder: (context, url) => Image.asset(
              'images/3.jpg',
              fit: BoxFit.fill,),
              errorWidget: (context, url, error) => Icon(Icons.error),
              width: double.infinity,
              height: double.infinity,
             
              alignment: FractionalOffset(_animation.value,0),
              
              ),
              Container(
                color: Colors.black54,
                child: Padding(padding: EdgeInsets.symmetric(horizontal: 16,vertical: 80),
                child: ListView(
                  children: [
                    SizedBox(height: 100,),
                  Text('Forget Password',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,fontWeight: FontWeight.bold,
                    fontFamily: "Signatra",
                    letterSpacing: 3,
                    fontStyle: FontStyle.italic
                  ),),
                    SizedBox(height: 15,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Email Address',style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                        ),),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailTextController,

                          validator: (value) {
                            if (value!.isEmpty || !value.contains('@'))
                            {
                              return 'Please enter valid email address';
                            }
                            else{
                              return null;
                            }
                          },
                          style: TextStyle(
                            color: Colors.white,)
,                              decoration: InputDecoration(
                              hintText: 'Enter an email',
                              hintStyle: TextStyle(color: Colors.white),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white,
                                ),
                                
                              ) ,
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)
                              ),
                              errorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.red)
                              ),
                          
                          ),
                        ),
                        SizedBox(height: 5,),
                       
                        SizedBox(height: 40,),
                        GestureDetector(
                          onTap: () {
                            passwordreset();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(12)
                            ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Reset Now',
                                style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 14),),
                              ),
                            ),
                          ),
                        )
                       
                     
                      ],
                    )
                  ],
                ),),
              )
              
              
        ],
      ),
    );
  }
}