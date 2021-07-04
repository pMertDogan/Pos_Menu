part of 'menu_cubit.dart';

@immutable
abstract class MenuState {}

class MenuInitial extends MenuState {}
class MenuLoading extends MenuState {}
class MenuLoaded extends MenuState {
final Menu homeMenu ;

  MenuLoaded({
    required this.homeMenu,
  });

}
class MenuSelected extends MenuState {
final Item selectedMenu ;

  MenuSelected({
    required this.selectedMenu,
  });

}