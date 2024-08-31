import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posts_app_clean_arch/core/app_theme.dart';
import 'package:posts_app_clean_arch/features/posts/presentation/bloc/add_delete_update_posts/add_delete_update_post_bloc.dart';
import 'package:posts_app_clean_arch/features/posts/presentation/bloc/posts/posts_bloc.dart';
import 'package:posts_app_clean_arch/features/posts/presentation/pages/posts_page.dart';
import 'package:posts_app_clean_arch/ingection_container.dart' as di;

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(create: (_) => di.sl.call<PostsBloc>()..add(GetAllPostsEvent())),
      BlocProvider(create: (_) => di.sl<AddDeleteUpdatePostBloc>())
    ], child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: appTheme,
            title: 'Posts App',
            home: PostsPage()));
  }
}
