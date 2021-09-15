part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  final int currentIndex;
  const HomeState({
    this.currentIndex = 0,
  });

  @override
  List<Object> get props => [currentIndex];
}

class HomeInitialState extends HomeState {
  @override
  List<Object> get props => [];
}

class HomeCurrentTabState extends HomeState {
  final int index;
  HomeCurrentTabState({required this.index});

  @override
  int get currentIndex => index;

  @override
  List<Object> get props => [index];
}
