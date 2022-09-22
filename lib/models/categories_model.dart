class Categories {
  Categories.fromJson({required List<Map<String, dynamic>> list}) {
    list.forEach((category) {
      categories.add(CategoryModel.fromJson(category));
    });
  }

  late List<CategoryModel> categories = [];
}

class CategoryModel {
  CategoryModel({
    this.id,
    this.asset,
    this.label,
    this.isSelected = false,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      asset: json['asset'],
      label: json['label'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'asset': asset,
      'label': label,
    };
  }

  late int? id;
  late String? asset;
  late String? label;
  late bool? isSelected;
}
