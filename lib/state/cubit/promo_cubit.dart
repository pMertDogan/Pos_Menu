import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pos/state/cubit/menu_cubit.dart';

import '../../menus.dart';

part 'promo_state.dart';

class PromoCubit extends Cubit<PromoState> {
  late final List<Menu> menuList;
  PromoCubit(MenuCubit menuCubit) : super(PromoInitial()) {
    menuList = menuCubit.menuList;
  }
  Map<String, Item> secilenler = <String, Item>{};

  void updatePromoMenus(List<String> promoMenus) {
    //TEST
    List<Menu> promoMenuList = <Menu>[];
    for (String menuKey in promoMenus) {
      promoMenuList
          .add(menuList.firstWhere((element) => element.key == menuKey));
    }
    emit(PromoMenuSelected(menuList: promoMenuList, secilenler: {}));
  }

  void yemekSecildi(String menu, Item item) {
    // print('seçilen' + item.toString());
    secilenler[menu] = item;
    // print(menu + item.toString());
    
    if (state is PromoMenuSelected) {
      
      emit((state as PromoMenuSelected).copyWith(yeniSecilenler: secilenler));
    }
  }

  void sifirla() {
    secilenler.clear();
  }
}
