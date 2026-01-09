import 'package:flutter/material.dart';
import '../constants.dart';
import 'package:table_calendar/table_calendar.dart';
import '../classes/event.dart';
import '../main.dart';
import '../classes/user.dart';

class ExpeditionsScreen extends StatefulWidget {
  @override
  ExpeditionsScreenState createState() => ExpeditionsScreenState();
}

class ExpeditionsScreenState extends State<ExpeditionsScreen> {
  static CalendarFormat _calendarFormat = CalendarFormat.month;
  static DateTime _focusedDay = DateTime.now();
  static DateTime? _selectedDay;
  static List<Event> _focusedEvents = [];

  // Inline details state
  static Event? _activeEvent;
  static bool _showingEventDetails = false;
  static List<Event> _getEventsForDay(DateTime day) {
    try {
      if (NexusAppState.instance!.events.isEmpty) return <Event>[];
      return NexusAppState.instance!.events.where((event) => isSameDay(event.date, day)).toList();
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
      padding: EdgeInsets.only(
        left: AppConstants.paddingSmall(context),
        right: AppConstants.paddingSmall(context),
        bottom: 0.0,
        top: AppConstants.paddingLarge(context)*3.5,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
                  Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    // Background container
                    Container(
                      alignment: Alignment.topCenter,
                      width: AppConstants.mainContainerWidth(context),
                      height: AppConstants.mainContainerHeight(context),
                      decoration: BoxDecoration(
                        color: AppConstants.primaryColor,
                        borderRadius: BorderRadius.circular(
                          AppConstants.borderRadiusMedium(context),
                        ),
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
                        defaultTextStyle: TextStyle(
                          color: AppConstants.textColor,
                        ),
                        weekendTextStyle: TextStyle(
                          color: AppConstants.textColor,
                        ),
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
                          fontSize: AppConstants.fontSizeLargeResponsive(context),
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
                      width: AppConstants.mainContainerWidth(context),
                      bottom: AppConstants.screenHeight(
                        context,
                        0.01,
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: AppConstants.paddingSmall(context), right: AppConstants.paddingSmall(context)),
                            width: AppConstants.mainContainerWidth(context),
                            height: AppConstants.eventListHeight(context)*2,
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
                                    .map(
                                      (item) => InkWell(
                                        onTap: () {
                                          NexusAppState.instance!.returnScreenParams.add([]);
                                          NexusAppState.instance!.returnScreenPath.add('Calendar');
                                          NexusAppState.instance!.updateState(
                                            'Event',
                                            params: [item],
                                          );
                                        },
                                        child: VisualizeEventPreview(event: item),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ),
                          Container(
                            height: AppConstants.iconSizeLarge(context)*1.1,
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                      onPressed: () {
                        NexusAppState.instance!.returnScreenParams.add([]);
                        NexusAppState.instance!.returnScreenPath.add('Calendar');
                        NexusAppState.instance!.updateState(
                          'EditEvent',
                          params: [],
                        );
                      },

                      icon: Icon(
                        Icons.add_circle,
                        color: AppConstants.accentColor2,
                        size: AppConstants.iconSizeLarge(context),
                        
                      ),
                    )
                    )
        
                        ],
                      ),
                    ),
                  ],
                ),
                  ],
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
