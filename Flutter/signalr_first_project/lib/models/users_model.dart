class User {
  String connectionId;
  String userName;

  User({required this.connectionId, required this.userName});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      connectionId: json['connectionId'],
      userName: json['userName'],
    );
  }
}
