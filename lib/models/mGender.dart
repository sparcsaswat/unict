class MGender {
  String id;
  String name;
  String createdBy;
  String updatedBy;
  String ip;

  MGender(
      {this.id,
      this.name,
      this.createdBy,
      this.updatedBy,
      this.ip});

  MGender.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        name = json['name'],
        createdBy = json['created_by'],
        updatedBy = json['upated_by'],
        ip = json['ip'];

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'craeted_by': createdBy,
        'updated_by': updatedBy,
        'ip': ip
      };
}