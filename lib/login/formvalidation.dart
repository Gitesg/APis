import 'package:flutter/material.dart';

import '../main.dart';



class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController gender = TextEditingController();
  TextEditingController country = TextEditingController();
  TextEditingController city = TextEditingController();

  void _acceptForm() {
    String enteredName = name.text;
    String enteredEmail = email.text;
    String enteredPhone = phone.text;

    // Navigate to the next page and pass the form values as arguments
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Home(
          name: enteredName,
          email: enteredEmail,
          phone: enteredPhone,
        ),
      ),
    );

    // Clear the form fields
    name.clear();
    email.clear();
    phone.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),
            TextFormField(
              controller: name,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: email,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: phone,
              decoration: InputDecoration(
                labelText: 'Phone',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: city,
              decoration: InputDecoration(
                labelText: 'city',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: country,
              decoration: InputDecoration(
                labelText: 'country',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _acceptForm,
              child: Text('Accept'),
            ),
          ],
        ),
      ),
    );
  }
}
