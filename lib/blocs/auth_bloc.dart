import 'package:rxdart/rxdart.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AuthBloc {
  final AuthService _service = AuthService();

  final _name = BehaviorSubject<String>();
  final _email = BehaviorSubject<String>();
  final _password = BehaviorSubject<String>();
  final _confirmPassword = BehaviorSubject<String>();
  final _gender = BehaviorSubject<String?>(); // optional
  final _level = BehaviorSubject<int?>();     // optional

  void setName(String v) => _name.add(v);
  void setEmail(String v) => _email.add(v);
  void setPassword(String v) => _password.add(v);
  void setConfirmPassword(String v) => _confirmPassword.add(v);
  void setGender(String? v) => _gender.add(v);
  void setLevel(int? v) => _level.add(v);

  Stream<bool> get nameValid =>
      _name.stream.map((n) => n.isNotEmpty);

  Stream<bool> get emailValid =>
      _email.stream.map((e) => e.contains("@"));

  Stream<bool> get passwordValid =>
      _password.stream.map((p) => p.length >= 8);

  Stream<bool> get confirmPasswordValid =>
      Rx.combineLatest2(_password, _confirmPassword,
          (p, c) => p == c && c.length >= 8);

  Stream<bool> get isValid => Rx.combineLatest4(
        nameValid,
        emailValid,
        passwordValid,
        confirmPasswordValid,
        (n, e, p, c) => n && e && p && c,
      );

  Future signup() async {
    final user = User(
      name: _name.value,
      email: _email.value,
      password: _password.value,
      gender: _gender.valueOrNull, // optional
      level: _level.valueOrNull,   // optional
    );

    return await _service.signup(user);
  }

  void dispose() {
    _name.close();
    _email.close();
    _password.close();
    _confirmPassword.close();
    _gender.close();
    _level.close();
  }
}