
class Menu {
  Menu({
    required this.key,
    required this.description,
    required this.items,
    this.orderTag,
  });
  String key;
  String description;
  List<Item> items;
  String? orderTag;

  // factory Menu.fromJson(YamlList yaml) => Menu(
  //       key: yaml["greeting"],
  //       instructions: List<String>.from(json["instructions"].map((x) => x)),
  //     );
}

class Item {
  Item({
    required this.name,
    required this.caption,
    required this.image,
    required this.items,
    this.price,
    required this.subMenus,
  });

  String name;
  String caption;
  String image;
  List<Item> items;
  dynamic price;
  List<String> subMenus;

  @override
  String toString() {
    // TODO: implement toString
    return name + ' * ' + caption + ' * ' + image + ' * ' + price;
  }
}
