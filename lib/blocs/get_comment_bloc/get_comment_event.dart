part of 'get_comment_bloc.dart';

sealed class GetCommentEvent extends Equatable {
  const GetCommentEvent();

  @override
  List<Object> get props => [];
}

class GetComments extends GetCommentEvent {
  final String postId;

  const GetComments(this.postId);

  @override
  List<Object> get props => [postId];
}