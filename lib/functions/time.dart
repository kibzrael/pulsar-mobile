import 'package:pulsar/universal_variables.dart';

String timeAgo(time) {
  final universalVariables = UniversalVariables();
  final Map<int, String> months = universalVariables.months;
  String response;
  DateTime postedTime =
      time is DateTime ? time : DateTime.parse(time.toString());
  DateTime now = DateTime.now();
  Duration difference = now.difference(postedTime);
  int diffInDays = difference.inDays;
  if (diffInDays < 31) {
    if (diffInDays == 0) {
      int hours = difference.inHours;
      if (hours < 1) {
        int minutes = difference.inMinutes;
        if (minutes < 1) {
          int seconds = difference.inSeconds;
          if (seconds < 1) {
            response = ('now');
          } else {
            response = ('$seconds sec');
          }
        } else {
          response = ('$minutes min');
        }
      } else if (hours == 1) {
        response = ('$hours hr');
      } else {
        response = ('$hours hrs');
      }
    } else if (diffInDays == 1) {
      response = ('Yesterday');
    } else {
      response = ('$diffInDays days');
    }
  } else {
    var year = postedTime.year;
    var month = months[postedTime.month];
    var day = postedTime.day;
    if (now.year == year) {
      response = ('$month $day');
    } else {
      response = ('$month $day $year');
    }
  }

  return response;
}

Map<String, String> timeBirthday(DateTime time) {
  final universalVariables = UniversalVariables();
  final Map<int, String> months = universalVariables.months;
  String birthday;
  String age;
  DateTime postedTime = time;
  DateTime now = DateTime.now();
  Duration difference = now.difference(postedTime);
  int diffInDays = difference.inDays;
  int diffInYears = (diffInDays / 365.25).floor();
  var year = postedTime.year;
  var month = months[postedTime.month];
  var day = postedTime.day;
  birthday = '$month $day $year';
  if (diffInYears == 1) {
    age = ('$diffInYears yr');
  } else {
    age = ('$diffInYears yrs');
  }

  return {'birthday': birthday, 'age': age};
}

String videoDuration(int seconds) {
  int minutes = seconds ~/ 60;
  seconds = seconds - (minutes * 60);

  int hours = minutes ~/ 60;
  minutes = minutes - (hours * 60);
  return '${hours > 0 ? '$hours:' : ''}${(minutes < 10) && (hours > 0) ? '0' : ''}$minutes:${seconds < 10 ? '0' : ''}$seconds';
}

String ffmpegDuration(int milliseconds) {
  int seconds = milliseconds ~/ 1000;
  milliseconds = milliseconds - (seconds * 1000);

  int minutes = seconds ~/ 60;
  seconds = seconds - (minutes * 60);

  int hours = minutes ~/ 60;
  minutes = minutes - (hours * 60);

  String millipad = milliseconds < 10
      ? "00"
      : milliseconds < 100
          ? "0"
          : "";
  return '${hours > 0 ? '$hours:' : ''}${minutes < 10 ? '0' : ''}$minutes:${seconds < 10 ? '0' : ''}$seconds.$millipad$milliseconds';
}
