import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:web_auth/data/post_repository/post_repo.dart';

part 'post_count_event.dart';
part 'post_count_state.dart';


class PostCountBloc extends Bloc<PostCountEvent, PostCountState> {
  final PostRepository _postRepository;

  PostCountBloc({required PostRepository postRepository})
      : _postRepository = postRepository,
        super(PostCountInitial()) {
    on<GetPostCount>((event, emit) async {
      try {
        final postCount =
            await _postRepository.getPostCountForUser(event.userId);

        emit(PostCountLoadedState(postCount));
      } catch (e) {
        emit(PostCountErrorState('Error liking post: $e'));
      }
    });
  }
}