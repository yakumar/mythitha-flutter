// import 'package:equatable/equatable.dart';

// class MyUser extends Equatable {
//   final String userId;
//   final String userName;
//   final String phoneNum;

//   MyUser({this.userId, this.userName, this.phoneNum});

//   @override
//   // instead of doing super for equatable, we are doing this.
//   List<Object> get props => [this.userId, this.userName, this.phoneNum];

//   /// toEntity - This method converts the User POJO to an entity object
//   /// The entity class has further methods to convert the POJO to datastore related objects
//   // factory User.toJson() {
//   //   return User(userId: userId, userName: this.userName, phoneNum: this.phoneNum);
//   // }

//   /// fromEntity - This method creates the POJO back from the entity object
//   factory MyUser.fromJson(MyUser entity) {
//     return MyUser(
//         userId: entity.userId,
//         userName: entity.userName,
//         phoneNum: entity.phoneNum);
//   }
// }
