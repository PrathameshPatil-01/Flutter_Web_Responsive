part of 'post_count_bloc.dart';


sealed class PostCountState extends Equatable {
  const PostCountState();

  @override
  List<Object> get props => [];
}

final class PostCountInitial extends PostCountState {}

class PostCountLoadedState extends PostCountState {
  final int postCount;

  const PostCountLoadedState(this.postCount);

  @override
  List<Object> get props => [postCount];
}

class PostCountErrorState extends PostCountState {
  final String errorMessage;

  const PostCountErrorState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
