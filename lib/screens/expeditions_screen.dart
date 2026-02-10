import 'package:flutter/material.dart';
import 'package:nexus_app/data_manager.dart';
import '../constants.dart';
import 'package:table_calendar/table_calendar.dart';
import '../widgets/add_circle_icon_button.dart';
import '../classes/event.dart';
import '../main.dart';
import '../widgets/base_screen_container.dart';

class ExpeditionsScreen extends StatefulWidget {
  @override
  ExpeditionsScreenState createState() => ExpeditionsScreenState();
}

class ExpeditionsScreenState extends State<ExpeditionsScreen> {
  static DateTime _focusedDay = DateTime.now();
  static DateTime? _selectedDay;
  static List<Event> _focusedEvents = [];
  static bool _isLoading = false;

  static List<Event> _getEventsForDay(DateTime day) {
    try {
      if (DataManager.getEvents().isEmpty) return <Event>[];
      return DataManager.getEvents()
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
    _loadEvents();
  }

  void _loadEvents() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await DataManager.loadEvents();
    } catch (e) {
      // Handle error, e.g. show a snackbar
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (AppConstants.isTablet(context)) {
      return BaseScreenContainer(
        child: Row(
          children: [
            // Calendar on the left
            Expanded(
              flex: 2,
              child: TableCalendar(
                calendarBuilders: CalendarBuilders(
                  markerBuilder: (context, date, events) {
                    if (events.isEmpty) return null;
                    return Positioned(
                      bottom: 1,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: events.cast<Event>().take(4).map((event) {
                          return Container(
                            width: 5,
                            height: 5,
                            margin: EdgeInsets.only(left: 1),
                            decoration: BoxDecoration(
                              color: event.maxPlayers > event.currentPlayers
                                  ? AppConstants.successColor
                                  : event.maxSpectators > event.currentSpectators
                                      ? AppConstants.warningColor
                                      : AppConstants.errorColor,
                              shape: BoxShape.circle,
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
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
                    _focusedDay = focusedDay;
                    _focusedEvents = _getEventsForDay(selectedDay);
                  });
                },
                firstDay: DateTime.utc(2010, 10, 16),
                lastDay: DateTime.utc(2030, 3, 14),
                focusedDay: DateTime.now(),
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: AppConstants.todayColor,
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    gradient: AppConstants.selectionBackgroundGradient,
                    shape: BoxShape.circle,
                  ),
                  defaultTextStyle: TextStyle(color: AppConstants.textColor),
                  weekendTextStyle: TextStyle(color: AppConstants.textColor),
                  outsideTextStyle: TextStyle(
                    color: AppConstants.semitransparentTextColor,
                  ),
                  weekNumberTextStyle: TextStyle(color: AppConstants.textColor),
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
            ),
            // Events on the left
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(
                      left: AppConstants.paddingSmall(context),
                      right: AppConstants.paddingSmall(context),
                    ),
                    width: AppConstants.mainContainerWidth(context) * 0.5,
                    height: AppConstants.eventListHeight(context) * 2.7,
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(
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
                                onTap: () async {
                                  NexusAppState.instance!.returnScreenParams.add([]);
                                  NexusAppState.instance!.returnScreenPath.add('Calendar');
                                  NexusAppState.instance!.updateState(
                                    'Event',
                                    params: [await DataManager.getEventById(item.id) ?? item],
                                  );
                                },
                                child: VisualizeEventPreview(event: item),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                  AddCircleIconButton(
                    onPressed: () {
                      NexusAppState.instance!.returnScreenParams.add([]);
                      NexusAppState.instance!.returnScreenPath.add('Calendar');
                      NexusAppState.instance!.updateState('EditEvent', params: []);
                    },
                  ),
                ],
              ),
            ), 
            ],
        ),
      );
    }
    else{
       return BaseScreenContainer(
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          TableCalendar(
                calendarBuilders: CalendarBuilders(
                  markerBuilder: (context, date, events) {
                    if (events.isEmpty) return null;
                    return Positioned(
                      bottom: 1,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: events.cast<Event>().take(4).map((event) {
                          return Container(
                            width: 5,
                            height: 5,
                            margin: EdgeInsets.only(left: 1),
                            decoration: BoxDecoration(
                              color: event.maxPlayers > event.currentPlayers ? AppConstants.successColor : event.maxSpectators > event.currentSpectators ? AppConstants.warningColor : AppConstants.errorColor,
                              shape: BoxShape.circle,
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
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
                    color: AppConstants.todayColor,
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    gradient: AppConstants.selectionBackgroundGradient,
                    shape: BoxShape.circle,
                  ),
                  defaultTextStyle: TextStyle(color: AppConstants.textColor),
                  weekendTextStyle: TextStyle(color: AppConstants.textColor),
                  outsideTextStyle: TextStyle(
                    color: AppConstants.semitransparentTextColor,
                  ),
                  weekNumberTextStyle: TextStyle(color: AppConstants.textColor),
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
                bottom: AppConstants.screenHeight(context, 0.01),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                        left: AppConstants.paddingSmall(context),
                        right: AppConstants.paddingSmall(context),
                      ),
                      width: AppConstants.mainContainerWidth(context),
                      height: AppConstants.eventListHeight(context) * 2,
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
                                  onTap: () async{
                                    NexusAppState.instance!.returnScreenParams
                                        .add([]);
                                    NexusAppState.instance!.returnScreenPath
                                        .add('Calendar');
                                    NexusAppState.instance!.updateState(
                                      'Event',
                                      params: [await DataManager.getEventById(item.id) ?? item],
                                    );
                                  },
                                  child: VisualizeEventPreview(event: item),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                    AddCircleIconButton(
                      onPressed: () {
                        NexusAppState.instance!.returnScreenParams.add([]);
                        NexusAppState.instance!.returnScreenPath.add('Calendar');
                        NexusAppState.instance!.updateState('EditEvent', params: []);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
    );
  
    }
   }
}
