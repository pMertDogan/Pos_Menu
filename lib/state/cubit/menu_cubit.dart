import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:pos/menus.dart';
import 'package:replay_bloc/replay_bloc.dart';
import 'package:yaml/yaml.dart';

import '../../menus.dart';

part 'menu_state.dart';

class MenuCubit extends ReplayCubit<MenuState> {
  MenuCubit(String data) : super(MenuInitial()) {
    getMenu(data);
  }
  List<Menu> menuList = <Menu>[];

  void getMenu(data) {
    emit(MenuLoading());
    final YamlMap mapData = loadYaml(data);
    final YamlList x = mapData['menus'];

    x.forEach((menu) {
      YamlList yemekTuru = menu['items'];
      /*
      Menü 
       Yemektürleri
          yemekler
       */
      List<Item> turler = [];
      yemekTuru.forEach((tur) {
        List<Item> yemekListesi = [];
        YamlList turYemekleri = tur['items'] ?? YamlList();
        turYemekleri.forEach((yemek) {
          yemekListesi.add(Item(
              name: yemek['name'] ?? '',
              caption: yemek['caption'] ?? '',
              image: yemek['image'] ?? '',
              price: yemek['price'] ?? '',
              subMenus: yemek['subMenus'] == null
                  ? []
                  : (yemek['subMenus'] as YamlList)
                      .map((element) => element.toString())
                      .toList(),
              items: []));
        });
        //yemekler bitiş
        //yemekleri yemek türüne ekle
        turler.add(Item(
            name: tur['name'] ?? '',
            caption: tur['caption'] ?? '',
            image: tur['image'] ?? '',
            price: tur['price'] ?? '',
            subMenus:
                (tur['subMenus'] == null ? [] : tur['subMenus'] as YamlList)
                    .map((element) => element.toString())
                    .toList(),
            items: yemekListesi));

        //yemek türünü oluşturduk
      });
      menuList.add(Menu(
          key: menu['key'], description: menu['description'],orderTag:  menu['orderTag'], items: turler));
    });

    emit(MenuLoaded(
        homeMenu: menuList.firstWhere((element) => element.key == 'main')));
  }

  void showSubMenu(Item menuItems) {
    // emit(MenuLoading());
    print('selected ' + menuItems.toString());
    emit(MenuSelected(
        selectedMenu: menuItems));
  }

  void promoMenuTime(List<String> promoMenus){

  }

}
