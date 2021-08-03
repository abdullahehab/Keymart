class AddressDeliveryModel {
  AddressDeliveryModel({
    this.id,
    this.userId,
    this.address,
    this.createdAt,
    this.updatedAt,
    this.street,
    this.buildingName,
    this.buildingNumber,
    this.roundNumber,
    this.famousPlace,
    this.phone,
  });

  dynamic id;
  dynamic userId;
  dynamic address;
  dynamic createdAt;
  dynamic updatedAt;
  dynamic street;
  dynamic buildingName;
  dynamic buildingNumber;
  dynamic roundNumber;
  dynamic famousPlace;
  dynamic phone;

  factory AddressDeliveryModel.fromJson(Map<String, dynamic> json) =>
      AddressDeliveryModel(
        id: json["id"] == null ? null : json["id"],
        userId: json["user_id"] == null ? null : json["user_id"],
        address: json["address"] == null ? null : json["address"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"],
        street: json["street"] == null ? null : json["street"],
        buildingName:
            json["building_name"] == null ? null : json["building_name"],
        buildingNumber:
            json["building_number"] == null ? null : json["building_number"],
        roundNumber: json["round_number"] == null ? null : json["round_number"],
        famousPlace: json["famous_place"] == null ? null : json["famous_place"],
        phone: json["phone"] == null ? null : json["phone"],
      );

  Map<String, dynamic> toJson() => {
        "address": address == "" ? "" : address,
        "street": street == "" ? "" : street,
        "building_name": buildingName == "" ? "" : buildingName,
        "building_number": buildingNumber == "" ? "" : buildingNumber,
        "round_number": roundNumber == "" ? "" : roundNumber,
        "famous_place": famousPlace == "" ? "" : famousPlace,
        "phone": phone == "" ? "" : phone,
      };
}
