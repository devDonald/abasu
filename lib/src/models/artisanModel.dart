// class UserModel {
//   final String userId;
//   final String email, address, gender, phone, city, state, fullName, country, skill;
//   final bool asArtisan, isVerified;
//   final int  experience,profiling;
//
//   UserModel({this.email, this.userId, this.asArtisan, this.address, this.gender, this.phone,
//     this.city, this.state, this.fullName, this.country, this.skill, this.experience,
//     this.isVerified, this.profiling});
//
//   Map<String,dynamic> toMap(){
//     return {
//       'userId': userId,
//       'email': email,
//       'asArtisan': asArtisan,
//       'address':address,
//       'gender':gender,
//       'phone':phone,
//       'city':city,
//       'state':state,
//       'fullName':fullName,
//       'country':country,
//       'skill':skill,
//       'experience':experience,
//       'isVerified':isVerified,
//       'profiling':profiling,
//     };
//   }
//
//   UserModel.fromFirestore(Map<String,dynamic> firestore)
//       : userId = firestore['userId'],
//         asArtisan = firestore['asArtisan'],
//         address = firestore['address'],
//         gender = firestore['gender'],
//         phone = firestore['phone'],
//         city = firestore['city'],
//         state = firestore['state'],
//         fullName = firestore['fullName'],
//         country=firestore['country'],
//         skill = firestore['skill'],
//         experience = firestore['experience'],
//         isVerified = firestore['isVerified'],
//         profiling = firestore['profiling'],
//         email = firestore['email'];
//
//
// }