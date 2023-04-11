import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:gymui/authentication/loginscreen.dart';
import 'package:gymui/servises/globalmethods.dart';
import 'package:gymui/servises/globalvarianles.dart';
import 'package:image_cropper/image_cropper.dart';

import 'package:image_picker/image_picker.dart';
class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> with TickerProviderStateMixin {
   late Animation<double> _animation;
late  AnimationController _animationController;

bool _isLoading = false;
final FirebaseAuth _auth = FirebaseAuth.instance;
bool _obsecureText = true;
TextEditingController _nameTextController = TextEditingController(text: '');
TextEditingController _emailTextController = TextEditingController(text: '');
TextEditingController _passTextController = TextEditingController(text: '');
TextEditingController _phoneTextController = TextEditingController(text: '');
TextEditingController _locationTextController = TextEditingController(text: '');

final FocusNode _phoneFocusNode =FocusNode();
final FocusNode _emailFocusNode =FocusNode();
final FocusNode _passFocusNode =FocusNode();
final FocusNode _positionCfFocusNode =FocusNode();

final _signUpFormKey = GlobalKey<FormState>();
File? imageFile;
String? imageUrl;

@override
void dispose() {
  _animationController.dispose();
  _nameTextController.dispose();
  _emailTextController.dispose();
  _passTextController.dispose();
  _phoneTextController.dispose();
  _emailFocusNode.dispose();
  _passFocusNode.dispose();
  _phoneFocusNode.dispose();
  _positionCfFocusNode.dispose();
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
  void _getfromcamera()async{
  XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
  _cropImage(pickedFile!.path);
  Navigator.pop(context);
  }

  void _getfromgallery()async{
  XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
  _cropImage(pickedFile!.path);
  Navigator.pop(context);
  }
  void _cropImage(filePath)async{
   CroppedFile? croppedImage = await ImageCropper().cropImage(
    sourcePath: filePath,maxHeight: 1080,maxWidth: 1080);
    if (croppedImage !=null){
      setState(() {
        imageFile = File(croppedImage.path);
      });
    } 
  }

  void _showImageDialog(){
   showDialog(context: context,
    builder: (context) {
      
      return AlertDialog(
        title: Text('Please choose an option'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () {
                _getfromcamera();
              },
              //from camera
              child: Row(
                children: [
                  Padding(padding: EdgeInsets.all(4),
                  child: Icon(Icons.camera,color: Colors.purple,),),
                  Text('Camera',
                  style: TextStyle(
                    color: Colors.purple,
                  ),)
                ],
              ),
            ),
            SizedBox(height: 10,),
             InkWell(
              onTap: () {
                _getfromgallery();
              },
              //from  gallery
              child: Row(
                children: [
                  Padding(padding: EdgeInsets.all(4),
                  child: Icon(Icons.image,color: Colors.purple,),),
                  Text('Gallery',
                  style: TextStyle(
                    color: Colors.purple,
                  ),)
                ],
              ),
            ),
            ],
        ),
      );
    },);
  }
  void _submitFormOnSignUp()async{
    final isValid = _signUpFormKey.currentState!.validate();
    if(isValid){
      if(imageFile == null){
        GlobalMethod.showErrorDialog(error: 'Please pick an image',
      
        context: context);
        return;
      }
      setState(() {
        _isLoading = true;
      });
      try{
        await _auth.createUserWithEmailAndPassword(
          email: _emailTextController.text.trim(),
           password: _passTextController.text.trim());
           final User? user = _auth.currentUser;
           final _uid = user!.uid;
           final ref = FirebaseStorage.instance.ref().child('userImages').child(_uid + '.jpg');
           await ref.putFile(imageFile!);
           imageUrl = await ref.getDownloadURL();
           FirebaseFirestore.instance.collection('users')
           .doc(_uid).set({
            'id':_uid,
            'name': _nameTextController.text.trim(),
            'email':_emailTextController.text.trim(),
            'userImage': imageUrl,
            'phoneNumber': _phoneTextController.text.trim(),
            'location': _locationTextController.text.trim(),
            'createdAt': Timestamp.now()
           });
           Navigator.canPop(context) ? Navigator.pop(context) : null;
      }catch(error){
        setState(() {
          _isLoading = false;
        });
        GlobalMethod.showErrorDialog(
          error: error.toString(),
          context: context
        );
      }

    }
    setState(() {
          _isLoading = false;
        });
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          CachedNetworkImage(
            imageUrl:signUpUrlImage,
            fit: BoxFit.cover,
            
            placeholder: (context, url) => Image.asset('images/2.jpg',
            fit: BoxFit.cover,
            ),
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
                  Form(
                    key: _signUpFormKey,
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _showImageDialog();
                          },
                          child: Padding(padding:EdgeInsets.all(8),
                          child: Container(
                            width: size.width * 0.24,
                            height: size.width*0.24,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Colors.cyanAccent
                              ),
                              borderRadius: BorderRadius.circular(20)
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: imageFile == null
                              ? Icon(Icons.camera_enhance_sharp,color: Colors.cyan,size: 30,)
                              : Image.file(imageFile!,fit: BoxFit.fill,),
                            ),
                          ),),
                        ),
                        TextFormField(
                            textInputAction: TextInputAction.next,
                            
                         
                            controller: _nameTextController,
                              validator: (value) {
                              if (value!.isEmpty )
                              {
                                return 'Please enter your name';
                              }
                              else{
                                return null;
                              }
                            },
                        
                            style: TextStyle(
                              color: Colors.white,)
,                              decoration: InputDecoration(
                                hintText: 'Name of admin',
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
                            onEditingComplete: () => FocusScope.of(context).requestFocus(_emailFocusNode),
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
                           onEditingComplete: () => FocusScope.of(context).requestFocus(_passFocusNode),
                            textInputAction: TextInputAction.next,
                            focusNode: _emailFocusNode,
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
                          SizedBox(height: 5,),
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            onEditingComplete: () => FocusScope.of(context).requestFocus(_phoneFocusNode),
                            keyboardType: TextInputType.phone,
                            controller: _phoneTextController,

                            validator: (value) {
                              if (value!.isEmpty )
                              {
                                return 'Please enter phone number';
                              }
                              else{
                                return null;
                              }
                            },
                            style: TextStyle(
                              color: Colors.white,)
,                              decoration: InputDecoration(
                                hintText: 'Enter phone number',
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
                          
                          SizedBox(height: 25,),
                        
                          _isLoading 
                          ? Center(child: Container(
                            width: 70,
                            height: 70,
                            child: CircularProgressIndicator(),
                          ),)
                          : MaterialButton(onPressed: (){
                            _submitFormOnSignUp();
                          },
                          //create signupformon signupscreen
                          color: Colors.cyan,
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                            
                          ),
                          child: Padding(padding: EdgeInsets.symmetric(vertical: 14),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('SignUp',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),)
                            ],
                          ),),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Already have an account?',
                              style: TextStyle(
                                 fontWeight: FontWeight.bold,
                                color: Colors.white,fontSize: 14
                              ),),
                              SizedBox(width: 10,),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => Login(),));
                                },
                                child: Text('Login Now',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,fontSize: 14
                                ),),
                              ),
                            ],
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