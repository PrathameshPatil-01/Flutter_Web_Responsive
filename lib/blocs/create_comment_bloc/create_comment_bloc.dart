import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:web_auth/data/comment_repository/models/comment.dart';
import 'package:web_auth/data/comment_repository/comment_repo.dart';
import 'package:web_auth/data/post_repository/models/post.dart';

part 'create_comment_event.dart';
part 'create_comment_state.dart';

class CreateCommentBloc extends Bloc<CreateCommentEvent, CreateCommentState> {
	final CommentRepository _commentRepository;

  CreateCommentBloc({
		required CommentRepository commentRepository
	}) : _commentRepository = commentRepository,
		super(CreateCommentInitial()) {
    on<CreateComment>((event, emit) async {
			emit(CreateCommentLoading());
      try {
				Post post = await _commentRepository.createComment(event.postId, event.comment);
        emit(CreateCommentSuccess(post));
      } catch (e) {
        emit(CreateCommentFailure());
      }
    });
  }
}
