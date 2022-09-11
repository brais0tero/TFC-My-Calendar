import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:my_calendar/models/event.dart';
import 'package:my_calendar/services/auth_service.dart';
import 'package:my_calendar/services/database_service.dart';
import 'package:my_calendar/utils/constanst.dart';
import 'package:my_calendar/views/home_view.dart';

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
  Event? event;

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
        if (widget.event != null) {
          Event? event = widget.event;
          DatabaseService.updateEvent(event!);
          Navigator.of(context).pop();
        }
      } catch (error) {
        nothingEnterOnUpdateEventMode(context);
      }
    } else {
      if (title != null && description != null) {
        // get user uid from firebase auth
        AuthService _auth = AuthService();
        final uid = _auth.getCurrentUserMail();
        // set startdate date time with startdate and starttime
        final startDateTime = DateTime(
            showDateAsDateTime(startDate).year,
            showDateAsDateTime(startDate).month,
            showDateAsDateTime(startDate).day,
            showTimeAsDateTime(startTime).hour,
            showTimeAsDateTime(startTime).minute);
        // create a new Event
        var event = Event(title, description, uid, startDateTime);
        // save event
        // Save event on the database
        DatabaseService.createEvent(event);

        Navigator.of(context).pop();
      } else {
        emptyFieldsWarning(context);
      }
    }
  }

  /// Delete Selected Event
  dynamic deleteEvent() {
    if (widget.event != null) {
      Event? event = widget.event;
      DatabaseService.deleteEvent(event!);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: const CreateBar(),
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  /// new / update Event Text
                  _buildTopText(),

                  /// Middle Two TextFileds, Time And Date Selection Box
                  _buildMiddleTextFieldsANDTimeAndDateSelection(context),

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
                      border: Border.all(width: 2),
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
                    color: Colors.grey[300],
                    child: Row(
                      children: const [
                        Icon(
                          Icons.close,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text("Delete event"),
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
            color: Colors.greenAccent,
            onPressed: () {
              isEventAlreadyExistUpdateEvent();
            },
            child: Text(
              isEventAlreadyExistBool() ? "Add Event" : "Update Event",
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Middle Two TextFileds And Time And Date Selection Box
  SizedBox _buildMiddleTextFieldsANDTimeAndDateSelection(BuildContext context) {
    return SizedBox(
      width: double.infinity,
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
                cursorHeight: 20,
                style: const TextStyle(color: Colors.white, fontSize: 20),
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
                style: const TextStyle(color: Colors.white, fontSize: 20),
                decoration: InputDecoration(
                  prefixIcon:
                      const Icon(Icons.article_outlined, color: Colors.white),
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
                    widget.event!.startDate = DateTime(
                      widget.event!.getStartDate!.year,
                      widget.event!.getStartDate!.month,
                      widget.event!.getStartDate!.day,
                      selectedTime.hour,
                      selectedTime.minute,
                    );
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
                color: Colors.black,
                border: Border.all(color: Colors.grey.shade300, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text("Set start time",
                        style: TextStyle(fontSize: 20, color: Colors.white)),
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
                      child: Text(showTime(startTime),
                          style: TextStyle(
                            color: Colors.black,
                          )),
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
                color: Colors.black,
                border: Border.all(color: Colors.grey.shade300, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text("Set start Date",
                        style:
                            const TextStyle(fontSize: 20, color: Colors.white)),
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
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// new / update Event Text
  SizedBox _buildTopText() {
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
                text: isEventAlreadyExistBool() ? "Add New " : "Update ",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
                children: const [
                  TextSpan(
                    text: "Event",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
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
class CreateBar extends StatelessWidget with PreferredSizeWidget {
  const CreateBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
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
                  size: 25,
                  color: Colors.white,
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
