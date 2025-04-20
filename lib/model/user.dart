class User {
  String? id;
  final String? uid;
  final String name;
  final String email;

  User({this.id, this.uid, required this.name, required this.email});

  factory User.fromFirestore(Map<String, dynamic> data, String documentId) {
    return User(
      id: documentId,
      uid: data['uid'],
      name: data['name'] ?? 'Unknown',
      email: data['email'] ?? 'Unknown',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
    };
  }
}
