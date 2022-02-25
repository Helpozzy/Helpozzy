class CategoryModel {
  CategoryModel({
    this.id,
    this.asset,
    this.label,
    this.isSelected = false,
  });
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'img_url': asset,
      'label': label,
    };
  }

  late int? id;
  late String? asset;
  late String? label;
  late bool? isSelected;
}
