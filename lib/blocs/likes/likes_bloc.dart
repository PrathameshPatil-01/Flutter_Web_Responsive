import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:web_auth/data/post_repository/entities/post_entity.dart';
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
        // Call the likePost function from the repository to handle the like event
        final updatedLikes =
            await _postRepository.likePost(event.postId, event.userId);

        // Emit the updated state with the new list of likes
        emit(LikesLoadedState(updatedLikes));
      } catch (e) {
        // Handle errors and emit an error state
        emit(LikesErrorState('Error liking post: $e'));
      }
    });
  }
}








// // Like BLoC
// class LikeBloc extends Bloc<LikeEvent, LikeState> {
//   final UserRepository userRepository;

//   LikeBloc(this.userRepository) : super(LikeInitialState());

//   @override
//   Stream<LikeState> mapEventToState(LikeEvent event) async* {
//     if (event is GetLikeEvent) {
//       yield* _mapGetLikeEventToState(event);
//     }
//   }

//   Stream<LikeState> _mapGetLikeEventToState(GetLikeEvent event) async* {
//     try {
//       // Fetch user data based on user ID
//       User user = await userRepository.getUserById(event.userId);

//       yield LikeLoadedState(user);
//     } catch (e) {
//       yield LikeErrorState('Error fetching user: $e');
//     }
//   }
// }
