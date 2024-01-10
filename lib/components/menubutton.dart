import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_auth/blocs/login_bloc/login_bloc.dart';
import 'package:web_auth/blocs/my_user_bloc/my_user_bloc.dart';
import 'package:web_auth/screens/menu/profilepage.dart';

enum Menu { itemOne, itemTwo, itemThree }

class MenuButton extends StatelessWidget {
  const MenuButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Menu>(
      offset: const Offset(0, 40),
      onSelected: (Menu item) {
        if (item == Menu.itemOne) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProfilePage()),
          );
        }
        if (item == Menu.itemThree) {
          context.read<LoginBloc>().add(const SignOutRequired());
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
        const PopupMenuItem<Menu>(
          value: Menu.itemOne,
          child: Text('Account'),
        ),
        const PopupMenuItem<Menu>(
          value: Menu.itemTwo,
          child: Text('Settings'),
        ),
        const PopupMenuItem<Menu>(
          value: Menu.itemThree,
          child: Text('Log Out'),
        ),
      ],
      child: BlocBuilder<MyUserBloc, MyUserState>(
        builder: (context, state) {
          if (state.status == MyUserStatus.loading)
            const CircularProgressIndicator();
          if (state.status == MyUserStatus.success) {
            return CircleAvatar(
              radius: 20, // Adjust the size as needed
              backgroundImage: state.user!.picture != ""
                  ? NetworkImage(state.user!.picture!)
                  : const NetworkImage(
                      'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1470&q=80',
                    ),
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
