import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:my_calendar/models/event.dart';
import 'package:my_calendar/utils/constanst.dart';

// ignore: must_be_immutable
class EventView extends StatefulWidget {
  EventView({
    Key? key,
    required this.eventControllerForTitle,
    required this.eventControllerForDescription,
    required this.event,
  }) : super(key: key);

  TextEditingController? eventControllerForTitle;
  TextEditingController? eventControllerForDescription;
  final Event? event;

  @override
  State<EventView> createState() => _EventViewState();
}

class _EventViewState extends State<EventView> {
  var title;
  var description;
  DateTime? startTime;
  DateTime? startDate;

  /// Show Selected Time As String Format
  String showTime(DateTime? startTime) {
    if (widget.event?.getStartDate == null) {
      if (startTime == null) {
        return DateFormat('hh:mm a').format(DateTime.now()).toString();
      } else {
        return DateFormat('hh:mm a').format(startTime).toString();
      }
    } else {
      return DateFormat('hh:mm a')
          .format(widget.event!.getStartDate)
          .toString();
    }
  }

  /// Show Selected Time As DateTime Format
  DateTime showTimeAsDateTime(DateTime? startTime) {
    if (widget.event?.getStartDate == null) {
      if (startTime == null) {
        return DateTime.now();
      } else {
        return startTime;
      }
    } else {
      return widget.event!.getStartDate;
    }
  }

  /// Show Selected Date As String Format
  String showDate(DateTime? startDate) {
    if (widget.event?.getStartDate == null) {
      if (startDate == null) {
        return DateFormat.yMMMEd().format(DateTime.now()).toString();
      } else {
        return DateFormat.yMMMEd().format(startDate).toString();
      }
    } else {
      return DateFormat.yMMMEd().format(widget.event!.getStartDate).toString();
    }
  }

  // Show Selected Date As DateTime Format
  DateTime showDateAsDateTime(DateTime? startDate) {
    if (widget.event?.getStartDate == null) {
      if (startDate == null) {
        return DateTime.now();
      } else {
        return startDate;
      }
    } else {
      return widget.event!.getStartDate;
    }
  }

  /// If any Event Already exist return TRUE otherWise FALSE
  bool isEventAlreadyExistBool() {
    if (widget.eventControllerForTitle?.text == null &&
        widget.eventControllerForDescription?.text == null) {
      return true;
    } else {
      return false;
    }
  }

  /// If any event already exist app will update it otherwise the app will add a new event
  dynamic isEventAlreadyExistUpdateEvent() {
    if (widget.eventControllerForTitle?.text != null &&
        widget.eventControllerForDescription?.text != null) {
      try {
        widget.eventControllerForTitle?.text = title;
        widget.eventControllerForDescription?.text = description;

        Navigator.of(context).pop();
      } catch (error) {
        nothingEnterOnUpdateEventMode(context);
      }
    } else {
      if (title != null && description != null) {
        // get user uid from firebase auth
        final user = FirebaseAuth.instance.currentUser;
        final uid = user!.uid;
        // set startdate date time with startdate and starttime
        final startDateTime = DateTime(
            showDateAsDateTime(startDate).year,
            showDateAsDateTime(startDate).month,
            showDateAsDateTime(startDate).day,
            showTimeAsDateTime(startTime).hour,
            showTimeAsDateTime(startTime).minute); 

        // create a mew Event
        var event = Event(
          title,
          description,
          uid,
          startDateTime
        );
        // save event
        
        Navigator.of(context).pop();
      } else {
        emptyFieldsWarning(context);
      }
    }
  }

  /// Delete Selected Event
  dynamic deleteEvent() {
    
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: const MyAppBar(),
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  /// new / update Event Text
                  _buildTopText(textTheme),

                  /// Middle Two TextFileds, Time And Date Selection Box
                  _buildMiddleTextFieldsANDTimeAndDateSelection(
                      context, textTheme),

                  /// All Bottom Buttons
                  _buildBottomButtons(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// All Bottom Buttons
  Padding _buildBottomButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: isEventAlreadyExistBool()
            ? MainAxisAlignment.center
            : MainAxisAlignment.spaceEvenly,
        children: [
          isEventAlreadyExistBool()
              ? Container()

              /// Delete Event Button
              : Container(
                  width: 150,
                  height: 55,
                  decoration: BoxDecoration(
                      border:
                          Border.all( width: 2),
                      borderRadius: BorderRadius.circular(15)),
                  child: MaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    minWidth: 150,
                    height: 55,
                    onPressed: () {
                      deleteEvent();
                      Navigator.pop(context);
                    },
                    color: Colors.white,
                    child: Row(
                      children: const [
                        Icon(
                          Icons.close,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                        "Delete event"
                        ),
                      ],
                    ),
                  ),
                ),

          /// Add or Update Event Button
          MaterialButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            minWidth: 150,
            height: 55,
            onPressed: () {
              isEventAlreadyExistUpdateEvent();
            },
            child: Text(
              isEventAlreadyExistBool()
                  ? "Add Event"
                  : "Update Event",
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Middle Two TextFileds And Time And Date Selection Box
  SizedBox _buildMiddleTextFieldsANDTimeAndDateSelection(
      BuildContext context, TextTheme textTheme) {
    return SizedBox(
      width: double.infinity,
      height: 535,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Title of TextFiled
          const Padding(
            padding: EdgeInsets.only(left: 30),
            child: Text("Add Your event"),
          ),

          /// Title TextField
          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: ListTile(
              title: TextFormField(
                controller: widget.eventControllerForTitle,
                maxLines: 6,
                cursorHeight: 60,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                onFieldSubmitted: (value) {
                  title = value;
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                onChanged: (value) {
                  title = value;
                },
              ),
            ),
          ),

          const SizedBox(
            height: 10,
          ),

          /// Note TextField
          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: ListTile(
              title: TextFormField(
                controller: widget.eventControllerForDescription,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.bookmark_border, color: Colors.grey),
                  border: InputBorder.none,
                  counter: Container(),
                  hintText: "Add description",
                ),
                onFieldSubmitted: (value) {
                  description = value;
                },
                onChanged: (value) {
                  description = value;
                },
              ),
            ),
          ),

          /// Time Picker
          GestureDetector(
            onTap: () {
              DatePicker.showTimePicker(context,
                  showTitleActions: true,
                  showSecondsColumn: false,
                  onChanged: (_) {}, onConfirm: (selectedTime) {
                setState(() {
                  if (widget.event?.getStartDate == null) {
                  startTime = selectedTime;
                  } else {
                    // widget.event!.startDate add selevtedTime
                      widget.event!.startDate = DateTime(
                      widget.event!.getStartDate!.year,
                      widget.event!.getStartDate!.month,
                      widget.event!.getStartDate!.day,
                      selectedTime.hour,
                      selectedTime.minute,
                    );
                    // widget.event!.startDate. selectedTime;
                  }
                });

                FocusManager.instance.primaryFocus?.unfocus();
              }, currentTime: showTimeAsDateTime(startTime));
            },
            child: Container(
              margin: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              width: double.infinity,
              height: 55,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child:
                        Text("Set start time", style: textTheme.headline5),
                  ),
                  Expanded(child: Container()),
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    width: 80,
                    height: 35,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.shade100),
                    child: Center(
                      child: Text(
                        showTime(startTime),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),

          /// Date Picker
          GestureDetector(
            onTap: () {
              DatePicker.showDatePicker(context,
                  showTitleActions: true,
                  minTime: DateTime.now(),
                  maxTime: DateTime(2030, 3, 5),
                  onChanged: (_) {}, onConfirm: (selectedDate) {
                setState(() {
                  if (widget.event?.getStartDate == null) {
                    startDate = selectedDate;
                  } else {
                    widget.event!.startDate = selectedDate;
                  }
                });
                FocusManager.instance.primaryFocus?.unfocus();
              }, currentTime: showDateAsDateTime(startDate));
            },
            child: Container(
              margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              width: double.infinity,
              height: 55,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child:
                        Text("Start date", style: textTheme.headline5),
                  ),
                  Expanded(child: Container()),
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    width: 140,
                    height: 35,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.shade100),
                    child: Center(
                      child: Text(
                        showDate(startDate),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  /// new / update Event Text
  SizedBox _buildTopText(TextTheme textTheme) {
    return SizedBox(
      width: double.infinity,
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            width: 70,
            child: Divider(
              thickness: 2,
            ),
          ),
          RichText(
            text: TextSpan(
                text: isEventAlreadyExistBool()
                    ? "Add New "
                    : "Update ",
                style: textTheme.headline6,
                children: const [
                  TextSpan(
                    text: "Event",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ]),
          ),
          const SizedBox(
            width: 70,
            child: Divider(
              thickness: 2,
            ),
          ),
        ],
      ),
    );
  }
}

/// AppBar
class MyAppBar extends StatelessWidget with PreferredSizeWidget {
  const MyAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 150,
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 50,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}
