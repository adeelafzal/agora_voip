class Users {
  final String email;
  final String token;
  final String userId;

  Users({required this.email, required this.token, required this.userId});

  Users.fromJson(Map<String, Object?> json)
      : this(
          email: json['email']! as String,
          token: json['token']! as String,
          userId: json['userId']! as String,
        );
}
