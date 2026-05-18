import 'package:flutter/material.dart';
import '../../blocs/auth_bloc.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final bloc = AuthBloc();

  String? selectedGender;
  int? selectedLevel;

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
          "Sign Up",
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
                  Icons.person_add_alt_1,
                  size: 80,
                  color: Colors.orange.shade700,
                ),

                const SizedBox(height: 20),

                /// NAME
                TextField(
                  decoration: InputDecoration(
                    labelText: "Name",
                    prefixIcon: Icon(
                      Icons.person,
                      color: Colors.orange.shade700,
                    ),
                    enabledBorder: _border(Colors.orange.shade400),
                    focusedBorder: _border(Colors.orange.shade800),
                    labelStyle: TextStyle(color: Colors.orange.shade700),
                  ),
                  onChanged: bloc.setName,
                ),

                const SizedBox(height: 15),

                /// GENDER
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Radio<String>(
                      value: "male",
                      groupValue: selectedGender,
                      activeColor: Colors.orange.shade700,
                      onChanged: (val) {
                        setState(() => selectedGender = val);
                        bloc.setGender(val);
                      },
                    ),
                    const Text("Male"),

                    const SizedBox(width: 20),

                    Radio<String>(
                      value: "female",
                      groupValue: selectedGender,
                      activeColor: Colors.orange.shade700,
                      onChanged: (val) {
                        setState(() => selectedGender = val);
                        bloc.setGender(val);
                      },
                    ),
                    const Text("Female"),
                  ],
                ),

                const SizedBox(height: 10),

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

                /// LEVEL
                DropdownButtonFormField<int>(
                  decoration: InputDecoration(
                    enabledBorder: _border(Colors.orange.shade400),
                    focusedBorder: _border(Colors.orange.shade800),
                  ),
                  hint: const Text("Select Level"),
                  value: selectedLevel,
                  items: [1, 2, 3, 4].map((level) {
                    return DropdownMenuItem(
                      value: level,
                      child: Text("Level $level"),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() => selectedLevel = val);
                    bloc.setLevel(val);
                  },
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

                const SizedBox(height: 15),

                /// CONFIRM PASSWORD
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Confirm Password",
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: Colors.orange.shade700,
                    ),
                    enabledBorder: _border(Colors.orange.shade400),
                    focusedBorder: _border(Colors.orange.shade800),
                    labelStyle: TextStyle(color: Colors.orange.shade700),
                  ),
                  onChanged: bloc.setConfirmPassword,
                ),

                const SizedBox(height: 20),

                /// SIGNUP BUTTON
                StreamBuilder<bool>(
                  stream: bloc.isValid,
                  builder: (context, snapshot) {
                    final isEnabled = snapshot.data ?? false;

                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isEnabled
                            ? () async {
                                final res = await bloc.signup();

                                if (!mounted) return;

                                if(res != "success") {
                                  print("the response is: ${res}");
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Signup Failed: ${res}"),
                                    ),
                                  );
                                  return;
                                }

                                else {
                                  Navigator.pushNamed(context, "/login");
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
                          "Sign Up",
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

                /// LOGIN LINK
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/login");
                  },
                  child: Text(
                    "Already have an account? Login",
                    style: TextStyle(
                      color: Colors.orange.shade500,
                      fontWeight: FontWeight.w500,
                    ),
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