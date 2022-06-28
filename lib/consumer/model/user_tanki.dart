class UserTankiModel {
  String? uid;
  int? tanki_status;

  UserTankiModel({
    this.uid,
    this.tanki_status,
  });

//data from server
  factory UserTankiModel.fromMap(map) {
    return UserTankiModel(
      uid: map['uid'],
      tanki_status: map['tanki_status'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'tanki_status': tanki_status,
    };
  }
}
