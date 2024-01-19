import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:web_auth/blocs/login_bloc/login_bloc.dart';
import 'package:web_auth/blocs/my_user_bloc/my_user_bloc.dart';
import 'package:web_auth/blocs/update_user_info_bloc/update_user_info_bloc.dart';
import 'package:web_auth/data/user_repository/models/my_user.dart';
import 'package:web_auth/screens/home/post_screen.dart';
import 'package:web_auth/screens/menu/feed_page.dart';
import 'package:web_auth/screens/menu/postpage.dart';
import 'package:web_auth/screens/menu/profile_page.dart';

enum Menu { itemOne, itemTwo, itemThree }

class HomeScreen extends StatefulWidget {
  static const routeName = '/HomeScreen';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bool isLargeScreen = width > 800;

    return BlocListener<UpdateUserInfoBloc, UpdateUserInfoState>(
      listener: (context, state) {
        if (state is UploadPictureSuccess) {
          setState(() {
            context.read<MyUserBloc>().state.user!.picture = state.userImage;
          });
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        floatingActionButton: BlocBuilder<MyUserBloc, MyUserState>(
          builder: (context, state) {
            return FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => PostScreen(state.user!),
                  ),
                );
              },
              child: const Icon(CupertinoIcons.add),
            );
          },
        ),
        key: _scaffoldKey,
        appBar: _buildAppBar(isLargeScreen, width),
        drawer: isLargeScreen ? null : _buildDrawer(),
        body: _buildBody(),
      ),
    );
  }

  AppBar _buildAppBar(bool isLargeScreen, width) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      titleSpacing: 0,
      leading: isLargeScreen
          ? null
          : IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => _scaffoldKey.currentState?.openDrawer(),
            ),
      title: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.01),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "LOGO",
              style:
                  TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
            ),
            if (isLargeScreen) SizedBox(width: width * 0.02),
            if (isLargeScreen) _buildSearchBar(width),
            if (isLargeScreen) SizedBox(width: width * 0.04),
            if (isLargeScreen)
              Expanded(
                child: SalomonBottomBar(
                  currentIndex: _selectedIndex,
                  selectedItemColor: const Color(0xff6200ee),
                  unselectedItemColor: const Color(0xff757575),
                  onTap: (index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  items: _navBarItems,
                ),
              ),
          ],
        ),
      ),
      actions: _buildAppBarActions(isLargeScreen, width),
    );
  }

  Widget _buildSearchBar(width) {
    return Container(
      width: width * 0.22,
      height: 35,
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.grey[300],
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(10, 2, 2, 0),
          hintText: 'Search...',
          border: InputBorder.none,
          suffixIcon: _isSearching
              ? IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      _searchController.clear();
                      _isSearching = false;
                    });
                  },
                )
              : IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      _isSearching = true;
                    });
                  },
                ),
        ),
        onChanged: (value) {
          setState(() {});
        },
        onTap: () {
          setState(() {
            _isSearching = true;
          });
        },
        focusNode: FocusNode(),
      ),
    );
  }

  List<Widget> _buildAppBarActions(bool isLargeScreen, width) {
    return [
      if (isLargeScreen) SizedBox(width: width * 0.05),
      IconButton(
        icon: const Icon(Icons.message),
        onPressed: () {},
        tooltip: 'Messages',
      ),
      SizedBox(width: width * 0.01),
      IconButton(
        icon: const Icon(Icons.notifications),
        onPressed: () {},
        tooltip: 'Notifications',
      ),
      SizedBox(width: width * 0.01),
      Padding(
        padding: EdgeInsets.only(right: width * 0.01),
        child: CircleAvatar(child: menuButton()),
      ),
    ];
  }

  Widget menuButton() {
    return PopupMenuButton<Menu>(
      offset: const Offset(0, 40),
      onSelected: (Menu item) {
        if (item == Menu.itemOne) {
          setState(() {
            _selectedIndex = 7;
          });
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
          if (state.status == MyUserStatus.loading) {
            const CircularProgressIndicator();
          }
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

  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DrawerHeader(
            padding: const EdgeInsets.symmetric(vertical: 10),
            curve: Easing.legacyAccelerate,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: BlocBuilder<MyUserBloc, MyUserState>(
              builder: (context, state) {
                if (state.status == MyUserStatus.success) {
                  return _buildDrawerHeaderContent(state.user!);
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          ),
          Expanded(
            child: ListView(
              children: _buildDrawerListItems(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerHeaderContent(MyUser user) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildAvatar(user),
        const SizedBox(height: 12),
        _buildUserName(user),
      ],
    );
  }

  Widget _buildAvatar(MyUser user) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipOval(
        child: Image.network(
          user.picture != "" ? user.picture! : '',
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildUserName(MyUser user) {
    return Text(
      "${user.firstName} ${user.lastName}",
      style: const TextStyle(
          fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
    );
  }

  List<Widget> _buildDrawerListItems() {
    return _menuItems
        .asMap()
        .entries
        .map(
          (entry) => ListTile(
            onTap: () {
              setState(() {
                _selectedIndex = entry.key;
                Navigator.pop(context);
              });
            },
            leading: Icon(
              _getIconData(entry.value),
              color: Theme.of(context).colorScheme.primary,
            ),
            title: Text(
              entry.value,
              style: const TextStyle(color: Colors.black87),
            ),
          ),
        )
        .toList();
  }

  final List<String> _menuItems = <String>[
    'Feed',
    'Projects',
    'Knowledge',
    'Code',
    'Community',
    'Challenges',
  ];

  List<SalomonBottomBarItem> _navBarItems = [];

  _HomeScreenState() {
    _navBarItems = _generateNavBarItems();
  }

  List<SalomonBottomBarItem> _generateNavBarItems() {
    return _menuItems.map((item) {
      IconData iconData = _getIconData(item);
      Color selectedColor = _getColorForItem(item);
      return SalomonBottomBarItem(
        icon: Icon(iconData),
        title: Text(item.toUpperCase()),
        selectedColor: selectedColor,
      );
    }).toList();
  }

  Color _getColorForItem(String item) {
    switch (item) {
      case 'Feed':
        return Colors.purple;
      case 'Projects':
        return Colors.blue;
      case 'Knowledge':
        return Colors.green;
      case 'Code':
        return Colors.orange;
      case 'Community':
        return Colors.red;
      case 'Challenges':
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }

  IconData _getIconData(String item) {
    switch (item) {
      case 'Feed':
        return Icons.rss_feed;
      case 'Projects':
        return Icons.folder;
      case 'Knowledge':
        return Icons.book;
      case 'Code':
        return Icons.code;
      case 'Community':
        return Icons.people;
      case 'Challenges':
        return Icons.emoji_events;

      default:
        return Icons.error;
    }
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return FeedPage();
      case 1:
        return const PostPage();
      case 2:
        return Container();
      case 3:
        return Container();
      case 4:
        return Container();
      case 5:
        return Container();
      case 6:
        return Container();
      case 7:
        return const ProfilePage();
      default:
        return Container();
    }
  }
}
