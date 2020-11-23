class ApplicationUser {
  final String userId;
  final String email;
  final bool asArtisan;

  ApplicationUser({this.email, this.userId, this.asArtisan});

  Map<String,dynamic> toMap(){
    return {
      'userId': userId,
      'email': email,
      'asArtisan': asArtisan
    };
  }

  ApplicationUser.fromFirestore(Map<String,dynamic> firestore)
    : userId = firestore['userId'],
      asArtisan = firestore['asArtisan'],
      email = firestore['email'];
}