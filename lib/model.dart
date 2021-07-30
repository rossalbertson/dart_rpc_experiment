library model;

class Name {
  String firstName = "";
  String lastName = "";

  Name(this.firstName, this.lastName);

  @override
  String toString() => '$firstName $lastName';

  Map<String, dynamic> toMap() =>
      {'first_name': firstName, 'last_name': lastName};

  Name.fromMap(Map map) {
    this.firstName = map['first_name'];
    this.lastName = map['last_name'];
  }
}
