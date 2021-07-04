part of 'promo_cubit.dart';

@immutable
abstract class PromoState {}

class PromoInitial extends PromoState {}

class PromoMenuSelected extends PromoState {
  final List<Menu> menuList;
  final Map<String,Item> secilenler ;
  PromoMenuSelected({required this.menuList,
   required this.secilenler 
    });

  PromoMenuSelected copyWith(
          {required Map<String,Item> yeniSecilenler }) =>
      PromoMenuSelected(
        menuList: this.menuList,
        secilenler: yeniSecilenler,
      );
}
