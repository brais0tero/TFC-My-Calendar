// Form view with a text field for the event name,2 form input next to each other to set date and time, a text field for the event description, a text field for the event location, a text field for the event participants, a text field for the event color, a button to create the event, a button to cancel the event creation
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';
import 'package:intl/intl.dart';
import 'package:my_calendar/models/event.dart';
import 'package:my_calendar/views/events/event_view.dart';

class EventWidget extends StatefulWidget {
  const EventWidget({Key? key, required this.event}) : super(key: key);

  final Event event;

  @override
  // ignore: library_private_types_in_public_api
  _CreateEventWidget createState() => _CreateEventWidget();
}
class _CreateEventWidget extends State<EventWidget> {
  TextEditingController eventControllerForTitle = TextEditingController();
  TextEditingController eventControllerForDescription = TextEditingController();
  @override
  void initState() {
    super.initState();
    eventControllerForTitle.text = widget.event.getTitle;
    eventControllerForDescription.text = widget.event.getDescription;
  }

  @override
  void dispose() {
    eventControllerForTitle.dispose();
    eventControllerForDescription.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (ctx) => EventView(
              
              eventControllerForTitle: eventControllerForTitle,
              eventControllerForDescription: eventControllerForDescription,
              event: widget.event,
            ),
          ),
        );print("$context");
      },

      /// Main Card
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 600),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

        child: ListTile(
            
            /// title of Event
            title: Padding(
              padding: const EdgeInsets.only(bottom: 5, top: 3),
              child: Text(
                eventControllerForTitle.text,
                style: TextStyle(
                    color:  Colors.black,
                    fontWeight: FontWeight.w500,
                    ),
              ),
            ),

            /// Description of event
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  eventControllerForDescription.text,
                  style: TextStyle(
                    color:   Color.fromARGB(255, 164, 164, 164),
                    fontWeight: FontWeight.w300,
                  ),
                ),

                ///Start Date & Time of Event
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      bottom: 10,
                      top: 10,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat.yMMMMd()
                              .format(widget.event.getStartDate),
                          style: TextStyle(
                              fontSize: 12,
                              color:  Colors.white
                              ),
                        ),
                        Text(
                          DateFormat('hh:mm a')
                              .format(widget.event.getStartDate),
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey),
                        ),
                        Conditional.single(
                          context: context,
                          conditionBuilder: (BuildContext context) =>
                              widget.event.getEndDate != null,
                          widgetBuilder: (BuildContext context) => Text(
                            DateFormat.yMMMMd()
                                .format(widget.event.getEndDate!),
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.white),
                          ),
                          fallbackBuilder: (BuildContext context) =>
                              const SizedBox(),
                        ),           
                      ],
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
