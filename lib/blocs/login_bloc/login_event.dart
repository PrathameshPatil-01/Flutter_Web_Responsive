part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginRequired extends LoginEvent{
	final String email;
	final String password;

	const LoginRequired(this.email, this.password);
}

class SignOutRequired extends LoginEvent{

	const SignOutRequired();
}