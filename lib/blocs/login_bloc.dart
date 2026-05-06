import '../services/auth_service.dart';
import 'package:rxdart/rxdart.dart';
import '../services/storage_service.dart';


class LoginBloc {
  final AuthService _service = AuthService();
  final AuthStorage = StorageService();

  final _email = BehaviorSubject<String>();
  final _password = BehaviorSubject<String>();


  Stream<bool> get isValid => Rx.combineLatest2(
        _email,
        _password,
        (e, p) => e.contains("@") && p.length >= 8,
      );

  void setEmail(String value) => _email.add(value);
  void setPassword(String value) => _password.add(value);

  Future<bool> login() async {
    final res = await _service.login(email: _email.value, password: _password.value);

    if (res["idToken"] != null) {
      await AuthStorage.saveToken(res["idToken"]);
      return true;
    }
    return false;
  }

  void dispose() {
    _email.close();
    _password.close();
  }
}