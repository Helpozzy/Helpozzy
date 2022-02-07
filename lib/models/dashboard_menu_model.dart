class DashboardMenus {
  DashboardMenus.fromList({required List<MenuModel> items}) {
    items.forEach((element) {
      menus.add(
        MenuModel(id: element.id, asset: element.asset, label: element.label),
      );
    });
  }
  late List<MenuModel> menus = [];
}

class MenuModel {
  MenuModel({
    required this.id,
    required this.asset,
    required this.label,
  });
  late int id;
  late String asset;
  late String label;
}
