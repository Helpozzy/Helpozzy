class Reports {
  Reports.fromJson({required List<BarChartModel> list}) {
    list.forEach((element) {
      monthlyReports.add(BarChartModel(
          hours: element.hours, users: element.users, month: element.month));
    });
  }

  late List<BarChartModel> monthlyReports = [];
}

class BarChartModel {
  BarChartModel({
    required this.month,
    required this.hours,
    required this.users,
  });

  BarChartModel.fromjson({required Map<String, dynamic> json}) {
    month = json['month'];
    users = json['users'];
    hours = json['hours'];
  }

  Map<String, Object?> toJson() {
    return {
      'month': month,
      'users': users,
      'hours': hours,
    };
  }

  late String month;
  late int hours;
  late int users;
}
