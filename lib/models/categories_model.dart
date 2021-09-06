class Categories {
  Categories.fromJson({required List items}) {
    items.forEach((element) {
      item.add(CategoryModel.fromJson(json: element));
    });
  }
  late List<CategoryModel> item = [];
}

class CategoryModel {
  CategoryModel.fromJson({required Map<String, dynamic> json}) {
    id = json['id'];
    imgUrl = json['img_url'];
    label = json['label'];
  }
  late int id;
  late String imgUrl;
  late String label;
}
