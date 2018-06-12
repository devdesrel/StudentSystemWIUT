class LoginModel {
  final String username;
  final String password;

  LoginModel({this.username, this.password});

  factory LoginModel.toJson(Map<String, dynamic> json) {
    return LoginModel(username: json['Username'], password: json['Password']);
  }
}
