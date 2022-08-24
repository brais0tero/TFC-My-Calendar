class Event {
  final int id;
  final String title;
  final String description;
  final int id_host;
  final DateTime start_date;
  DateTime ? end_date;

  Event(this.id, this.title, this.description, this.id_host, this.start_date);

  Event.fromJson(Map < String, dynamic > json): id = json['id'], title = json['name'], description = json['description'], id_host = json['id_host'],
    start_date = json['start_date'], end_date = json['end_date'];

  
  Map<String, dynamic> toJson() => {
       'id':id,
        'title': title,
        'description' : description,
        'id_host' : id_host,
        'start_date' : start_date,
        'end_date' : end_date
      };
}