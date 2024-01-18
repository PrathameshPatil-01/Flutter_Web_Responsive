import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:web_auth/blocs/get_post_bloc/get_post_bloc.dart';
import 'package:web_auth/blocs/likes/likes_bloc.dart';
import 'package:web_auth/blocs/my_user_bloc/my_user_bloc.dart';
import 'package:web_auth/blocs/update_user_info_bloc/update_user_info_bloc.dart';
import 'package:web_auth/data/post_repository/models/post.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocBuilder<GetPostBloc, GetPostState>(
        builder: (context, state) {
          if (state is GetPostSuccess) {
            return Container(
              constraints: const BoxConstraints(maxWidth: 400),
              child: ListView.separated(
                itemCount: state.posts.length,
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider();
                },
                itemBuilder: (BuildContext context, int i) {
                  final item = state.posts[i];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Builder(builder: (context) {
                          final userstate = context.watch<MyUserBloc>().state;
                          final imagestate =
                              context.watch<UpdateUserInfoBloc>().state;
                          bool isLoading = imagestate is UploadPictureLoading;
                          return item.myUser.id == userstate.user!.id
                              ? (isLoading
                                  ? const CircularProgressIndicator()
                                  : _AvatarImage(userstate.user!.picture!))
                              : _AvatarImage(item.myUser.picture!);
                        }),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
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
                                        text: item.myUser.firstName,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.black),
                                      ),
                                      TextSpan(
                                        text: " @${item.myUser.userName}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                    ]),
                                  )),
                                  Text(
                                      DateFormat('yyyy-MM-dd')
                                          .format(item.createAt),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall),
                                  const Padding(
                                    padding: EdgeInsets.only(left: 8.0),
                                    child: Icon(Icons.more_horiz),
                                  )
                                ],
                              ),
                              if (item.content != null) Text(item.content!),
                              if (item.imageUrl != "")
                                Container(
                                  height: 200,
                                  margin: const EdgeInsets.only(top: 8.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(item.imageUrl!),
                                      )),
                                ),
                              _ActionsRow(item: item)
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          } else if (state is GetPostLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return const Center(
              child: Text("An error has occurred"),
            );
          }
        },
      ),
    );
  }
}

class _AvatarImage extends StatelessWidget {
  final String url;
  const _AvatarImage(this.url, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey,
        shape: BoxShape.circle,
        image: DecorationImage(
          image: NetworkImage(url),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _ActionsRow extends StatefulWidget {
  Post item;
  _ActionsRow({Key? key, required this.item}) : super(key: key);

  @override
  State<_ActionsRow> createState() => _ActionsRowState();
}

class _ActionsRowState extends State<_ActionsRow> {
  bool isLiked = false;
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
    return BlocListener<LikesBloc, LikesState>(
      listener: (context, state) {
        if (state is LikesLoadedState) {
          setState(() {
            if (widget.item.postId == state.post.postId) {
              widget.item = state.post;
            }
          });
        }
      },
      child: Theme(
        data: Theme.of(context).copyWith(
            iconTheme: const IconThemeData(color: Colors.grey, size: 18),
            textButtonTheme: TextButtonThemeData(
                style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(Colors.grey),
            ))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.mode_comment_outlined),
              label: Text(widget.item.comments.isEmpty
                  ? ''
                  : widget.item.comments.toString()),
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
            )
          ],
        ),
      ),
    );
  }
}