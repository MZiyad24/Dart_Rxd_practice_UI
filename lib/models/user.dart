class User {
  final String name;
  final String email;
  final String password;
  final String? gender;
  final int? level;

  User({
    required this.name,
    required this.email,
    required this.password,
    this.gender,
    this.level,
  });

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "password": password,
    "gender": gender,
    "level": level,
  };
}