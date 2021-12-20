import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      debugShowCheckedModeBanner: false,
      home: homepage(),
    );
  }
}

class homepage extends StatefulWidget {
  const homepage({Key? key}) : super(key: key);

  @override
  _homepageState createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  
  final firebaseRef = FirebaseDatabase.instance.reference().child("Users Data");
  
  var formKey = GlobalKey<FormState>();
  var _value = 1;
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var emailController = TextEditingController();
  var addressController = TextEditingController();
  var passwordController = TextEditingController();

  var name, phone, email, address, password;

  handleSignUpData() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      print("Name is : ${this.name}");
      print("Phone is : ${this.phone}");
      print("Email is : ${this.email}");
      print("Address is : ${this.address}");
      print("Password is : ${this.password}");
    }
  }
  _sendFirebase(){
    if(formKey.currentState!.validate()){
      firebaseRef.push().set({
        "Name": nameController.text,
        "email": emailController.text,
        "phone": phoneController.text,
        "address": addressController.text,
        "password": passwordController.text
      }).then((value){
        Scaffold.of(context).showSnackBar(SnackBar(content: Text("Succesfully Sent")));
        nameController.clear();
        emailController.clear();
        phoneController.clear();
        addressController.clear();
        passwordController.clear();
      }).catchError((onError){
        Scaffold.of(context).showSnackBar(SnackBar(content: Text("Sending Failed")));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up Page"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Text(
              "Sign Up Page",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: nameController,
                            keyboardType: TextInputType.name,
                            decoration:
                                InputDecoration(labelText: "Enter Your Name"),
                            validator: (val) {
                              if (val!.isEmpty) {
                                return ("Enter your name");
                              }
                            },
                            onSaved: (value) {
                              this.name = value;
                            },
                          ),
                          TextFormField(
                            controller: phoneController,
                            keyboardType: TextInputType.number,
                            decoration:
                                InputDecoration(labelText: "Enter Your Phone"),
                            validator: (val) {
                              if (val!.isEmpty) {
                                return ("Enter your phone number");
                              }
                            },
                            onSaved: (value) {
                              this.phone = value;
                            },
                          ),
                          TextFormField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration:
                                InputDecoration(labelText: "Enter Your Email"),
                            validator: (val) {
                              if (val!.isEmpty) {
                                return ("Enter your Name");
                              }
                            },
                            onSaved: (value) {
                              this.email = value;
                            },
                          ),
                          TextFormField(
                            controller: addressController,
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                                labelText: "Enter Your Address"),
                            validator: (val) {
                              if (val!.isEmpty) {
                                return ("Enter your Adsress");
                              }
                            },
                            onSaved: (value) {
                              this.address = value;
                            },
                          ),
                          TextFormField(
                            controller: passwordController,
                            obscureText: true,
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                                labelText: "Enter Your Password"),
                            validator: (val) {
                              if (val!.isEmpty) {
                                return ("Enter your password");
                              }
                            },
                            onSaved: (value) {
                              this.password = value;
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text("Gender"),
                              Row(
                                children: [
                                  Radio(
                                      value: 1,
                                      groupValue: _value,
                                      onChanged: (valuex) {
                                        setState(() {
                                          valuex = _value;
                                        });
                                      }),
                                  Text("Male")
                                ],
                              ),
                              Row(
                                children: [
                                  Radio(
                                      value: 0,
                                      groupValue: _value,
                                      onChanged: (valuex) {
                                        setState(() {
                                          valuex = _value;
                                        });
                                      }),
                                  Text("Female")
                                ],
                              )
                            ],
                          ),
                          RaisedButton(
                            onPressed: _sendFirebase,
                            child: Text(
                              "Submit",
                              style: TextStyle(color: Colors.white),
                            ),
                            color: Colors.blueGrey,
                          ),
                          // Column(
                          //   children: [
                          //     Text("Name is : ${this.name}"),
                          //     Text("Phone is : ${this.phone}"),
                          //     Text("Email is : ${this.email}"),
                          //     Text("Address is : ${this.address}"),
                          //     Text("Password is : ${this.password}"),
                          //   ],
                          // )
                        ],
                      )),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
