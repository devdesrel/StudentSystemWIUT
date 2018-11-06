class CCMRolesModel {
  bool su;
  bool deansOffice;
  bool headOfCourse;
  bool rectorsOffice;
  bool courseLeader;
  bool moduleLeader;

  CCMRolesModel(
      {this.su,
      this.deansOffice,
      this.headOfCourse,
      this.rectorsOffice,
      this.courseLeader,
      this.moduleLeader});

  factory CCMRolesModel.fromJson(Map<String, dynamic> json) {
    return CCMRolesModel(
        su: json["SU"] ?? false,
        deansOffice: json['DeansOffice'] ?? false,
        headOfCourse: json['HeadOfCourse'] ?? false,
        rectorsOffice: json['RectorsOffice'] ?? false,
        courseLeader: json['CourseLeader'] ?? false,
        moduleLeader: json['ModuleLeader'] ?? false);
  }
}
