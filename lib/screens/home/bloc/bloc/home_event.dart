part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeEvent {
  @override
  List<Object> get props => [];
}

class HomeUpdateTab extends HomeEvent {
  final int tabIndex;
  HomeUpdateTab({required this.tabIndex});
  @override
  List<Object> get props => [tabIndex];
}
