import 'package:flutter/material.dart';
import '../constants.dart';
import 'package:table_calendar/table_calendar.dart';
import '../classes/event.dart';
import '../main.dart';

class ExpeditionsScreen extends StatefulWidget {
  @override
  ExpeditionsScreenState createState() => ExpeditionsScreenState();
}

class ExpeditionsScreenState extends State<ExpeditionsScreen> {
  static CalendarFormat _calendarFormat = CalendarFormat.month;
  static DateTime _focusedDay = DateTime.now();
  static DateTime? _selectedDay;
  static List<Event> _events = [
    new Event(
      id: "1",
      title: "Sample Event",
      author: "Sample Author",
      description: "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaabbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb",
      date: DateTime.now(),
      maxPlayers: 10,
      maxSpectators: 10,
    ),
  ];
  static List<Event> _focusedEvents = [];

  // Inline details state
  static Event? _activeEvent;
  static bool _showingEventDetails = false;
  static List<Event> _getEventsForDay(DateTime day) {
    try {
      if (_events.isEmpty) return <Event>[];
      return _events
          .where((event) => isSameDay(event.date, day))
          .toList();
    } catch (_) {
      return <Event>[];
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _focusedEvents = _getEventsForDay(_selectedDay!);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 8.0,
        right: 8.0,
        bottom: 0.0,
        top: 20.0,
      ),
      child: Center(
        child: Column(
          children: [
            _showingEventDetails && _activeEvent != null
                ? VisualizeEventScreen.buildFullDetails(_activeEvent!)
                : Stack(
                    children: [
                // Background container
                Container(
                  width: 600,
                  height: 600,
                  decoration: BoxDecoration(
                    color: AppConstants.primaryColor,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
                TableCalendar(
                  eventLoader: (day) {
                    try {
                      return _getEventsForDay(day);
                    } catch (_) {
                      return <Event>[];
                    }
                  },
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay =
                          focusedDay; // update `_focusedDay` here as well
                      _focusedEvents = _getEventsForDay(selectedDay);
                    });
                  },
                  firstDay: DateTime.utc(2010, 10, 16),
                  lastDay: DateTime.utc(2030, 3, 14),
                  focusedDay: DateTime.now(),
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      gradient: AppConstants.todayGradient,
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: AppConstants.selectedDayColor,
                      shape: BoxShape.circle,
                    ),
                    defaultTextStyle: TextStyle(color: AppConstants.textColor),
                    weekendTextStyle: TextStyle(color: AppConstants.textColor),
                    outsideTextStyle: TextStyle(
                      color: AppConstants.semitransparentTextColor,
                    ),
                    weekNumberTextStyle: TextStyle(
                      color: AppConstants.textColor,
                    ),
                  ),
                  headerStyle: HeaderStyle(
                    titleTextStyle: TextStyle(
                      color: AppConstants.textColor,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                    formatButtonVisible: false,
                    leftChevronIcon: Icon(
                      Icons.chevron_left,
                      color: AppConstants.textColor,
                    ),
                    rightChevronIcon: Icon(
                      Icons.chevron_right,
                      color: AppConstants.textColor,
                    ),
                  ),
                ),
                // Events list positioned below the calendar
                Positioned(
                  bottom: 100,
                  left: 0,
                  right: 0,
                  child: Container(
                    width: 600,
                    height: 150,
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: AppConstants.semitransparentTextColor,
                          width: 1.0,
                        ),
                      ),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: _focusedEvents
                            .map((item) => InkWell(
                                  onTap: () {
                                    NexusAppState.instance!.updateState('Event', params: [item]);
                                  },
                                  child: VisualizeEventPreview(event: item),
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  // Full details view that substitutes the calendar area
}

/*class _CalendarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}*/
