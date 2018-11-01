class ActionsTakenModel{
  int id;
  String text;
  int feedbackID;
  String creator;
  String dateCreatedStr;
  bool isEditable;
  bool isDeletable;
  String type;
  
  ActionsTakenModel({
    this.id,
    this.text,
    this.feedbackID,
    this.creator,
    this.dateCreatedStr,
    this.isEditable,
    this.isDeletable,
    this.type
  });

  factory ActionsTakenModel.fromJson(Map<String, dynamic> json) {
    return ActionsTakenModel(
      id : json['ID'] ?? 0,
      text : json['Text'] ?? '',
      feedbackID : json['FeedbackID'] ?? 0,
      creator : json['Creator'] ?? '',
      dateCreatedStr : json['DateCreatedStr'] ?? '',
      isEditable : json['IsEditable'] ?? false,
      isDeletable : json['IsDeletable'] ?? false,
      type : json['Type'] ?? ''
    );
  }
}