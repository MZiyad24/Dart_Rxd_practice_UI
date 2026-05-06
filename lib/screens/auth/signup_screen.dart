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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [

            TextField(
              decoration: const InputDecoration(labelText: "Name"),
              onChanged: bloc.setName,
            ),

            Row(
              children: [
                Radio<String>(
                  value: "male",
                  groupValue: selectedGender,
                  onChanged: (val) {
                    setState(() => selectedGender = val);
                    bloc.setGender(val);
                  },
                ),
                const Text("Male"),

                Radio<String>(
                  value: "female",
                  groupValue: selectedGender,
                  onChanged: (val) {
                    setState(() => selectedGender = val);
                    bloc.setGender(val);
                  },
                ),
                const Text("Female"),
              ],
            ),

            TextField(
              decoration: const InputDecoration(labelText: "Email"),
              onChanged: bloc.setEmail,
            ),

            DropdownButtonFormField<int>(
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

            TextField(
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password"),
              onChanged: bloc.setPassword,
            ),

            TextField(
              obscureText: true,
              decoration: const InputDecoration(labelText: "Confirm Password"),
              onChanged: bloc.setConfirmPassword,
            ),

            const SizedBox(height: 20),

            StreamBuilder<bool>(
              stream: bloc.isValid,
              builder: (context, snapshot) {
                final isEnabled = snapshot.data ?? false;

                return ElevatedButton(
                  onPressed: isEnabled
                      ? () async {
                          final res = await bloc.signup();
                          print("the response is: $res");

                          if (!mounted) return;
                          if (res) {
                            Navigator.pushNamed(context, "/login");
                          }else{
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Signup Failed")),
                            );
                          }
                          
                        }
                      : null,
                  child: const Text("Sign Up"),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}