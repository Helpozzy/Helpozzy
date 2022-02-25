class OrganizationSignUpModel {
  OrganizationSignUpModel({
    this.legalOrganizationName,
    this.discription,
    this.organizationType,
    this.other,
    this.taxIdNumber,
    this.otherAdmins,
    this.isNonProfitOrganization = false,
  });

  OrganizationSignUpModel.fromJson({required Map<String, dynamic> json}) {
    legalOrganizationName = json['legal_name'];
    discription = json['discription'];
    organizationType = json['organization_type'];
    other = json['other'];
    taxIdNumber = json['tax_id_number'];
    otherAdmins = json['other_admins'];
    isNonProfitOrganization = json['is_non_profit_organization'];
  }

  Map<String, dynamic> toJson() {
    return {
      'legal_name': legalOrganizationName,
      'discription': discription,
      'organization_type': organizationType,
      'other': other,
      'tax_id_number': taxIdNumber,
      'other_admins': otherAdmins,
      'is_non_profit_organization': isNonProfitOrganization,
    };
  }

  late String? legalOrganizationName;
  late String? discription;
  late String? organizationType;
  late String? other;
  late String? taxIdNumber;
  late List<String>? otherAdmins;
  late bool? isNonProfitOrganization;
}
