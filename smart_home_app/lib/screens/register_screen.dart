import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login_screen.dart';
import 'dashboard_screen.dart';
import '../providers/auth_provider.dart';


class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _loading = false;

  void _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _loading = true);

      try {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        bool success = await authProvider.register(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          username: _usernameController.text.trim(),
          phone: _phoneController.text.trim(),
        );

        setState(() => _loading = false);

        if (success) {
          print("✅ Registration succeeded");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => DashboardScreen()),
          );
        } else {
          print("❌ Registration failed - authProvider returned false");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Registration failed. Try again.')),
          );
        }
      } catch (e) {
        print("❌ Exception during registration: $e");
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Something went wrong.')),
        );
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        backgroundColor: Colors.black, // change AppBar background color
        title: Text("Register"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Username'),
                validator: (val) => val!.isEmpty ? 'Enter a username' : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (val) => val!.contains('@') ? null : 'Enter a valid email',
              ),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Phone Number'),
                validator: (val) => val!.isEmpty ? 'Enter phone number' : null,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (val) => val!.length < 6 ? 'Min 6 characters' : null,
              ),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(labelText: 'Confirm Password'),
                obscureText: true,
                validator: (val) => val != _passwordController.text ? 'Passwords do not match' : null,
              ),
              SizedBox(height: 20),
              _loading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                onPressed: _register,
                child: Text("Register"),
              ),
              TextButton(
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => LoginScreen()),
                ),
                child: Text("Already have an account? Login"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
