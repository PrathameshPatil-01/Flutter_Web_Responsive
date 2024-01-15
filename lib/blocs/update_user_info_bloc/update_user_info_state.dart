part of 'update_user_info_bloc.dart';

abstract class UpdateUserInfoState extends Equatable {
  const UpdateUserInfoState();
  
  @override
  List<Object> get props => [];
}

class UploadPictureLoading extends UpdateUserInfoState {}

class UploadPictureFailure extends UpdateUserInfoState {}
class UploadPictureSuccess extends UpdateUserInfoState {
	final String userImage;

	const UploadPictureSuccess(this.userImage);

	@override
  List<Object> get props => [userImage];
}
