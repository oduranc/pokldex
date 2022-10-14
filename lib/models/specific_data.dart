class SpecificData {
  String? image;
  List<dynamic>? types;
  String? color;

  SpecificData({this.image, this.types, this.color});

  SpecificData.fromJson(img, ty, col) {
    image = img;
    types = ty;
    color = col;
  }
}

class Types {
  int? slot;
  Type? type;

  Types({this.slot, this.type});

  Types.fromJson(Map<String, dynamic> json) {
    slot = json['slot'];
    type = json['type'] != null ? new Type.fromJson(json['type']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['slot'] = this.slot;
    if (this.type != null) {
      data['type'] = this.type!.toJson();
    }
    return data;
  }
}

class Type {
  String? name;
  String? url;

  Type({this.name, this.url});

  Type.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['url'] = this.url;
    return data;
  }
}
