import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:web_auth/blocs/create_post_bloc/create_post_bloc.dart';
import 'package:web_auth/blocs/my_user_bloc/my_user_bloc.dart';
import 'package:web_auth/blocs/update_user_info_bloc/update_user_info_bloc.dart';
import 'package:web_auth/components/menubutton.dart';
import 'package:web_auth/data/post_repository/firebase_post_repository.dart';
import 'package:web_auth/screens/home/post_screen.dart';
import 'package:web_auth/screens/menu/feedpage.dart';
import 'package:web_auth/screens/menu/postpage.dart';

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
            if (state.status == MyUserStatus.success) {
              return FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) =>
                          BlocProvider<CreatePostBloc>(
                        create: (context) => CreatePostBloc(
                            postRepository: FirebasePostRepository()),
                        child: PostScreen(state.user!),
                      ),
                    ),
                  );
                },
                child: const Icon(CupertinoIcons.add),
              );
            } else {
              return const FloatingActionButton(
                onPressed: null,
                child: Icon(CupertinoIcons.clear),
              );
            }
          },
        ),
        key: _scaffoldKey,
        appBar: AppBar(
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
                  style: TextStyle(
                      color: Colors.green, fontWeight: FontWeight.bold),
                ),
                if (isLargeScreen) SizedBox(width: width * 0.03),
                if (isLargeScreen)
                  Container(
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
                        setState(() {
                          // You can add your search logic here
                        });
                      },
                      onTap: () {
                        setState(() {
                          _isSearching = true;
                        });
                      },
                      focusNode: FocusNode(),
                    ),
                  ),
                if (isLargeScreen) SizedBox(width: width * 0.03),
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
                        items: _navBarItems),
                  )
              ],
            ),
          ),
          actions: [
            if (isLargeScreen) SizedBox(width: width * 0.05),
            // Message icon button
            IconButton(
              icon: const Icon(Icons.message),
              onPressed: () {
                // Add your functionality here
              },
              tooltip: 'Messages',
            ),
            SizedBox(width: width * 0.01),
            // Bell icon button
            IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () {
                // Add your functionality here
              },
              tooltip: 'Notifications',
            ),
            SizedBox(width: width * 0.01),
            Padding(
              padding: EdgeInsets.only(right: width * 0.01),
              child: const CircleAvatar(child: MenuButton()),
            )
          ],
        ),
        drawer: isLargeScreen ? null : _drawer(),
        body: buildBody(),
      ),
    );
  }

  Widget _drawer() {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DrawerHeader(
            padding: const EdgeInsets.symmetric(vertical: 10),
            curve: Easing.legacyAccelerate,
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .primary, // Background color for header
            ),
            child: BlocBuilder<MyUserBloc, MyUserState>(
              builder: (context, state) {
                if (state.status == MyUserStatus.success) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 3,
                              blurRadius: 7,
                              offset: const Offset(
                                  0, 3), // shadow direction: bottom
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Image.network(
                            state.user!.picture != ""
                                ? state.user!.picture!
                                : 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1470&q=80',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "${state.user!.firstName} ${state.user!.lastName}",
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ],
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          ),
          Expanded(
            child: ListView(
              children: _menuItems
                  .asMap()
                  .entries
                  .map(
                    (entry) => ListTile(
                      onTap: () {
                        setState(() {
                          _selectedIndex = entry.key;
                          Navigator.pop(
                              context); // Close drawer on item selection
                        });
                      },
                      leading: Icon(
                        _getIconData(entry.value),
                        color: Theme.of(context)
                            .colorScheme
                            .primary, // Icon color for drawer items
                      ),
                      title: Text(
                        entry.value,
                        style: const TextStyle(
                            color:
                                Colors.black87), // Text color for drawer items
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
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
      Color selectedColor =
          _getColorForItem(item); // Function to get color based on item
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

  Widget buildBody() {
    switch (_selectedIndex) {
      case 0: // Feed
        return const FeedPage();
      case 1: // Projects
        return const PostPage();
      case 2: // Knowledge
        return Container();
      case 3: // Code
        return Container();
      case 4: // Community
        return Container();
      case 5: // Challenges
        return Container();

      default:
        return Container(); // Or a default screen if needed
    }
  }
}









//   Widget _drawer() => Drawer(
//         child: ListView(
//           children: _menuItems
//               .map((item) => ListTile(
//                     onTap: () {
//                       _scaffoldKey.currentState?.openEndDrawer();
//                     },
//                     title: Text(item),
//                   ))
//               .toList(),
//         ),
//       );

//   Widget _navBarItems() => Row(
//         mainAxisAlignment: MainAxisAlignment.end,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: _menuItems
//             .map(
//               (item) => InkWell(
//                 onTap: () {},
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(
//                       vertical: 24.0, horizontal: 16),
//                   child: Text(
//                     item,
//                     style: const TextStyle(fontSize: 18),
//                   ),
//                 ),
//               ),
//             )
//             .toList(),
//       );
// }



// final List<String> _menuItems = <String>[
//   'About',
//   'Contact',
//   'Settings',
//   'Sign Out',
// ];




// AppBar(
//           centerTitle: false,
//           elevation: 0,
//           backgroundColor: Theme.of(context).colorScheme.background,
//           title: BlocBuilder<MyUserBloc, MyUserState>(
//             builder: (context, state) {
//               if (state.status == MyUserStatus.success) {
//                 return Row(
//                   children: [
//                     GestureDetector(
//                       onTap: () async {
//                         html.File? image =
//                             (await ImagePickerWeb.getImageAsFile());
//                         if (image != null) {
//                           setState(() {
//                             context.read<UpdateUserInfoBloc>().add(
//                                   UploadPicture(
//                                     image,
//                                     context.read<MyUserBloc>().state.user!.id,
//                                   ),
//                                 );
//                           });
//                         }
//                       },
//                       child:
//                           BlocBuilder<UpdateUserInfoBloc, UpdateUserInfoState>(
//                         builder: (context, s) {
//                           bool isLoading = s is UploadPictureLoading &&
//                               state.status != MyUserStatus.success;
//                           return Container(
//                             width: 50,
//                             height: 50,
//                             decoration: const BoxDecoration(
//                               color: Colors.grey,
//                               shape: BoxShape.circle,
//                             ),
//                             child: state.user!.picture != ""
//                                 ? displayImage(
//                                     state.user!.picture!,
//                                     isLoading,
//                                   )
//                                 : Icon(
//                                     CupertinoIcons.person,
//                                     color: Colors.grey.shade400,
//                                   ),
//                           );
//                         },
//                       ),
//                     ),
//                     const SizedBox(width: 10),
//                     Text("Welcome ${state.user!.userName}")
//                   ],
//                 );
//               } else {
//                 return Container();
//               }
//             },
//           ),
//           actions: [
//             IconButton(
//                 onPressed: () {
//                   context.read<LoginBloc>().add(const SignOutRequired());
//                 },
//                 icon: Icon(
//                   CupertinoIcons.square_arrow_right,
//                   color: Theme.of(context).colorScheme.onBackground,
//                 ))
//           ],
//         ),

// class ResponsiveNavBarPage extends StatelessWidget {
//   ResponsiveNavBarPage({Key? key}) : super(key: key);

//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
//     final bool isLargeScreen = width > 800;

//     return Theme(
//       data: ThemeData.dark(),
//       child: Scaffold(
//         key: _scaffoldKey,
//         appBar: AppBar(
//           backgroundColor: Colors.transparent,
//           elevation: 0,
//           titleSpacing: 0,
//           leading: isLargeScreen
//               ? null
//               : IconButton(
//                   icon: const Icon(Icons.menu),
//                   onPressed: () => _scaffoldKey.currentState?.openDrawer(),
//                 ),
//           title: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Text(
//                   "Logo",
//                   style: TextStyle(
//                       color: Colors.green, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(width: 20.0),
//                 if (isLargeScreen)
//                   Container(
//                     width: 300,
//                     height: 35,
//                     margin: const EdgeInsets.all(5),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(5),
//                       color: Colors.grey[300],
//                     ),
//                     child: TextField(
//                       controller: _searchController,
//                       decoration: InputDecoration(
//                         contentPadding: const EdgeInsets.fromLTRB(10, 2, 2, 0),
//                         hintText: 'Search...',
//                         border: InputBorder.none,
//                         suffixIcon: _isSearching
//                             ? IconButton(
//                                 icon: const Icon(Icons.close),
//                                 onPressed: () {
//                                   setState(() {
//                                     _searchController.clear();
//                                     _isSearching = false;
//                                   });
//                                 },
//                               )
//                             : IconButton(
//                                 icon: const Icon(Icons.search),
//                                 onPressed: () {
//                                   setState(() {
//                                     _isSearching = true;
//                                   });
//                                 },
//                               ),
//                       ),
//                       onChanged: (value) {
//                         setState(() {
//                           // You can add your search logic here
//                         });
//                       },
//                       onTap: () {
//                         setState(() {
//                           _isSearching = true;
//                         });
//                       },
//                       focusNode: FocusNode(),
//                     ),
//                   ),
//                 if (isLargeScreen) Expanded(child: _navBarItems())
//               ],
//             ),
//           ),
//           actions: const [
//             Padding(
//               padding: EdgeInsets.only(right: 16.0),
//               child: CircleAvatar(child: MenuButton()),
//             )
//           ],
//         ),
//         drawer: isLargeScreen ? null : _drawer(),
//         body: const Center(
//           child: Text(
//             "Body",
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _drawer() => Drawer(
//         child: ListView(
//           children: _menuItems
//               .map((item) => ListTile(
//                     onTap: () {
//                       _scaffoldKey.currentState?.openEndDrawer();
//                     },
//                     title: Text(item),
//                   ))
//               .toList(),
//         ),
//       );

//   Widget _navBarItems() => Row(
//         mainAxisAlignment: MainAxisAlignment.end,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: _menuItems
//             .map(
//               (item) => InkWell(
//                 onTap: () {},
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(
//                       vertical: 24.0, horizontal: 16),
//                   child: Text(
//                     item,
//                     style: const TextStyle(fontSize: 18),
//                   ),
//                 ),
//               ),
//             )
//             .toList(),
//       );
// }






// AppBar(
//           title: Row(
//             children: [
//               SizedBox(
//                 width: 100.0,
//                 height: 100.0,
//                 child: Image.network(
//                     'https://e7.pngegg.com/pngimages/287/216/png-clipart-black-and-red-wings-logo-illustration-logo-phoenix-art-phoenix-leaf-logo.png'), // Replace with your company logo
//               ),
//               const SizedBox(width: 10.0),
//               const Text(
//                 'TeenFeens',
//                 style: TextStyle(
//                   fontSize: 18.0,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
              
//             ],
//           ),
//           actions: [
//             // Feed, Projects, Knowledge, Code, Community, Challenges buttons
//             IconButton(
//               icon: const Icon(Icons.rss_feed),
//               onPressed: () {
//                 // Add your functionality here
//               },
//               tooltip: 'Feed',
//             ),
//             const SizedBox(width: 10),
//             IconButton(
//               icon: const Icon(Icons.folder),
//               onPressed: () {
//                 // Add your functionality here
//               },
//               tooltip: 'Projects',
//             ),
//             const SizedBox(width: 10),
//             IconButton(
//               icon: const Icon(Icons.book),
//               onPressed: () {
//                 // Add your functionality here
//               },
//               tooltip: 'Knowledge',
//             ),
//             const SizedBox(width: 10),
//             IconButton(
//               icon: const Icon(Icons.code),
//               onPressed: () {
//                 // Add your functionality here
//               },
//               tooltip: 'Code',
//             ),
//             const SizedBox(width: 10),
//             IconButton(
//               icon: const Icon(Icons.people),
//               onPressed: () {
//                 // Add your functionality here
//               },
//               tooltip: 'Community',
//             ),
//             const SizedBox(width: 10),
//             IconButton(
//               icon: const Icon(Icons.emoji_events),
//               onPressed: () {
//                 // Add your functionality here
//               },
//               tooltip: 'Challenges',
//             ),
            // const SizedBox(width: 160),
            // // Message icon button
            // IconButton(
            //   icon: const Icon(Icons.message),
            //   onPressed: () {
            //     // Add your functionality here
            //   },
            //   tooltip: 'Messages',
            // ),
            // const SizedBox(width: 10),
            // // Bell icon button
            // IconButton(
            //   icon: const Icon(Icons.notifications),
            //   onPressed: () {
            //     // Add your functionality here
            //   },
            //   tooltip: 'Notifications',
            // ),

//             const SizedBox(width: 10),
//             // Logout button
//             IconButton(
//               icon: const Icon(Icons.logout),
//               onPressed: () {
//                 context.read<LoginBloc>().add(const SignOutRequired());
//               },
//               tooltip: 'Logout',
//             ),
//             const SizedBox(width: 10),
//           ],
//         ),