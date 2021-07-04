import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos/state/cubit/menu_cubit.dart';
import "package:flutter/services.dart" as s;
import 'package:pos/state/cubit/promo_cubit.dart';
import 'package:pos/state/cubit/sepet_cubit.dart';

import 'menus.dart';
import 'dart:io' show Platform;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final String data = await s.rootBundle.loadString('assets/menu.yaml');
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (context) => MenuCubit(data),
      ),
      BlocProvider(
        create: (context) => PromoCubit(context.read<MenuCubit>()),
      ),
      BlocProvider(
        create: (context) => SepetCubit(),
      ),
    ],
    child: HomeScreen(),
  ));
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      title: 'POS',
      color: Colors.black,
      home: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            title: Text('Menüler'),
            backgroundColor: Colors.black,
            centerTitle: true,
          ),
          body: BlocBuilder<MenuCubit, MenuState>(
            builder: (context, state) {
              if (state is MenuLoaded) {
                return GridView.count(
                  //maxCrossAxisExtent: 700,
                  crossAxisCount: Platform.isAndroid ? 2 : 4,

                  children: [
                    for (Item eachMenu in state.homeMenu.items)
                      InkWell(
                        onTap: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      MenuSelectedView())).then(
                              (value) => context.read<PromoCubit>().sifirla());
                          //Hafıza silinmeli
                          context.read<MenuCubit>().showSubMenu(eachMenu);
                        },
                        child: Stack(children: [
                          Positioned.fill(
                            child: Image.asset(
                              eachMenu.image,
                              fit: BoxFit.fill,
                            ),
                          ),
                          Container(
                              color: Colors.black38,
                              child: Text(
                                eachMenu.caption,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: Platform.isAndroid ? 20 : 28),
                              )),
                        ]),
                      )
                  ],
                );
              } else {
                return Text('Error');
              }
            },
          )),
    );
  }
}

class MenuSelectedView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Yemekler'),
        backgroundColor: Colors.black,
        centerTitle: true,
        leading: Center(
            child: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
            context.read<MenuCubit>().undo();
          },
        )),
      ),
      body: BlocBuilder<MenuCubit, MenuState>(
        builder: (context, state) {
          if (state is MenuSelected) {
            return GridView.count(
              crossAxisCount: Platform.isAndroid ? 2 : 4,
              children: [
                for (Item eachMenu in state.selectedMenu.items)
                  InkWell(
                    onTap: () {
                      if (eachMenu.subMenus.isNotEmpty) {
                        context
                            .read<PromoCubit>()
                            .updatePromoMenus(eachMenu.subMenus);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PromoMenuView())).then(
                            (value) => context.read<PromoCubit>().sifirla());
                      }
                    },
                    child: Stack(children: [
                      Positioned.fill(
                        child: Image.asset(
                          eachMenu.image,
                          fit: BoxFit.fill,
                        ),
                      ),
                      Container(
                        color: Colors.black38,
                        child: Text(
                          eachMenu.caption,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: Platform.isAndroid ? 20 : 28),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Text(
                          eachMenu.price.toString() + " ₺ ",
                          style: TextStyle(color: Colors.white, fontSize: 28),
                        ),
                      )
                    ]),
                  )
              ],
            );
          } else {
            return Text('Error');
          }
        },
      ),
    );
  }
}

class PromoMenuView extends StatelessWidget {
  const PromoMenuView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Yemekler'),
        backgroundColor: Colors.black,
        centerTitle: true,
        leading: Center(
            child: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                  // context.read<MenuCubit>().undo();
                })),
      ),
      body: BlocBuilder<PromoCubit, PromoState>(
        // for (Menu menu in state.menuList)
        builder: (context, state) {
          if (state is PromoMenuSelected) {
            List<Widget> menuler = <Widget>[];
            for (Menu menu in state.menuList)
              menuler.add(Column(
                children: [
                  Text(
                    menu.description,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (Item item in menu.items)
                          InkWell(
                            onTap: () {
                              context.read<PromoCubit>().yemekSecildi(
                                  menu.key == '' ? 'Key boş geldi' : menu.key,
                                  item);
                            },
                            child: Container(
                              constraints:
                                  BoxConstraints(minHeight: 200, minWidth: 300),
                              child: Stack(children: [
                                Positioned.fill(
                                  child: Image.asset(
                                    item.image,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                Container(
                                  color: Colors.black38,
                                  child: Text(
                                    item.name,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: Platform.isAndroid ? 20 : 28),
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: Text(
                                    item.price != ''
                                        ? item.price.toString() + " ₺ "
                                        : '',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 28),
                                  ),
                                ),
                                if (state.secilenler[menu.key] != null)
                                  Positioned(
                                      left: 15,
                                      // right: 0,
                                      bottom: 15,
                                      // top: 0,
                                      child: state.secilenler[menu.key]?.name ==
                                              item.name
                                          ? Icon(
                                              Icons.check_circle,
                                              color: Colors.green,
                                              size: 35,
                                            )
                                          : Container())
                              ]),
                            ),
                          )
                      ],
                    ),
                  )
                ],
              ));

            Widget sepeteEkle = TextButton(
                onPressed: () {},
                child: Text(
                  'Sepete Ekle',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ));
            return ListView(
              //itemExtent: 250,
              children: [...menuler, sepeteEkle],
            );
          } else {
            return Text('error');
          }
        },
      ),
    );
  }
}
