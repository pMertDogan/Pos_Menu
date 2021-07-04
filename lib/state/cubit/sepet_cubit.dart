import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../menus.dart';

part 'sepet_state.dart';

class SepetCubit extends Cubit<SepetState> {
  SepetCubit() : super(SepetInitial());

  List<Item> sepettekiler = <Item>[];

  void addItemToSepet(Item item){

  }
}
