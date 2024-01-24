import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:web_auth/blocs/create_post_bloc/create_post_bloc.dart';
import 'package:web_auth/blocs/get_post_bloc/get_post_bloc.dart';
import 'package:web_auth/blocs/my_user_bloc/my_user_bloc.dart';
import 'package:web_auth/blocs/update_user_info_bloc/update_user_info_bloc.dart';
import 'package:web_auth/screens/menu/posts_screen/action_row.dart';
import 'package:web_auth/screens/menu/posts_screen/profile_card.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final ScrollController _controller = ScrollController();

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
    setState(() {
      context.read<GetPostBloc>().add(GetPosts());
    });
    final width = MediaQuery.of(context).size.width;
    final bool isLargeScreen = width > 800;

    return Scrollbar(
      controller: _controller,
      child: Row(
        children: [
          if (isLargeScreen) Expanded(flex: 1, child: Container()),
          if (isLargeScreen)
            const Expanded(
              flex: 4,
              child: ProfileCard(),
            ),
          Expanded(
            flex: 9,
            child: Container(
              margin: const EdgeInsets.all(2),
              child: _buildBody(formatTimeDifference),
            ),
          ),
          if (isLargeScreen)
            Expanded(
              flex: 4,
              child: Container(
                margin: const EdgeInsets.all(15),
                child: const Text(''),
              ),
            ),
          if (isLargeScreen) Expanded(flex: 1, child: Container()),
        ],
      ),
    );
  }

  Widget _buildBody(formatTimeDifference) {
    return BlocListener<CreatePostBloc, CreatePostState>(
      listener: (context, state) {
        if (state is DeletePostSuccess) {
          setState(() {});
          Navigator.of(context).pop();
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Post Deleted'),
                content: const Text('The post has been successfully deleted.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        } else if (state is DeletePostLoading) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return const AlertDialog(
                title: Text('Deleting Post'),
                content: LinearProgressIndicator(),
              );
            },
          );
        }
      },
      child: Center(
        child: BlocBuilder<GetPostBloc, GetPostState>(
          builder: (context, state) {
            if (state is GetPostSuccess) {
              return Container(
                constraints: const BoxConstraints(maxWidth: 400),
                child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context)
                        .copyWith(scrollbars: false),
                    child: SingleChildScrollView(
                      controller: _controller,
                      child: Column(
                        children: List.generate(
                          state.posts.length,
                          (int i) {
                            final item = state.posts[i];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Builder(builder: (context) {
                                    final userstate =
                                        context.watch<MyUserBloc>().state;
                                    final imagestate = context
                                        .watch<UpdateUserInfoBloc>()
                                        .state;
                                    bool isLoading =
                                        imagestate is UploadPictureLoading;
                                    return item.myUser.id == userstate.user!.id
                                        ? (isLoading
                                            ? const CircularProgressIndicator()
                                            : _AvatarImage(
                                                userstate.user!.picture!))
                                        : item.myUser.picture != ''
                                            ? _AvatarImage(item.myUser.picture!)
                                            : const _AvatarImage(
                                                "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1470&q=80");
                                  }),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: RichText(
                                                overflow: TextOverflow.ellipsis,
                                                text: TextSpan(children: [
                                                  TextSpan(
                                                    text: item.myUser.firstName,
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        " @${item.myUser.userName}",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleMedium,
                                                  ),
                                                ]),
                                              ),
                                            ),
                                            Text(
                                              formatTimeDifference(
                                                  item.createdAt),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            PopupMenuButton<String>(
                                              offset: const Offset(0,
                                                  40), // Adjust the Y-offset to position the menu below the button
                                              itemBuilder:
                                                  (BuildContext context) =>
                                                      <PopupMenuEntry<String>>[
                                                const PopupMenuItem<String>(
                                                  value: 'delete',
                                                  child: ListTile(
                                                    contentPadding: EdgeInsets
                                                        .zero, // Remove ListTile's default padding
                                                    leading: Icon(Icons.delete),
                                                    title: Text('Delete Post',
                                                        style: TextStyle(
                                                            fontSize:
                                                                14)), // Adjust font size
                                                  ),
                                                ),
                                              ],
                                              onSelected: (String choice) {
                                                if (choice == 'delete') {
                                                  context
                                                      .read<CreatePostBloc>()
                                                      .add(DeletePost(
                                                          item.postId));
                                                }
                                              },
                                              icon: const Icon(Icons.more_vert),
                                            )
                                          ],
                                        ),
                                        if (item.content != null)
                                          Text(item.content!),
                                        if (item.imageUrl != "")
                                          Container(
                                            height: 200,
                                            margin:
                                                const EdgeInsets.only(top: 8.0),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: NetworkImage(
                                                    item.imageUrl!),
                                              ),
                                            ),
                                          ),
                                        ActionsRow(item: item)
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    )),
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
