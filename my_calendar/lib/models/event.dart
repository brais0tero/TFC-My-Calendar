class Event {
  final int id;
  final String title;
  final String description;
  final int idHost;
  final DateTime startDate;
  DateTime ? endDate;

  Event(this.id, this.title, this.description, this.idHost, this.startDate);

  Event.fromJson(Map < String, dynamic > json): id = json['id'], title = json['name'], description = json['description'], idHost = json['idHost'],
    startDate = json['startDate'], endDate = json['endDate'];

  
  Map<String, dynamic> toJson() => {
       'id':id,
        'title': title,
        'description' : description,
        'idHost' : idHost,
        'startDate' : startDate,
        'endDate' : endDate
      };

       @override
  String toString() => title;
}