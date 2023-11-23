class RoomModel {
  RoomModel({
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.dueDate,
    this.description,
    this.roomTitle,
    this.userId,
    this.isCompleted = false,
    this.id,
    this.documentText,
    this.roomMember,
  });

  String? createdBy;
  int? createdAt;
  int? updatedAt;
  int? dueDate;
  String? description;
  String? roomTitle;
  String? userId;
  bool isCompleted;
  String? id;
  String? documentText;
  List<String>? roomMember;

  factory RoomModel.fromJson(
    docId,
    Map<String, dynamic> json,
  ) =>
      RoomModel(
        id: docId,
        createdBy: json["createdBy"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        dueDate: json["dueDate"],
        description: json["description"],
        roomTitle: json["roomTitle"],
        documentText: json["documentText"],
        isCompleted: json["isCompleted"] ?? false,
        userId: json["userId"],
        roomMember: json["roomMember"] == null
            ? []
            : List<String>.from(json["roomMember"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "createdBy": createdBy,
        "roomTitle": roomTitle,
        "description": description,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "dueDate": dueDate,
        "isCompleted": isCompleted,
        "userId": userId,
        "roomMember": roomMember,
        "documentText": documentText,
      };
}
