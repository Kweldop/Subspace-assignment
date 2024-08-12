import 'dart:convert';

import 'package:flutter/foundation.dart';

Blogs blogsFromJson(String str) => Blogs.fromJson(json.decode(str));

String blogsToJson(Blogs data) => json.encode(data.toJson());

class Blogs {
  final List<Blog>? blogs;

  Blogs({
    this.blogs,
  });

  factory Blogs.fromJson(Map<String, dynamic> json) => Blogs(
        blogs: json["blogs"] == null
            ? []
            : List<Blog>.from(json["blogs"]!.map((x) => Blog.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "blogs": blogs == null
            ? []
            : List<dynamic>.from(blogs!.map((x) => x.toJson())),
      };
}

class Blog {
  final String? id;
  final String? imageUrl;
  final String? title;

  Blog({
    this.id,
    this.imageUrl,
    this.title,
  });

  factory Blog.fromJson(Map<String, dynamic> json) => Blog(
        id: json["id"],
        imageUrl: json["image_url"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image_url": imageUrl,
        "title": title,
      };
}

class BlogOffline {
  final String? id;
  final Uint8List? image;
  final String? title;

  BlogOffline({this.id, this.image, this.title});
}
