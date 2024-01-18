import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universal_html/html.dart' as html;
import 'package:web_auth/data/post_repository/post_repo.dart';

part 'post_image_event.dart';
part 'post_image_state.dart';

class PostImageBloc extends Bloc<PostImageEvent, PostImageState> {
  final PostRepository _postRepository;

  PostImageBloc({required PostRepository postRepository})
      : _postRepository = postRepository,
        super(UploadPostImageInitial()) {
    on<UploadPostImage>((event, emit) async {
      emit(UploadPostImageLoading());
      try {
        String postImage = await _postRepository.uploadPostImage(
            event.file, event.postId, event.userId);
        emit(UploadPostImageSuccess(postImage));
      } catch (e) {
        emit(UploadPostImageFailure());
      }
    });
  }
}
