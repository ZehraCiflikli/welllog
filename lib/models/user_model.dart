class AppUser {
  final String uid;
  final String fullName;
  final String email;
  final int age;
  final int height;
  final int weight;

  AppUser({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.age,
    required this.height,
    required this.weight,
  });

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "fullName": fullName,
      "email": email,
      "age": age,
      "height": height,
      "weight": weight,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map["uid"],
      fullName: map["fullName"],
      email: map["email"],
      age: map["age"],
      height: map["height"],
      weight: map["weight"],
    );
  }
}
