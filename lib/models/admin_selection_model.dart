class AdminTypes {
  AdminTypes.fromJson({required List items}) {
    items.forEach((element) {
      adminTypes.add(AdminTypeModel.fromJson(json: element));
    });
  }
  late List<AdminTypeModel> adminTypes = [];
}

class AdminTypeModel {
  AdminTypeModel.fromJson({required Map<String, dynamic> json}) {
    id = json['id'];
    imgUrl = json['img_url'];
    label = json['title'];
  }
  late int id;
  late String imgUrl;
  late String label;
}
