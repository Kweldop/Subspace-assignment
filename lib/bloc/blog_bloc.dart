import 'dart:io';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:subspace/model/blog_model.dart';
import 'package:subspace/service/api.dart';

import '../service/databasehelper.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  BlogBloc() : super(BlogInitial()) {
    ApiController api = ApiController();
    final DatabaseHelper dbHelper = DatabaseHelper();
    on<BlogsEvent>((event, emit) async {
      try {
        final result = await InternetAddress.lookup('example.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          emit(BlogLoading());
          await api.fetch(
            method: HttpMethod.get,
            endpoint: '/api/rest/blogs',
            additionalHeaders: {
              'x-hasura-admin-secret':
                  "32qR4KmXOIpsGPQKMqEJHGJS27G5s7HdSKO3gdtQd2kv5e852SiYwWNfxkZOBuQ6"
            },
            onSuccess: (res) async {
              var blogs = Blogs.fromJson(res.data);
              emit(BlogLoaded(blogs: blogs));
              await dbHelper
                  .deleteAllItems(); //To delete items from data base if exists
              await Future.wait(blogs.blogs?.map(
                    (e) async {
                      var response = await Dio().get(
                        e.imageUrl ?? '',
                        options: Options(responseType: ResponseType.bytes),
                      );
                      Uint8List imageBytes = Uint8List.fromList(response.data);

                      img.Image? image = img.decodeImage(imageBytes);
                      if (image != null) {
                        Uint8List compressedBytes = Uint8List.fromList(
                            img.encodeJpg(image, quality: 70));
                        return dbHelper.insertItem({
                          'id': e.id,
                          'image': compressedBytes,
                          'title': e.title,
                        });
                      }
                    },
                  ) ??
                  []); //To add new data
            },
            onFailure: (res) {
              emit(BlogError());
            },
          );
        }
      } on SocketException catch (_) {
        try {
          emit(BlogOfflineLoading());
          var blogsMap = await dbHelper.getItems();
          print(blogsMap);
          var blogs = blogsMap
              .map(
                (e) => BlogOffline(
                    id: e['id'],
                    title: e['title'],
                    image: e['image'] as Uint8List),
              )
              .toList();
          emit(BlogOfflineLoaded(blogs: blogs));
        } catch (e) {
          emit(BlogError());
        }
      }
    });
  }
}
