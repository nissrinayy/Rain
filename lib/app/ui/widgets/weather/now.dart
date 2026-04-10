import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rain/app/ui/widgets/weather/status/status_data.dart';
import 'package:rain/app/ui/widgets/weather/status/status_weather.dart';
import 'package:rain/main.dart';

class Now extends StatelessWidget {
  const Now({
    super.key,
    required this.weather,
    required this.degree,
    required this.time,
    required this.timeDay,
    required this.timeNight,
    required this.tempMax,
    required this.tempMin,
    required this.feels,
  });

  final String time;
  final String timeDay;
  final String timeNight;
  final int weather;
  final double degree;
  final double tempMax;
  final double tempMin;
  final double feels;

  @override
  Widget build(BuildContext context) => largeElement
      ? _buildLargeElementLayout(context)
      : _buildCompactElementLayout(context);

  Widget _buildLargeElementLayout(BuildContext context) {
    final statusWeather = StatusWeather();

    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Gap(15),
          _buildWeatherImage(statusWeather, 200),
          _buildTemperatureText(context, degree, 90),
          Text(
            statusWeather.getText(weather),
            style: context.textTheme.titleLarge,
          ),
          const Gap(5),
          _buildDateText(context),
        ],
      ),
    );
  }

  Widget _buildCompactElementLayout(BuildContext context) {
    final statusWeather = StatusWeather();
    final statusData = StatusData();

    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      child: Padding(
        padding: const EdgeInsets.only(
          top: 18,
          bottom: 18,
          left: 25,
          right: 15,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDateText(context),
                  const Gap(5),
                  Text(
                    statusWeather.getText(weather),
                    style: context.textTheme.titleLarge?.copyWith(fontSize: 20),
                  ),
                  _buildFeelsLikeText(context, statusData),
                  const Gap(30),
                  _buildTemperatureCompactText(context, statusData),
                  const Gap(5),
                  _buildMinMaxTemperatureText(context, statusData),
                ],
              ),
            ),
            _buildWeatherImage(statusWeather, 140),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherImage(StatusWeather statusWeather, double height) =>
      Image(
        image: AssetImage(
          statusWeather.getImageNow(weather, time, timeDay, timeNight),
        ),
        fit: BoxFit.fill,
        height: height,
      );

  Widget _buildTemperatureText(
    BuildContext context,
    double degree,
    double? fontSize,
  ) => Text(
    '${roundDegree ? degree.round() : degree}',
    style: context.textTheme.displayLarge?.copyWith(
      fontSize: fontSize,
      fontWeight: FontWeight.w800,
      shadows: const [Shadow(blurRadius: 15, offset: Offset(5, 5))],
    ),
  );

  Widget _buildTemperatureCompactText(
    BuildContext context,
    StatusData statusData,
  ) => Text(
    statusData.getDegree(roundDegree ? degree.round() : degree),
    style: context.textTheme.displayMedium?.copyWith(
      fontWeight: FontWeight.w800,
    ),
  );

  Widget _buildDateText(BuildContext context) {
    final parsedTime = DateTime.tryParse(time);
    if (parsedTime == null) {
      return const SizedBox.shrink();
    }

    return Text(
      DateFormat.MMMMEEEEd(locale.languageCode).format(parsedTime),
      style: context.textTheme.labelLarge?.copyWith(
        color: context.theme.colorScheme.onSurfaceVariant,
      ),
    );
  }

  Widget _buildFeelsLikeText(BuildContext context, StatusData statusData) =>
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('feels'.tr, style: context.textTheme.bodyMedium),
          Text(' • ', style: context.textTheme.bodyMedium),
          Text(
            statusData.getDegree(feels.round()),
            style: context.textTheme.bodyMedium,
          ),
        ],
      );

  Widget _buildMinMaxTemperatureText(
    BuildContext context,
    StatusData statusData,
  ) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        statusData.getDegree(tempMax.round()),
        style: context.textTheme.labelLarge,
      ),
      Text(' / ', style: context.textTheme.labelLarge),
      Text(
        statusData.getDegree(tempMin.round()),
        style: context.textTheme.labelLarge,
      ),
    ],
  );
}
