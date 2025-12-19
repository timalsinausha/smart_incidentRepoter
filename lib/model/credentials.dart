class Credential {
  String? name;
  String? email;
  String? password;
  String? id;
  String? imageUrl; 

  Credential({
    this.name,
    this.email,
    this.password,
    this.id,
    this.imageUrl, 
  });


  Credential.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    password = json['password'];
    id = json['id'];
    imageUrl = json['imageUrl']; 
  }

 
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['email'] = email;
    data['password'] = password;
    data['id'] = id;
    if (imageUrl != null) {
      data['imageUrl'] = imageUrl; 
    }
    return data;
  }
}
