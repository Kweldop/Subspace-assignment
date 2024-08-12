import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subspace/bloc/blog_bloc.dart';
import 'package:subspace/view/blog_page_view.dart';

class BlogListing extends StatefulWidget {
  const BlogListing({super.key});

  @override
  State<BlogListing> createState() => _BlogListingState();
}

class _BlogListingState extends State<BlogListing> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BlogBloc()..add(BlogsEvent()),
      child: BlocBuilder<BlogBloc, BlogState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'SubSpace',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              actions: [
                if (context.read<BlogBloc>().state is BlogOfflineLoading ||
                    context.read<BlogBloc>().state is BlogOfflineLoaded)
                  Padding(
                    padding: EdgeInsets.only(
                        right: MediaQuery.sizeOf(context).width * 0.05),
                    child: Icon(Icons.wifi_off_outlined),
                  )
              ],
            ),
            body: Column(
              children: [
                if (state is BlogLoading || state is BlogOfflineLoading)
                  const Center(
                    child: CircularProgressIndicator(),
                  )
                else if (state is BlogLoaded)
                  Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: state.blogs.blogs?.length ?? 0,
                        itemBuilder: (context, index) {
                          var blog = state.blogs.blogs?.elementAt(index);
                          return BlogPreview(
                            title: blog?.title ?? '',
                            imageUrl: blog?.imageUrl,
                          );
                        }),
                  )
                else if (state is BlogOfflineLoaded)
                  Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: state.blogs.length,
                        itemBuilder: (context, index) {
                          var blog = state.blogs.elementAt(index);

                          return BlogPreview(
                            title: blog.title ?? '',
                            image: blog.image,
                          );
                        }),
                  )
                else
                  const Center(
                    child: Text('Error while fetching data'),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class BlogPreview extends StatelessWidget {
  final String title;
  final String? imageUrl;
  final Uint8List? image;
  const BlogPreview(
      {super.key, required this.title, this.imageUrl, this.image});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  BlogPageView(title: title, image: image, imageUrl: imageUrl),
            ));
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          color: Colors.grey[800],
        ),
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.sizeOf(context).width * 0.05,
            vertical: MediaQuery.sizeOf(context).width * 0.05),
        margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.sizeOf(context).width * 0.05,
            vertical: MediaQuery.sizeOf(context).height * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: MediaQuery.sizeOf(context).width * 0.8,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: imageUrl != null
                    ? Image.network(
                        imageUrl ?? '',
                        fit: BoxFit.fitWidth,
                      )
                    : Image.memory(image!),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            )
          ],
        ),
      ),
    );
  }
}
