class Event {
String ? _id;
String _title;
 String _description;
String _idHost;
 DateTime _startDate;
DateTime ? _endDate;

Event(this._title, this._description, this._idHost, this._startDate);

Event.fromJson(Map < String, dynamic> json): _id = json['id'], _title = json['title'], _description = json['description'],
  _idHost = json['idHost'],
  _startDate = json['startDate'], _endDate = json['endDate'];
  // getter and setters
  String? get getId => _id;
  String get getTitle => _title;
  String get getDescription => _description;
  String get getIdHost => _idHost;
  DateTime get getStartDate => _startDate;
  DateTime ? get getEndDate => _endDate;

  set id(String id) => this._id = id;
  set title(String title) => this._title = title;
  set description(String description) => this._description = description;
  set idHost(String idHost) => this._idHost = idHost;
  set startDate(DateTime startDate) => this._startDate = startDate;
  set endDate(DateTime ? endDate) => this._endDate = endDate;


  Map<String, dynamic> toJson() => {
    'id':_id,
    'title': _title,
    'description' : _description,
    'idHost' : _idHost,
    'startDate' : _startDate,
    'endDate' : _endDate
    };


    @override
    String toString() => _title;
    }