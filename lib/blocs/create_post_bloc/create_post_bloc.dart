import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:web_auth/data/post_repository/models/post.dart';
import 'package:web_auth/data/post_repository/post_repo.dart';

part 'create_post_event.dart';
part 'create_post_state.dart';

class CreatePostBloc extends Bloc<CreatePostEvent, CreatePostState> {
	final PostRepository _postRepository;

  CreatePostBloc({
		required PostRepository postRepository
	}) : _postRepository = postRepository,
		super(CreatePostInitial()) {
    on<CreatePost>((event, emit) async {
			emit(CreatePostLoading());
      try {
				Post post = await _postRepository.createPost(event.post);
        emit(CreatePostSuccess(post));
      } catch (e) {
        emit(CreatePostFailure());
      }
    });
  }
}
