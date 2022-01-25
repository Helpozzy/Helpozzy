class DashboardMenus {
  DashboardMenus.fromJson({required List items}) {
    items.forEach((element) {
      menus.add(MenuModel.fromJson(json: element));
    });
  }
  late List<MenuModel> menus = [];
}

class MenuModel {
  MenuModel.fromJson({required Map<String, dynamic> json}) {
    id = json['id'];
    imgUrl = json['img_url'];
    label = json['title'];
  }
  late int id;
  late String imgUrl;
  late String label;
}
