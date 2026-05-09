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

  OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: color, width: 1.5),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.orange.shade700,
        centerTitle: true,

        title: const Text(
          "Login",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),

      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),

              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),

            child: Column(
              children: [

                Icon(
                  Icons.lock_outline,
                  size: 80,
                  color: Colors.orange.shade700,
                ),

                const SizedBox(height: 20),

                /// EMAIL
                TextField(
                  decoration: InputDecoration(
                    labelText: "Email",
                    prefixIcon: Icon(
                      Icons.email,
                      color: Colors.orange.shade700,
                    ),

                    enabledBorder: _border(Colors.orange.shade400),
                    focusedBorder: _border(Colors.orange.shade800),

                    labelStyle: TextStyle(color: Colors.orange.shade700),
                  ),
                  onChanged: bloc.setEmail,
                ),

                const SizedBox(height: 15),

                /// PASSWORD
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Colors.orange.shade700,
                    ),

                    enabledBorder: _border(Colors.orange.shade400),
                    focusedBorder: _border(Colors.orange.shade800),

                    labelStyle: TextStyle(color: Colors.orange.shade700),
                  ),
                  onChanged: bloc.setPassword,
                ),

                const SizedBox(height: 20),

                StreamBuilder<bool>(
                  stream: bloc.isValid,
                  builder: (context, snapshot) {
                    final isEnabled = snapshot.data ?? false;

                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isEnabled
                            ? () async {
                                final res = await bloc.login();

                                if (res) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Login Success"),
                                    ),
                                  );

                                  Navigator.pushReplacementNamed(
                                    context,
                                    "/place",
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Login Failed"),
                                    ),
                                  );
                                }
                              }
                            : null,

                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange.shade700,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),

                        child: const Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 10),

                TextButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, '/signup'),
                  child: const Text(
                    "Don't have an account? Sign up",
                    style: TextStyle(color: Colors.orange),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}