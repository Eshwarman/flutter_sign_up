import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; 


void main() {
  runApp(LoginPage()); 
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final String url = 'http://devapiv3.dealsdray.com/api/v2/user/device/add'; 

  final _formKey = GlobalKey<FormState>(); 
  bool _obscureText = true;

  
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _referralCodeController = TextEditingController();

  

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Future<http.Response> signUp(String email, String password, String referralCode) async {
    
    final body = {
      'email': email,
      'password': password,
      'referralCode': referralCode,
    };

    final response = await http.post(url as Uri, body: jsonEncode(body));
    return response;
  }

  void _handleSignUp() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text;
      final password = _passwordController.text;
      final referralCode = _referralCodeController.text;
          
            final body = {
      'email': email,
      'password': password,
      'referralCode': referralCode,
    };

    final response = await http.post(url as Uri, body: jsonEncode(body));

      try {
        final response = await signUp(email, password, referralCode);
        if (response.statusCode == 200) {
         
          print('Signup successful!');
        } else {
          
          print('Signup failed with status: ${response.statusCode}');
         
        }
      } catch (error) {
        
        print('Error during signup: $error');
       
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(width: 10.0),
              Icon(Icons.arrow_forward_ios, color: Colors.white),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Text(
                  'Welcome to MyApp!',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    hintText: 'Email',
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                   
                    return null;
                  },
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    hintText: 'Create Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: _togglePasswordVisibility,
                    ),
                  ),
                  obscureText: _obscureText,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    
                    return null;
                  },
                ),
                SizedBox(height: 20.0),
                TextField(
                  controller: _referralCodeController,
                   decoration: const InputDecoration(
                    hintText: 'Referral Code (Optional)',
                  ),
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: _handleSignUp,
                  child: Text('Sign Up'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
