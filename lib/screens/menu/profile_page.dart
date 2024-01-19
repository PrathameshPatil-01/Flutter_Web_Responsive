import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:universal_html/html.dart' as html;
import 'package:web_auth/blocs/my_user_bloc/my_user_bloc.dart';
import 'package:web_auth/blocs/post_count/post_count_bloc.dart';
import 'package:web_auth/blocs/update_user_info_bloc/update_user_info_bloc.dart';

class ProfilePage extends StatefulWidget {

  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Expanded(flex: 1, child: _TopPortion()),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  BlocBuilder<MyUserBloc, MyUserState>(
                    builder: (context, state) {
                      if (state.status == MyUserStatus.success) {
                        return Text(
                            style: Theme.of(context).textTheme.titleLarge,
                            " ${state.user!.firstName} ${state.user!.lastName}");
                      } else {
                        return Container();
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FloatingActionButton.extended(
                        onPressed: () async {
                          html.File? image =
                              (await ImagePickerWeb.getImageAsFile());
                          if (image != null) {
                            setState(() {
                              context.read<UpdateUserInfoBloc>().add(
                                    UploadPicture(
                                      image,
                                      context.read<MyUserBloc>().state.user!.id,
                                    ),
                                  );
                            });
                          }
                        },
                        heroTag: 'Upload profile Picture',
                        elevation: 0,
                        label: const Text("Upload profile Picture"),
                        icon: const Icon(Icons.photo_camera),
                      ),
                      const SizedBox(width: 16.0),
                      FloatingActionButton.extended(
                        onPressed: () {},
                        heroTag: 'Delete',
                        elevation: 0,
                        backgroundColor: Colors.red,
                        label: const Text("Delete"),
                        icon: const Icon(Icons.delete),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const _ProfileInfoRow()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileInfoRow extends StatelessWidget {
  const _ProfileInfoRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      constraints: const BoxConstraints(maxWidth: 400),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Row(
              children: [
                BlocBuilder<PostCountBloc, PostCountState>(
                    builder: (context, state) {
                  if (state is PostCountLoadedState) {
                    return Expanded(
                      child: _singleItem(
                          context, ProfileInfoItem("Posts", state.postCount)),
                    );
                  } else {
                    return Expanded(
                      child: _singleItem(
                          context, const ProfileInfoItem("Posts", 0)),
                    );
                  }
                })
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                const VerticalDivider(),
                Expanded(
                  child: _singleItem(
                      context, const ProfileInfoItem("Following", 0)),
                )
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                const VerticalDivider(),
                Expanded(
                  child: _singleItem(
                      context, const ProfileInfoItem("Followers", 0)),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _singleItem(BuildContext context, ProfileInfoItem item) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              item.value.toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Text(
            item.title,
            style: Theme.of(context).textTheme.bodyMedium,
          )
        ],
      );
}

class ProfileInfoItem {
  final String title;
  final int value;
  const ProfileInfoItem(this.title, this.value);
}

class _TopPortion extends StatefulWidget {
  const _TopPortion({Key? key}) : super(key: key);

  @override
  State<_TopPortion> createState() => _TopPortionState();
}

class _TopPortionState extends State<_TopPortion> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        width: 100,
        height: 100,
        child: BlocBuilder<MyUserBloc, MyUserState>(
          builder: (context, state) {
            if (state.status == MyUserStatus.success) {
              return BlocBuilder<UpdateUserInfoBloc, UpdateUserInfoState>(
                builder: (context, s) {
                  bool isLoading = s is UploadPictureLoading;
                  return isLoading
                      ? const CircularProgressIndicator()
                      : Container(
                          decoration: BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: state.user!.picture != ""
                                    ? NetworkImage(
                                        state.user!.picture!,
                                      )
                                    : const NetworkImage(
                                        'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1470&q=80')),
                          ),
                        );
                },
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
