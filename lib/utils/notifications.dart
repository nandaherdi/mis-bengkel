import 'package:awesome_notifications/awesome_notifications.dart';

//import 'utilities.dart';
//import 'package:pengingat_pelanggan_app/notification/utilities.dart';

Future<void> createServiceReminderNotification(
    id, remindDate, sparePart) async {
  //String ?? summaryDate;
  String ?? remindDate;
  int ?? id;
  String ?? sparePart;
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      summary: remindDate,
      id: id,
      channelKey: 'scheduled_reminder_channel',
      title: 'Ayo ganti sparepart',
      body: '$sparePart kamu sudah harus diganti',
      // bigPicture: 'resource://drawable/tunas_logo.png',
      notificationLayout: NotificationLayout.Default,
    ),
    actionButtons: [
      NotificationActionButton(key: 'mark_done', label: 'dismiss')
    ],
    // schedule: NotificationCalendar(
    //   weekday: notificationSchedule.dayOfTheWeek,
    //   hour: notificationSchedule.timeOfDay.hour,
    //   minute: notificationSchedule.timeOfDay.minute,
    //   second: 0,
    //   millisecond: 0,
    // ),
    schedule: NotificationCalendar.fromDate(date: DateTime.parse(remindDate)),
  );
}
