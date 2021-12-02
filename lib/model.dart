class StudentModel {
   int? id;
   String name;
  String address;

  StudentModel({ this.id,required this.name,required this.address});

  factory StudentModel.fromMap(Map<String, dynamic> json) => StudentModel(
        id: json["id"],
        name: json["name"],
        address: json["address"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "address": address,
      };
}
