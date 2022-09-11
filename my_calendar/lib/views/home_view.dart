import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:my_calendar/main.dart';
import 'package:my_calendar/models/event.dart';
import 'package:my_calendar/services/auth_service.dart';
import 'package:my_calendar/services/database_service.dart';
import 'package:my_calendar/views/app_bar.dart';
import 'package:my_calendar/views/events/event_view.dart';
import 'package:my_calendar/views/slider/myslider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';

import '../utils/utils.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final PageController _pageController;
  GlobalKey<SliderDrawerState> dKey = GlobalKey<SliderDrawerState>();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  late final ValueNotifier<List<Event>> _selectedEvents;
  List<Event> _allEvents = [];
  List<Event> _dayEvents = [];
  final ValueNotifier<DateTime> _focusedDay = ValueNotifier(DateTime.now());
  final Set<DateTime> _selectedDays = LinkedHashSet<DateTime>(
    equals: isSameDay,
    hashCode: getHashCode,
  );
  DateTime? _selectedDay;
  void _addEvent() {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => EventView(
          eventControllerForDescription: null,
          eventControllerForTitle: null,
          event: null,
        ),
      ),
    );
  }

  Future _getAsyncEventsForDay(DateTime day) async {
    //  Get evens from database service
    // Get user uid from auth service
    final AuthService _auth = AuthService();
    final uid = _auth.getCurrentUserMail();
    _dayEvents = await DatabaseService.getAllUserEvents(uid);
  }

  Future _getAsyncAllEvents() async {
    //  Get evens from database service
    // Get user uid from auth service
    final AuthService _auth = AuthService();
    final uid = _auth.getCurrentUserMail();
    print(uid);

    _allEvents = await DatabaseService.getAllUserEvents(uid);
    print(_allEvents);
  }

  bool get canClearSelection => _selectedDay != null;

  List<Event> _getEventsForDay(DateTime day) {
    //  chech if the day is like the day in the event
    //  if yes add the event to the list
    //  return the list
    final List<Event> events = [];
    for (var event in _allEvents) {
      print("test: ${event.getStartDate}");
      if (isSameDay(event.getStartDate, day)) {
        events.add(event);
      }
    }
    return events;
  }

  List<Event> _getEventsForDays(Iterable<DateTime> days) {
    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      if (_selectedDays.contains(selectedDay)) {
        _selectedDays.remove(selectedDay);
      } else {
        _selectedDays.clear();
        _selectedDays.add(selectedDay);
      }
      _focusedDay.value = focusedDay;
    });
    _selectedEvents.value = _getEventsForDays(_selectedDays);
  }

  @override
  void initState() {
    super.initState();
    _getAsyncAllEvents();
    _selectedDays.add(_focusedDay.value);
    _selectedEvents = ValueNotifier(_getEventsForDay(_focusedDay.value));
    print(_selectedEvents.value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _addEvent,
        tooltip: 'addEvent',
        child: const Icon(Icons.add),
      ),
      body: SliderDrawer(
        isDraggable: false,
        key: dKey,
        animationDuration: 1000,
        // My AppBar
        appBar: MyAppBar(
          drawerKey: dKey,
        ),

        /// My Drawer Slider
        slider: MySlider(
          page: 0,
        ),

        child: Container(
          color: Color.fromARGB(255, 39, 39, 39),

          /// Main Body
          child: Column(children: [
            ValueListenableBuilder<DateTime>(
              valueListenable: _focusedDay,
              builder: (context, value, _) {
                return _CalendarHeader(
                  focusedDay: value,
                  onTodayButtonTap: () {
                    setState(() => _focusedDay.value = DateTime.now());
                  },
                  onLeftArrowTap: () {
                    _pageController.previousPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                  },
                  onRightArrowTap: () {
                    _pageController.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                  },
                );
              },
            ),
            TableCalendar(
              firstDay: kFirstDay,
              lastDay: kLastDay,
              focusedDay: _focusedDay.value,
              calendarFormat: _calendarFormat,
              startingDayOfWeek: StartingDayOfWeek.monday,
              headerVisible: false,
              eventLoader: _getEventsForDay,
              onCalendarCreated: (controller) => _pageController = controller,
              calendarStyle: const CalendarStyle(
                outsideDaysVisible: false,
                weekendTextStyle: TextStyle(color: Colors.red),
              ),
              calendarBuilders: CalendarBuilders(
                dowBuilder: (context, day) {
                  if (day.weekday == DateTime.sunday ||
                      day.weekday == DateTime.saturday) {
                    // format to day of week
                    final text =
                        DateFormat.E().format(DateTime.now()).toString();
                    return Center(
                        child: Text(
                      text,
                      style: TextStyle(color: Colors.red),
                    ));
                  } else {
                    // format to day of week
                    final text =
                        DateFormat.E().format(DateTime.now()).toString();
                    return Center(
                        child: Text(
                      text,
                      style: TextStyle(color: Colors.grey[200]),
                    ));
                  }
                },
                weekNumberBuilder: (context, date) {
                  if (date == DateTime.sunday || date == DateTime.saturday) {
                    // format to day of week
                    final text =
                        DateFormat.E().format(DateTime.now()).toString();
                    return Center(
                      child: Text(
                        text,
                        style: TextStyle(color: Colors.red),
                      ),
                    );
                  }
                },
              ),
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: _onDaySelected,
              onPageChanged: (focusedDay) {
                _focusedDay.value = focusedDay;
              },
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: ValueListenableBuilder<List<Event>>(
                valueListenable: _selectedEvents,
                builder: (context, value, _) {
                  return ListView.builder(
                    itemCount: value.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 4.0,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(),
                        ),
                        child: ListTile(
                          onTap: () {
                            var eventControllerForTitle =
                                TextEditingController();
                            var eventControllerForDescription =
                                TextEditingController();
                            eventControllerForDescription.text =
                                value[index].getDescription;
                            eventControllerForTitle.text =
                                value[index].getTitle;
                            Navigator.of(context)
                                .pushReplacement(MaterialPageRoute(
                                    builder: (context) => EventView(
                                          event: value[index],
                                          eventControllerForTitle:
                                              eventControllerForTitle,
                                          eventControllerForDescription:
                                              eventControllerForDescription,
                                        )));
                          },
                          title: Text('${value[index]}'),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class _CalendarHeader extends StatelessWidget {
  final DateTime focusedDay;
  final VoidCallback onLeftArrowTap;
  final VoidCallback onRightArrowTap;
  final VoidCallback onTodayButtonTap;

  const _CalendarHeader({
    Key? key,
    required this.focusedDay,
    required this.onLeftArrowTap,
    required this.onRightArrowTap,
    required this.onTodayButtonTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final headerText = DateFormat.yMMM().format(focusedDay);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          const SizedBox(width: 16.0),
          SizedBox(
            width: 120.0,
            child: Text(
              headerText,
              style: TextStyle(fontSize: 26.0),
            ),
          ),
          IconButton(
            icon: Icon(Icons.calendar_today, size: 20.0),
            visualDensity: VisualDensity.compact,
            onPressed: onTodayButtonTap,
          ),
          const Spacer(),
          IconButton(
            icon: Icon(Icons.chevron_left),
            onPressed: onLeftArrowTap,
          ),
          IconButton(
            icon: Icon(Icons.chevron_right),
            onPressed: onRightArrowTap,
          ),
        ],
      ),
    );
  }
}
