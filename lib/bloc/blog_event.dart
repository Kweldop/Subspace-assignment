part of 'blog_bloc.dart';

@immutable
sealed class BlogEvent extends Equatable {}

@immutable
class BlogsEvent extends BlogEvent {
  @override
  List<Object?> get props => [];
}
