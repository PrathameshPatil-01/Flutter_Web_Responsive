import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:web_auth/data/comment_repository/models/comment.dart';
import 'package:web_auth/data/comment_repository/comment_repo.dart';

part 'get_comment_event.dart';
part 'get_comment_state.dart';

class GetCommentBloc extends Bloc<GetCommentEvent, GetCommentState> {
	final CommentRepository _commentRepository;

  GetCommentBloc({
		required CommentRepository commentRepository
	}) : _commentRepository = commentRepository,
		super(GetCommentInitial()) {
    on<GetComments>((event, emit) async {
			emit(GetCommentLoading());
      try {
				List<Comment> comments = await _commentRepository.getComment(event.postId);
        emit(GetCommentSuccess(comments));
      } catch (e) {
        emit(GetCommentFailure());
      }
    });
  }
}
