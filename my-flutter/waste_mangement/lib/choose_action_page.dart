import 'package:flutter/material.dart';
import 'package:waste_mangement/controller/auth.dart';
import 'package:waste_mangement/home.dart';

class ChooseActionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: Text("Sign Up"),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SignUpForm()));
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text("Log In"),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginForm()));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SignUpForm extends StatelessWidget {
  // This widget will contain the sign up form
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sign Up")),
      body: FormWidget(isSignUp: true),
    );
  }
}

class LoginForm extends StatelessWidget {
  // This widget will contain the login form
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Log In")),
      body: FormWidget(isSignUp: false),
    );
  }
}

class FormWidget extends StatefulWidget {
  final bool isSignUp;

  const FormWidget({Key? key, required this.isSignUp}) : super(key: key);

  @override
  _FormWidgetState createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (widget.isSignUp) {
      // Call sign up method from AuthController
      final authController = AuthController();
      await authController.signUp(
          _emailController.text,
          _passwordController.text,
          () => Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (_) => const MyHomePage(title: 'Home'))));
      // Replace '/home' with your home route
    } else {
      // Call login method (not implemented in this snippet)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email'),
            keyboardType: TextInputType.emailAddress,
          ),
          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            child: Text(widget.isSignUp ? 'Sign Up' : 'Log In'),
            onPressed: _submitForm,
          ),
        ],
      ),
    );
  }
}
