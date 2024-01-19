import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:web_auth/data/post_repository/models/post.dart';
import 'package:web_auth/data/post_repository/post_repo.dart';

part 'likes_event.dart';
part 'likes_state.dart';

class LikesBloc extends Bloc<LikesEvent, LikesState> {
  final PostRepository _postRepository;

  LikesBloc({required PostRepository postRepository})
      : _postRepository = postRepository,
        super(LikesInitial()) {
    on<GetLikesEvent>((event, emit) async {
      try {
        final updatedLikes =
            await _postRepository.likePost(event.postId, event.userId);

        emit(LikesLoadedState(updatedLikes));
      } catch (e) {
        emit(LikesErrorState('Error liking post: $e'));
      }
    });
  }
}
