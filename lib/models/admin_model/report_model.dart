class Reports {
  Reports.fromJson({required List<Map<String, dynamic>> list}) {
    list.forEach((element) {
      yearlyReports.add(ReportModel.fromjson(json: element));
    });
  }

  late List<ReportModel> yearlyReports = [];
}

class ReportModel {
  ReportModel({
    required this.year,
    required this.users,
    required this.totalHrs,
  });

  ReportModel.fromjson({required Map<String, dynamic> json}) {
    year = json['year'];
    users = json['users'];
    totalHrs = json['total_hrs'];
  }

  Map<String, Object?> toJson() {
    return {
      'year': year,
      'users': users,
      'total_hrs': totalHrs,
    };
  }

  late int year;
  late int users;
  late int totalHrs;
}
