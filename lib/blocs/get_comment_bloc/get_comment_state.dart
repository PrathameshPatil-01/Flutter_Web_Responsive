part of 'get_comment_bloc.dart';

sealed class GetCommentState extends Equatable {
  const GetCommentState();
  
  @override
  List<Object> get props => [];
}

final class GetCommentInitial extends GetCommentState {}

final class GetCommentFailure extends GetCommentState {}
final class GetCommentLoading extends GetCommentState {}
final class GetCommentSuccess extends GetCommentState {
	final List<Comment> comments;

	const GetCommentSuccess(this.comments);
}