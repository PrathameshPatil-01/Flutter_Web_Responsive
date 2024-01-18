part of 'likes_bloc.dart';

sealed class LikesState extends Equatable {
  const LikesState();

  @override
  List<Object> get props => [];
}

final class LikesInitial extends LikesState {}

class LikesLoadedState extends LikesState {
  final Post post;

  const LikesLoadedState(this.post);

  @override
  List<Object> get props => [post];
}

class LikesErrorState extends LikesState {
  final String errorMessage;

  const LikesErrorState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
