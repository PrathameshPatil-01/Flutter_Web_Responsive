part of 'likes_bloc.dart';

sealed class LikesEvent extends Equatable {
  const LikesEvent();

  @override
  List<Object> get props => [];
}

class GetLikesEvent extends LikesEvent {
  final String userId;
  final String postId;

  const GetLikesEvent(this.postId, this.userId);

  @override
  List<Object> get props => [postId, userId];
}
