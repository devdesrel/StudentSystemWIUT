class TimetableModel {
  final String dayOfWeek;
  String subjectshort;
  final String teachershort;
  final String classshort;
  final String classroomshort;
  String period;

  TimetableModel(
      {this.dayOfWeek,
      this.subjectshort,
      this.teachershort,
      this.classshort,
      this.classroomshort,
      this.period});

  factory TimetableModel.fromJson(Map<String, dynamic> json) {
    return TimetableModel(
        dayOfWeek: json['dayOfWeek'],
        subjectshort: json['subjectshort'],
        teachershort: json['teachershort'],
        classshort: json['classshort'],
        classroomshort: json['classroomshort'],
        period: json['period']);
  }
}
