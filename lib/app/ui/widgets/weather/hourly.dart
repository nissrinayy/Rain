import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rain/app/ui/widgets/weather/status/status_data.dart';
import 'package:rain/app/ui/widgets/weather/status/status_weather.dart';
import 'package:rain/main.dart';

class Hourly extends StatelessWidget {
  const Hourly({
    super.key,
    required this.time,
    required this.weather,
    required this.degree,
    required this.timeDay,
    required this.timeNight,
  });

  final String time;
  final String timeDay;
  final String timeNight;
  final int weather;
  final double degree;

  @override
  Widget build(BuildContext context) {
    final statusWeather = StatusWeather();
    final statusData = StatusData();
    final textTheme = context.textTheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildTimeText(textTheme, statusData),
        _buildWeatherImage(statusWeather),
        _buildTemperatureText(textTheme, statusData),
      ],
    );
  }

  Widget _buildTimeText(TextTheme textTheme, StatusData statusData) {
    final parsedTime = DateTime.tryParse(time);

    return Column(
      children: [
        Text(statusData.getTimeFormat(time), style: textTheme.labelLarge),
        if (parsedTime != null)
          Text(
            DateFormat('E', locale.languageCode).format(parsedTime),
            style: textTheme.labelLarge?.copyWith(
              color: textTheme.bodySmall?.color,
            ),
          ),
      ],
    );
  }

  Widget _buildWeatherImage(StatusWeather statusWeather) => Image.asset(
    statusWeather.getImageToday(weather, time, timeDay, timeNight),
    scale: 3,
  );

  Widget _buildTemperatureText(TextTheme textTheme, StatusData statusData) =>
      Text(
        statusData.getDegree(degree.round()),
        style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      );
}
