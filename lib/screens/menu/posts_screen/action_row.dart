import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:web_auth/blocs/create_comment_bloc/create_comment_bloc.dart';
import 'package:web_auth/blocs/likes/likes_bloc.dart';
import 'package:web_auth/blocs/my_user_bloc/my_user_bloc.dart';
import 'package:web_auth/data/comment_repository/models/comment.dart';
import 'package:web_auth/data/post_repository/models/post.dart';
import 'package:web_auth/data/user_repository/models/my_user.dart';

class ActionsRow extends StatefulWidget {
  Post item;
  ActionsRow({Key? key, required this.item}) : super(key: key);

  @override
  State<ActionsRow> createState() => _ActionsRowState();
}

class _ActionsRowState extends State<ActionsRow> {
  bool isLiked = false;
  bool showComments = false; // Track whether comments are visible
  int likesCount = 0;
  late String userId;

  @override
  void initState() {
    super.initState();
    final userstate = context.read<MyUserBloc>().state;
    userId = userstate.user!.id;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<LikesBloc, LikesState>(
          listener: (context, state) {
            if (state is LikesLoadedState) {
              setState(() {
                if (widget.item.postId == state.post.postId) {
                  widget.item = state.post;
                }
              });
            }
          },
        ),
        BlocListener<CreateCommentBloc, CreateCommentState>(
          listener: (context, state) {
            if (state is CreateCommentSuccess) {
              setState(() {
                if (widget.item.postId == state.post.postId) {
                  widget.item = state.post;
                }
              });
            }
          },
        ),
      ],
      child: Theme(
        data: Theme.of(context).copyWith(
          iconTheme: const IconThemeData(color: Colors.grey, size: 18),
          textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(Colors.grey),
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: () {
                    // Toggle the comments section visibility
                    setState(() {
                      showComments = !showComments;
                    });
                  },
                  icon: const Icon(Icons.mode_comment_outlined),
                  label: Text(widget.item.comments.isEmpty
                      ? ''
                      : widget.item.comments.length.toString()),
                ),
                TextButton.icon(
                  onPressed: () {
                    context
                        .read<LikesBloc>()
                        .add(GetLikesEvent(widget.item.postId, userId));
                  },
                  icon: widget.item.likes.contains(userId)
                      ? const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )
                      : const Icon(Icons.favorite_border),
                  label: Text(widget.item.likes.length.toString()),
                ),
                IconButton(
                  icon: const Icon(CupertinoIcons.share_up),
                  onPressed: () {},
                ),
              ],
            ),
            if (showComments) ...[
              // Display the comments section if showComments is true
              _CommentsSection(item: widget.item),
            ],
          ],
        ),
      ),
    );
  }
}

class _CommentsSection extends StatefulWidget {
  final Post item;

  const _CommentsSection({Key? key, required this.item}) : super(key: key);

  @override
  _CommentsSectionState createState() => _CommentsSectionState();
}

class _CommentsSectionState extends State<_CommentsSection> {
  late Comment comment;
  final TextEditingController _commentController = TextEditingController();
  MyUser? user;

  @override
  void initState() {
    super.initState();
    comment = Comment.empty;
    final userstate = context.read<MyUserBloc>().state;
    user = userstate.user!;
    comment.myUser = user!;
  }

  String formatTimeDifference(DateTime creationTime) {
    final now = DateTime.now();
    final difference = now.difference(creationTime);

    if (difference.inSeconds < 60) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hrs';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else {
      return DateFormat('yyyy-MM-dd').format(creationTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 5.0),
        _buildCommentInput(),
        const SizedBox(height: 5.0),
        _buildExistingComments(),
      ],
    );
  }

  Widget _buildExistingComments() {
    return Container(
      constraints: const BoxConstraints(maxHeight: 200),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widget.item.comments.map((comment) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Circular Avatar
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: comment['myUser']['picture'] != ''
                            ? NetworkImage(comment['myUser']['picture']!)
                            : const NetworkImage(
                                "https://cdn3.iconfinder.com/data/icons/feather-5/24/user-512.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  const SizedBox(width: 8.0),
                  // Comment Box
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[
                            200], // Slight grey background for comment box
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                  child: RichText(
                                overflow: TextOverflow.ellipsis,
                                text: TextSpan(children: [
                                  TextSpan(
                                    text: comment['myUser']['firstName'],
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ]),
                              )),
                              Text(
                                  formatTimeDifference(
                                      comment['createdAt'].toDate()),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: Colors.grey,
                                  )),
                            ],
                          ),
                          const SizedBox(height: 4.0),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    color: Colors
                                        .white, // White background for comment text
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Text(
                                    comment['commentText'],
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildCommentInput() {
    return Row(
      children: [
        // Circular Avatar
        CircleAvatar(
          radius: 16,
          backgroundImage: NetworkImage(user!.picture!),
        ),
        const SizedBox(width: 8.0), // Adjust spacing as needed

        // Expanded TextField
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _commentController,
              decoration: const InputDecoration(
                hintText: 'Add a comment...',
              ),
            ),
          ),
        ),

        // Add Emoji IconButton
        IconButton(
          icon: const Icon(Icons.emoji_emotions),
          onPressed: () {
            // Add emoji functionality
          },
        ),

        // Add Media Files IconButton
        IconButton(
          icon: const Icon(Icons.attach_file),
          onPressed: () {
            // Add media files functionality
          },
        ),

        // Send Comment IconButton
        IconButton(
          icon: const Icon(Icons.send),
          onPressed: () {
            _postComment();
          },
        ),
      ],
    );
  }

  void _postComment() {
    final newComment = _commentController.text;
    if (newComment.isNotEmpty) {
      setState(() {
        comment.commentText = newComment;
        context
            .read<CreateCommentBloc>()
            .add(CreateComment(widget.item.postId, comment));
        _commentController.clear();
      });
    }
  }
}
