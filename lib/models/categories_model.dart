class CategoryModel {
  CategoryModel({
    this.id,
    this.imgUrl,
    this.label,
    this.isSelected = false,
  });
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'img_url': imgUrl,
      'label': label,
    };
  }

  late int? id;
  late String? imgUrl;
  late String? label;
  late bool? isSelected;
}
