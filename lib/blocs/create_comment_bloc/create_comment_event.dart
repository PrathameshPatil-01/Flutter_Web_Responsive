part of 'create_comment_bloc.dart';

sealed class CreateCommentEvent extends Equatable {
  const CreateCommentEvent();

  @override
  List<Object> get props => [];
}

class CreateComment extends CreateCommentEvent {
  final Comment comment;
  final String postId;

  const CreateComment(this.postId, this.comment);
}
