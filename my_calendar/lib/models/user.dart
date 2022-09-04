class User {
  final int id;
  final String pass;
  final String name;

  User(this.id, this.name, this.pass);

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'], name = json['name'], pass = json['pass']
       ;

  Map<String, dynamic> toJson() => {
       'id':id,
        'name': name,
        'pass' : pass
      };
       @override
  String toString() => name;
}
