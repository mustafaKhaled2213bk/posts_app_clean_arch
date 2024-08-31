import 'package:flutter/material.dart';
import 'package:posts_app_clean_arch/features/posts/domain/entities/post_entity.dart';
import 'package:posts_app_clean_arch/features/posts/presentation/widgets/post_detail_page/post_detail_widget.dart';



class PostDetailPage extends StatelessWidget {
  final PostEntity post;
  const PostDetailPage({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppbar() {
    return AppBar(
      title: Text("Post Detail"),
    );
  }

  Widget _buildBody() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: PostDetailWidget(post: post),
      ),
    );
  }
}
