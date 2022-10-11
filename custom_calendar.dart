import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final List<String> dayTitle = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
  var selectedMonth = DateTime.now();
  DateData? currentSelectedDate;

  @override
  Widget build(BuildContext context) {
    final days = AppUtils.getDayByMonth(selectedMonth);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Calendar Text
              const SizedBox(height: 20),
              const Text(
                'Calendar',
                style: TextStyle(
                  fontSize: 25,
                  height: 1,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Text(
                'Plan your week',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              //Calendar Header with month and year text and arrow buttons
              CalendarHeader(
                onLeftClick: () {
                  setState(() {
                    selectedMonth =
                        DateTime(selectedMonth.year, selectedMonth.month - 1);
                  });
                },
                onRightClick: () {
                  setState(() {
                    selectedMonth =
                        DateTime(selectedMonth.year, selectedMonth.month + 1);
                  });
                },
                selectedMonth: selectedMonth,
              ),
              //Custom Calendar with days of week and dates of month in grid view format
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.25),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: dayTitle
                          .map((e) => Text(
                                e,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  //Bold
                                  fontWeight: FontWeight.bold,
                                ),
                              ))
                          .toList(),
                    ),
                    GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        final item = days[index];
                        return CalendarItem(
                          item: item,
                          currentSelectedDate: currentSelectedDate,
                          onTap: () {
                            if (item.prevMonth) {
                              selectedMonth = DateTime(
                                  selectedMonth.year, selectedMonth.month - 1);
                            } else if (item.nextMonth) {
                              selectedMonth = DateTime(
                                  selectedMonth.year, selectedMonth.month + 1);
                            }
                            currentSelectedDate = item;
                            setState(() {});
                          },
                        );
                      },
                      itemCount: days.length,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "What's on ${AppUtils.formatDate(currentSelectedDate?.dateObj ?? DateTime.now())}",
                style: const TextStyle(
                  fontSize: 16,
                  height: 1,
                  fontWeight: FontWeight.w600,
                ),
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final item = currentSelectedDate?.notes[index];
                  if (item == null) {
                    return const SizedBox();
                  }
                  return NoteItem(item: item);
                },
                itemCount: currentSelectedDate?.notes.length ?? 0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NoteItem extends StatelessWidget {
  const NoteItem({
    Key? key,
    required this.item,
  }) : super(key: key);

  final Note item;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.25),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                const SizedBox(height: 5),
                Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    color: item.color.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ],
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    AppUtils.formatTime(item.date),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    decoration: BoxDecoration(
                      color: item.color.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      "Work",
                      style: TextStyle(
                        fontSize: 12,
                        color: item.color,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}

class CalendarItem extends StatelessWidget {
  const CalendarItem({
    super.key,
    required this.item,
    required this.currentSelectedDate,
    required this.onTap,
  });
  final DateData item;
  final DateData? currentSelectedDate;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: currentSelectedDate?.dateObj == item.dateObj
              ? const Color(0xFF6c5ce7).withOpacity(0.25)
              : Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Opacity(
              opacity: item.notes.isNotEmpty ? 1 : 0,
              child: Container(
                height: 5,
                width: 5,
                decoration: const BoxDecoration(
                  color: Color(0xFF6c5ce7),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Text(
              item.day.toString(),
              style: TextStyle(
                fontSize: 14,
                color: (item.prevMonth || item.nextMonth)
                    ? Colors.grey
                    : Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class CalendarHeader extends StatelessWidget {
  const CalendarHeader({
    super.key,
    required this.onLeftClick,
    required this.onRightClick,
    required this.selectedMonth,
  });

  final VoidCallback onLeftClick;
  final VoidCallback onRightClick;
  final DateTime selectedMonth;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon:
                const Icon(Icons.arrow_back_ios, color: Colors.white, size: 16),
            onPressed: onLeftClick,
          ),
          Expanded(
              child: Text(
            AppUtils.formatMonth(selectedMonth),
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          )),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios,
                color: Colors.white, size: 16),
            onPressed: onRightClick,
          ),
        ],
      ),
    );
  }
}

class DateData {
  final DateTime dateObj;
  final bool selected;
  final bool prevMonth;
  final bool nextMonth;
  final String day;
  final List<Note> notes;

  DateData({
    required this.dateObj,
    this.notes = const [],
    this.selected = false,
    this.prevMonth = false,
    this.nextMonth = false,
    required this.day,
  });
}

class Note {
  final String title;
  final String description;
  final DateTime date;
  final Color color;

  Note({
    required this.title,
    required this.description,
    required this.date,
    required this.color,
  });
}

class AppUtils {
  static String formatTime(DateTime date) {
    return DateFormat('hh:mm').format(date);
  }

  static List<DateData> getDayByMonth(DateTime date) {
    //Get Number of days
    final int daysInMonth = DateTime(date.year, date.month + 1, 0).day;

    //Get the day
    final int firstDayOfMonth = DateTime(date.year, date.month, 1).weekday;

    //Get Previous last firstDayOfMonth days
    final int previousMonthDays = DateTime(date.year, date.month, 0).day;
    final prevLastDate = previousMonthDays - firstDayOfMonth + 1;
    final result = <DateData>[];
    //Add Previous Month Days
    for (var i = prevLastDate; i <= previousMonthDays; i++) {
      result.add(
        DateData(
          dateObj: DateTime(date.year, date.month - 1, i),
          day: "$i",
          prevMonth: true,
        ),
      );
    }

    for (var i = 1; i <= daysInMonth; i++) {
      bool randomBool = Random().nextBool() && Random().nextBool();
      result.add(
        DateData(
          dateObj: DateTime(date.year, date.month, i),
          day: "$i",
          notes: randomBool
              ? [
                  Note(
                    title: "Tutuor Jamie",
                    description: "Description",
                    date: DateTime.now(),
                    color: Colors
                        .primaries[Random().nextInt(Colors.primaries.length)],
                  ),
                  Note(
                    title: "Lunch with Kim",
                    description: "Description",
                    date: DateTime.now(),
                    color: Colors
                        .primaries[Random().nextInt(Colors.primaries.length)],
                  ),
                ]
              : [],
        ),
      );
    }

    int lastDayOfMonth = DateTime(date.year, date.month + 1, 0).weekday + 1;
    if (lastDayOfMonth > 7) {
      lastDayOfMonth = 1;
    }
    final int nextMonthDays = 7 - lastDayOfMonth;

    for (var i = 1; i <= nextMonthDays; i++) {
      result.add(
        DateData(
          dateObj: DateTime(date.year, date.month + 1, i),
          day: "$i",
          nextMonth: true,
        ),
      );
    }
    return result;
  }

  static String formatMonth(DateTime date) {
    final DateFormat formatter = DateFormat('MMMM yyyy');
    final String formatted = formatter.format(date);
    return formatted;
  }

  static String formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('dd MMMM');
    final String formatted = formatter.format(date);
    return formatted;
  }
}
