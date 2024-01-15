import 'package:equatable/equatable.dart';

class MyUserEntity extends Equatable {
  final String id;
  final String email;
  final String userName;
  final String firstName;
  final String lastName;
  final String country;
  final String? state;
  final String? city;
  final String? picture;

  const MyUserEntity({
    required this.id,
    required this.email,
    required this.userName,
    required this.firstName,
    required this.lastName,
    required this.country,
    this.state,
    this.city,
    this.picture,
  });

  MyUserEntity copyWith({
    String? id,
    String? email,
    String? userName,
    String? firstName,
    String? lastName,
    String? country,
    String? state,
    String? city,
    String? picture,
  }) {
    return MyUserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      userName: userName ?? this.userName,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      country: country ?? this.country,
      state: state ?? this.state,
      city: city ?? this.city,
      picture: picture ?? this.picture,
    );
  }

  Map<String, Object?> toDocument() {
    var map = {
      'id': id,
      'email': email,
      'userName': userName,
      'firstName': firstName,
      'lastName': lastName,
      'country': country,
      'state': state,
      'city': city,
      'picture': picture,
    };
    return map;
  }

  static MyUserEntity fromDocument(Map<String, dynamic> doc) {
    return MyUserEntity(
      id: doc['id'] as String,
      email: doc['email'] as String,
      userName: doc['userName'] as String,
      firstName: doc['firstName'] as String,
      lastName: doc['lastName'] as String,
      country: doc['country'] as String,
      state: doc['state'] as String,
      city: doc['city'] as String,
      picture: doc['picture'] as String,
    );
  }

  @override
  List<Object?> get props {
    return [
      id,
      email,
      userName,
      firstName,
      lastName,
      country,
      state,
      city,
      picture,
    ];
  }

  @override
  String toString() {
    return '''MyUserEntity(id: $id, email: $email, userName: $userName, firstName: $firstName, lastName: $lastName, country: $country, state: $state, city: $city, picture: $picture)''';
  }
}
