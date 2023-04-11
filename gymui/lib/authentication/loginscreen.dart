
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gymui/authentication/forgetpassword.dart';
import 'package:gymui/authentication/signupscreen.dart';
import 'package:gymui/servises/globalmethods.dart';
import 'package:gymui/servises/globalvarianles.dart';
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin {
 late Animation<double> _animation;
late  AnimationController _animationController;
final _loginFormKey =GlobalKey<FormState>();
final FocusNode _passFocusNode =FocusNode();
TextEditingController _emailTextController = TextEditingController(text: '');
TextEditingController _passTextController = TextEditingController(text: '');

bool _isLoading = false;
final FirebaseAuth _auth = FirebaseAuth.instance;
bool _obsecureText = true;
@override
void dispose() {
  _animationController.dispose();
  _emailTextController.dispose();
  _passTextController.dispose();
  _passFocusNode.dispose();
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

  void _submitFormOnLogin()async
  {
    final isValid = _loginFormKey.currentState!.validate();
    if(isValid)
    {
      setState(() {
        _isLoading = true;
      });
      try
      {
        await _auth.signInWithEmailAndPassword(
        email: _emailTextController.text.trim(),
        password: _passTextController.text.trim());
        Navigator.canPop(context) ? Navigator.pop(context) : null;
        }
        catch(error)
        {
          setState(() {
            _isLoading = false;
          });
          GlobalMethod.showErrorDialog(error: error.toString(),context: context);
          print('error');
        }
    }
    setState(() {
    _isLoading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: loginUrlImage,
            fit: BoxFit.cover,
            placeholder: (context, url) => Image.asset(
              'images/1.jfif',
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
                    Padding(padding: EdgeInsets.only(
                      right: 80,left: 80
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Image.asset('images/1.jfif',
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,)),),
                    SizedBox(height: 15,),
                    Form(
                      key: _loginFormKey,
                      child: Column(
                        children: [
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            onEditingComplete: () => FocusScope.of(context).requestFocus(_passFocusNode),
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
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            focusNode: _passFocusNode,
                            keyboardType: TextInputType.visiblePassword,
                            controller: _passTextController,
                            obscureText: !_obsecureText, //change it dynamically
                            validator: (value)
                            {
                              if(value!.isEmpty || value.length < 6)
                              {
                                return 'Please enter a valid password';
                              }
                              else{
                                return null;
                              }
                            },
                            style: TextStyle(
                              color: Colors.white,)
,                              decoration: InputDecoration(
  suffixIcon: GestureDetector(
    onTap: (){
      setState(() {
        _obsecureText =!_obsecureText;
      });
    },
    child: Icon(_obsecureText ? Icons.visibility:Icons.visibility_off,color: Colors.white,)),
                                hintText: 'Enter a password',
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
                          SizedBox(height:10),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: TextButton(onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => ForgetPassword(),));
                            },
                             child: Text('Forget Password?',
                             style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.white
                             ),)),
                          ),
                          SizedBox(height: 10,),
                          MaterialButton(onPressed: _submitFormOnLogin,
                          color: Colors.cyan,
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            
                          ),
                          child: Padding(padding: EdgeInsets.symmetric(vertical: 14,),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Login',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20
                              ),)
                            ],
                          ),),
                          ),
                          SizedBox(height: 40,),
                          Center(
                            child: RichText(text: TextSpan(
                              children: [
                                TextSpan(text: 'Do not have an account?',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold
                                )),
                                TextSpan(
                                  text: '   '
                                ),
                                TextSpan(
                                  recognizer: TapGestureRecognizer(
                                  
                                  )..onTap =() => Navigator.push(context, MaterialPageRoute(builder:(context) => SignUp(),
                                  )),
                                  text: 'SignUp',
                                  style: TextStyle(color: Colors.blue,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,)
                                )
                              ]
                            )),
                          )

                        ],
                      ))
                  ],
                ),),
              )
              
              
        ],
      ),
    );
  }
}