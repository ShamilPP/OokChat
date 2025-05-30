class User {
  String? id;
  final String? uid;
  final String? profilePhoto;
  final String name;
  final String email;
  final DateTime? createdTime;
  final DateTime? lastSeenTime;

  User({this.id, this.uid, required this.profilePhoto, required this.name, required this.email, this.createdTime, this.lastSeenTime});

  factory User.fromFirestore(Map<String, dynamic> data, String documentId) {
    return User(
      id: documentId,
      uid: data['uid'],
      profilePhoto: data['profilePhoto'],
      name: data['name'] ?? 'Unknown',
      email: data['email'] ?? 'Unknown',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'profilePhoto': profilePhoto,
      'name': name,
      'email': email,
      'createdTime': createdTime,
      'lastSeenTime': lastSeenTime,
    };
  }
}
