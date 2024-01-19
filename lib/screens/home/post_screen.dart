import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:universal_html/html.dart' as html;
import 'package:web_auth/blocs/create_post_bloc/create_post_bloc.dart';
import 'package:web_auth/blocs/get_post_bloc/get_post_bloc.dart';
import 'package:web_auth/blocs/my_user_bloc/my_user_bloc.dart';
import 'package:web_auth/blocs/post_count/post_count_bloc.dart';
import 'package:web_auth/blocs/post_image_bloc/post_image_bloc.dart';
import 'package:web_auth/data/post_repository/models/post.dart';
import 'package:web_auth/data/user_repository/models/my_user.dart';
import 'package:web_auth/extentions/file_extensions.dart';

class PostScreen extends StatefulWidget {
  static const routeName = '/PostScreen';

  final MyUser myUser;

  const PostScreen(this.myUser, {Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => PostScreenState();
}

class PostScreenState extends State<PostScreen> {
  late Post post;
  html.File? imageFile;

  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    post = Post.empty;
    post.myUser = widget.myUser;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreatePostBloc, CreatePostState>(
      listener: (context, state) {
        if (state is CreatePostSuccess && imageFile != null) {
          context.read<PostImageBloc>().add(
                UploadPostImage(imageFile!, post.postId, post.myUser.id),
              );
        }
      },
      child: BlocListener<PostImageBloc, PostImageState>(
        listener: (context, state) {
          if (state is UploadPostImageLoading) {
            _showProgressDialog(context);
          } else if (state is UploadPostImageSuccess) {
            _onUploadSuccess(context);
          } else if (state is UploadPostImageFailure) {
            _showUploadFailureDialog(context);
          }
        },
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            floatingActionButton: FloatingActionButton(
              onPressed: () => _onFabPressed(context),
              child: const Icon(Icons.check),
            ),
            appBar: AppBar(
              elevation: 0,
              foregroundColor: const Color.fromARGB(255, 0, 0, 0),
              title: const Text('Create a Post !'),
            ),
            body: SingleChildScrollView(
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () => _pickImage(),
                        child: _buildImagePreview(),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: _controller,
                          maxLines: 10,
                          maxLength: 500,
                          decoration: _buildTextFieldDecoration(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper methods

  void _onFabPressed(BuildContext context) async {
    if (_controller.text.isNotEmpty && imageFile == null) {
      setState(() => post.content = _controller.text);
      context.read<CreatePostBloc>().add(CreatePost(post));
      context.read<GetPostBloc>().add(GetPosts());
      final userId = context.read<MyUserBloc>().state.user!.id;
      context.read<PostCountBloc>().add(GetPostCount(userId));
      Navigator.pop(context);
    } else if (_controller.text.isEmpty && imageFile == null) {
      _showValidationErrorDialog(context);
    } else {
      setState(() => post.content = _controller.text);
      context.read<CreatePostBloc>().add(CreatePost(post));
    }
  }

  void _pickImage() async {
    imageFile = (await ImagePickerWeb.getImageAsFile());
    if (imageFile != null) {
      setState(() {});
    }
  }

  Widget _buildImagePreview() {
    return imageFile != null
        ? FutureBuilder<Uint8List>(
            future: imageFile!.asBytes(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Container(
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Image.memory(
                    snapshot.data!,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                );
              } else if (snapshot.hasError) {
                // Handle error if needed
                return Container();
              } else {
                return Container(
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_a_photo),
                        SizedBox(height: 8),
                        Text("Add Image"),
                      ],
                    ),
                  ),
                );
              }
            },
          )
        : Container(
            height: 200,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_a_photo),
                  SizedBox(height: 8),
                  Text("Add Image"),
                ],
              ),
            ),
          );
  }

  InputDecoration _buildTextFieldDecoration() {
    return InputDecoration(
      hintText: "Enter Your Post Here...",
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  void _showProgressDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            height: 100,
            width: 150,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Uploading Post",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16.0),
                LinearProgressIndicator(
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onUploadSuccess(BuildContext context) {
    Navigator.pop(context);
    context.read<GetPostBloc>().add(GetPosts());
    Navigator.pop(context);
  }

  void _showUploadFailureDialog(BuildContext context) {
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Upload Failed"),
          content: const Text("There was an error uploading the post."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _showValidationErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Can't Create Post"),
          content: const Text("Post should have text or image."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
