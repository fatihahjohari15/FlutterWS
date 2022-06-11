class Tutor {
  String? tutorID;
  String? tutorEmail;
  String? tutorPhone;
  String? tutorName;
  String? tutorDescription;
  String? tutordateReg;

  Tutor(
      {this.tutorID,
      this.tutorEmail,
      this.tutorPhone,
      this.tutorName,
      this.tutorDescription,
      this.tutordateReg});

  Tutor.fromJson(Map<String, dynamic> json) {
    tutorID = json['tutor_id'];
    tutorEmail = json['tutor_email'];
    tutorPhone = json['tutor_phone'];
    tutorName = json['tutor_name'];
    tutorDescription = json['tutor_description'];
    tutordateReg = json['tutor_datereg'];
  }

  get tutorPhoneNumber => null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tutor_id'] = tutorID;
    data['tutor_email'] = tutorEmail;
    data['tutor_phone'] = tutorPhone;
    data['tutor_name'] = tutorName;
    data['tutor_description'] = tutorDescription;
    data['tutor_datereg'] = tutordateReg;
    return data;
  }
}
