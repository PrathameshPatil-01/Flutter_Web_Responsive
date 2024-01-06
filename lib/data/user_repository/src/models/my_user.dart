import 'package:equatable/equatable.dart';

import '../entities/entities.dart';

class MyUser extends Equatable {
  final String id;
  final String email;
  final String userName;
  final String firstName;
  final String lastName;
  final String country;
  final String? state;
  final String? city;

  String? picture;
  MyUser({
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

  /// Empty user which represents an unauthenticated user.
  static final empty = MyUser(
      id: '',
      email: '',
      userName: '',
      firstName: '',
      lastName: '',
      country: '',
      state: '',
      city: '',
      picture: '');

  // Modify MyUser parameters

  MyUser copyWith({
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
    return MyUser(
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

  /// Convenience getter to determine whether the current user is empty.
  bool get isEmpty => this == MyUser.empty;

  /// Convenience getter to determine whether the current user is not empty.
  bool get isNotEmpty => this != MyUser.empty;

  MyUserEntity toEntity() {
    return MyUserEntity(
      id: id,
      email: email,
      userName: userName,
      firstName: firstName,
      lastName: lastName ,
      country: country,
      state: state,
      city: city,
      picture: picture,
    );
  }

  static MyUser fromEntity(MyUserEntity entity) {
    return MyUser(
      id: entity.id,
      email: entity.email,
      userName: entity.userName,
      firstName: entity.firstName,
      lastName: entity.lastName ,
      country: entity.country,
      state: entity.state,
      city: entity.city,
      picture: entity.picture,
    );
  }



  @override
  List<Object?> get props => [
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
