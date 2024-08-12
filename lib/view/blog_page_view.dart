import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:subspace/model/blog_model.dart';

class BlogPageView extends StatelessWidget {
  final String title;
  final String? imageUrl;
  final Uint8List? image;
  const BlogPageView(
      {super.key, required this.title, this.imageUrl, this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: MediaQuery.sizeOf(context).height * 0.01,
              horizontal: MediaQuery.sizeOf(context).width * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.85,
                child: imageUrl != null
                    ? Image.network(
                        imageUrl ?? '',
                        fit: BoxFit.fitWidth,
                      )
                    : Image.memory(image!),
              ),
              const SizedBox(height: 20),
              Text(title),
            ],
          ),
        ),
      ),
    );
  }
}
