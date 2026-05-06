import 'package:flutter/material.dart';
import '../../blocs/login_bloc.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final bloc = LoginBloc();

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            TextField(
              decoration: const InputDecoration(labelText: "Email"),
              onChanged: bloc.setEmail,
            ),

            TextField(
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password"),
              onChanged: bloc.setPassword,
            ),

            const SizedBox(height: 20),

            const SizedBox(height: 10),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/signup'),
                child: const Text("Don't have an account? Sign up"),

              ),

            StreamBuilder<bool>(
              stream: bloc.isValid,
              builder: (context, snapshot) {
                final isEnabled = snapshot.data ?? false;

                return ElevatedButton(
                  onPressed: isEnabled
                      ? () async {
                          final res = await bloc.login();
                          print("the response is: $res");

                          if (res) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Login Success")),
                            );
                            Navigator.pushReplacementNamed(context, "/home");
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Login Failed")),
                            );
                          }
                          
                        }
                      : null,
                  child: const Text("Login"),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}