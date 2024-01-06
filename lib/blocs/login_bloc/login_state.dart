part of 'login_bloc.dart';

@immutable
abstract class LoginState extends Equatable {
	const LoginState();
  
  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginSuccess extends LoginState {}
class LoginFailure extends LoginState {
	final String? message;

	const LoginFailure({this.message});
}
class LoginProcess extends LoginState {}