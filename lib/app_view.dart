import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_auth/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:web_auth/blocs/create_post_bloc/create_post_bloc.dart';
import 'package:web_auth/blocs/get_post_bloc/get_post_bloc.dart';
import 'package:web_auth/blocs/likes/likes_bloc.dart';
import 'package:web_auth/blocs/login_bloc/login_bloc.dart';
import 'package:web_auth/blocs/my_user_bloc/my_user_bloc.dart';
import 'package:web_auth/blocs/post_count/post_count_bloc.dart';
import 'package:web_auth/blocs/post_image_bloc/post_image_bloc.dart';
import 'package:web_auth/blocs/sign_up_bloc/sign_up_bloc.dart';
import 'package:web_auth/blocs/update_user_info_bloc/update_user_info_bloc.dart';
import 'package:web_auth/data/post_repository/firebase_post_repository.dart';
import 'package:web_auth/screens/authentication/login_screen.dart';
import 'package:web_auth/screens/home/home_screen.dart';
import 'package:web_auth/screens/routes/auth_app_router.dart';

class MyAppView extends StatelessWidget {
  final AppRouter appRouter = AppRouter();

  MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
      if (state.status == AuthenticationStatus.authenticated) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => LoginBloc(
                userRepository:
                    context.read<AuthenticationBloc>().userRepository,
              ),
            ),
            BlocProvider(
              create: (context) => SignUpBloc(
                userRepository:
                    context.read<AuthenticationBloc>().userRepository,
              ),
            ),
            BlocProvider(
              create: (context) => UpdateUserInfoBloc(
                userRepository:
                    context.read<AuthenticationBloc>().userRepository,
              ),
            ),
            BlocProvider(
              create: (context) => MyUserBloc(
                myUserRepository:
                    context.read<AuthenticationBloc>().userRepository,
              )..add(GetMyUser(
                  myUserId:
                      context.read<AuthenticationBloc>().state.user!.uid)),
            ),
            // Post Blocs
            BlocProvider(
              create: (context) => GetPostBloc(
                postRepository: FirebasePostRepository(),
              )..add(GetPosts()),
            ),
            BlocProvider(
              create: (context) => CreatePostBloc(
                postRepository: FirebasePostRepository(),
              ),
            ),
            BlocProvider(
              create: (context) => PostImageBloc(
                postRepository: FirebasePostRepository(),
              ),
            ),
            BlocProvider(
              create: (context) => LikesBloc(
                postRepository: FirebasePostRepository(),
              ),
            ),
            BlocProvider(
              create: (context) => PostCountBloc(
                postRepository: FirebasePostRepository(),
              ),
            ),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Website',
            theme: ThemeData(
              textTheme: Typography.blackRedmond,
              colorScheme: const ColorScheme.light(
                background: Colors.white,
                onBackground: Colors.black,
                primary: Color.fromRGBO(206, 147, 216, 1),
                onPrimary: Colors.black,
                secondary: Color.fromRGBO(244, 143, 177, 1),
                onSecondary: Color.fromARGB(255, 0, 0, 0),
                tertiary: Color.fromRGBO(255, 204, 128, 1),
                error: Colors.red,
                outline: Color(0xFF424242),
              ),
            ),
            home: const HomeScreen(),
          ),
        );
      } else {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => LoginBloc(
                userRepository:
                    context.read<AuthenticationBloc>().userRepository,
              ),
            ),
            BlocProvider(
              create: (context) => SignUpBloc(
                userRepository:
                    context.read<AuthenticationBloc>().userRepository,
              ),
            ),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Authentication',
            onGenerateRoute: appRouter.onGenerateRoute,
            theme: ThemeData(
              textTheme: Typography.blackRedmond,
              colorScheme: const ColorScheme.light(
                background: Colors.white,
                onBackground: Colors.black,
                primary: Color.fromRGBO(206, 147, 216, 1),
                onPrimary: Colors.black,
                secondary: Color.fromRGBO(244, 143, 177, 1),
                onSecondary: Color.fromARGB(255, 0, 0, 0),
                tertiary: Color.fromRGBO(255, 204, 128, 1),
                error: Colors.red,
                outline: Color(0xFF424242),
              ),
            ),
            home: const LoginScreen(),
          ),
        );
      }
    });
  }
}
