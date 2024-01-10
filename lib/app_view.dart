import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_auth/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:web_auth/blocs/get_post_bloc/get_post_bloc.dart';
import 'package:web_auth/blocs/login_bloc/login_bloc.dart';
import 'package:web_auth/blocs/my_user_bloc/my_user_bloc.dart';
import 'package:web_auth/blocs/sign_up_bloc/sign_up_bloc.dart';
import 'package:web_auth/blocs/update_user_info_bloc/update_user_info_bloc.dart';
import 'package:web_auth/data/post_repository/post_repository.dart';
import 'package:web_auth/screens/authentication/login_screen.dart';
import 'package:web_auth/screens/home/home_screen.dart';
import 'package:web_auth/screens/routes/app_router.dart';

class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    final AppRouter appRouter = AppRouter();
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => LoginBloc(
                userRepository:
                    context.read<AuthenticationBloc>().userRepository),
          ),
          BlocProvider(
            create: (context) => UpdateUserInfoBloc(
                userRepository:
                    context.read<AuthenticationBloc>().userRepository),
          ),
          BlocProvider(
            create: (context) => MyUserBloc(
                myUserRepository:
                    context.read<AuthenticationBloc>().userRepository)
              ..add(GetMyUser(
                  myUserId:
                      context.read<AuthenticationBloc>().state.user!.uid)),
          ),
          BlocProvider<SignUpBloc>(
            create: (context) => SignUpBloc(
                userRepository:
                    context.read<AuthenticationBloc>().userRepository),
          ),
          BlocProvider(
              create: (context) =>
                  GetPostBloc(postRepository: FirebasePostRepository())
                    ..add(GetPosts()))
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
                outline: Color(0xFF424242)),
          ),
          home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
              builder: (context, state) {
            if (state.status == AuthenticationStatus.authenticated) {
              return const HomeScreen();
            } else {
              return const LoginScreen();
            }
          }),
        ));
  }
}
