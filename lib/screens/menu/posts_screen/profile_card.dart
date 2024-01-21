import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_auth/blocs/my_user_bloc/my_user_bloc.dart';
import 'package:web_auth/blocs/post_count/post_count_bloc.dart';
import 'package:web_auth/blocs/update_user_info_bloc/update_user_info_bloc.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 450,
      child: Container(
        alignment: AlignmentDirectional.topCenter,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Colors.grey[300]!,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey[200]!,
              offset: const Offset(
                5.0,
                5.0,
              ),
              blurRadius: 100.0,
              spreadRadius: 1.0,
            ), //BoxShadow
            const BoxShadow(
              color: Colors.white,
              offset: Offset(0.0, 0.0),
              blurRadius: 0.0,
              spreadRadius: 0.0,
            ), //BoxShadow
          ],
        ),
        padding: const EdgeInsets.fromLTRB(15, 8, 8, 5),
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            const Expanded(flex: 2, child: _TopPortion()),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    BlocBuilder<MyUserBloc, MyUserState>(
                      builder: (context, state) {
                        if (state.status == MyUserStatus.success) {
                          return Column(
                            children: [
                              Text(
                                "${state.user!.firstName} ${state.user!.lastName}",
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: 15),
                              Text(
                                "@ ${state.user!.userName}",
                                style:
                                    Theme.of(context).textTheme.titleMedium,
                              ),
                              Text(
                                state.user!.email,
                                style:
                                    Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 5),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  if (state.user!.city != '')
                                    Text(
                                      "${state.user!.city}",
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                  if (state.user!.state != '')
                                    Text(
                                      "${state.user!.state}",
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                  Text(
                                    state.user!.country,
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ],
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    const _ProfileInfoRow(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileInfoRow extends StatelessWidget {
  const _ProfileInfoRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
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
                        context,
                        ProfileInfoItem("Posts", state.postCount),
                      ),
                    );
                  } else {
                    return Expanded(
                      child: _singleItem(
                        context,
                        const ProfileInfoItem("Posts", 0),
                      ),
                    );
                  }
                },
              )
            ],
          ),
        ),
        const SizedBox(height: 40, child: Center(child: VerticalDivider())),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: _singleItem(
                  context,
                  const ProfileInfoItem("Following", 0),
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 40, child: Center(child: VerticalDivider())),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: _singleItem(
                  context,
                  const ProfileInfoItem("Followers", 0),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _singleItem(BuildContext context, ProfileInfoItem item) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
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
            style: Theme.of(context).textTheme.bodySmall,
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
              final userId = state.user!.id;
              context.read<PostCountBloc>().add(GetPostCount(userId));
              return GestureDetector(
                onTap: () {},
                child: BlocBuilder<UpdateUserInfoBloc, UpdateUserInfoState>(
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
                                        'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1470&q=80',
                                      ),
                              ),
                            ),
                          );
                  },
                ),
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
