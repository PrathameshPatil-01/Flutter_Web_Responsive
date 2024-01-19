part of 'post_count_bloc.dart';

sealed class PostCountEvent extends Equatable {
  const PostCountEvent();

  @override
  List<Object> get props => [];
}

class GetPostCount extends PostCountEvent {
  final String userId;

  const GetPostCount(this.userId);

  @override
  List<Object> get props => [userId];
}
