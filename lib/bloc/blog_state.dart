part of 'blog_bloc.dart';

@immutable
sealed class BlogState extends Equatable {}

final class BlogInitial extends BlogState {
  @override
  List<Object?> get props => [];
}

final class BlogLoading extends BlogState {
  @override
  List<Object?> get props => [];
}

final class BlogOfflineLoading extends BlogState {
  @override
  List<Object?> get props => [];
}

final class BlogOfflineLoaded extends BlogState {
  final List<BlogOffline> blogs;
  BlogOfflineLoaded({required this.blogs});
  @override
  List<Object?> get props => [];
}

final class BlogLoaded extends BlogState {
  final Blogs blogs;
  BlogLoaded({required this.blogs});
  @override
  List<Object?> get props => [];
}

final class BlogError extends BlogState {
  @override
  List<Object?> get props => [];
}
