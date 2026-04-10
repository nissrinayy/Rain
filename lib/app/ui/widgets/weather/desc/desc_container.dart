import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rain/app/ui/widgets/weather/desc/desc.dart';
import 'package:rain/app/ui/widgets/weather/desc/message.dart';
import 'package:rain/app/ui/widgets/weather/status/status_data.dart';

class DescContainer extends StatelessWidget {
  const DescContainer({
    super.key,
    this.humidity,
    this.wind,
    this.visibility,
    this.feels,
    this.evaporation,
    this.precipitation,
    this.direction,
    this.pressure,
    this.rain,
    this.cloudcover,
    this.windgusts,
    this.uvIndex,
    this.dewpoint2M,
    this.precipitationProbability,
    this.shortwaveRadiation,
    this.apparentTemperatureMin,
    this.apparentTemperatureMax,
    this.uvIndexMax,
    this.windDirection10MDominant,
    this.windSpeed10MMax,
    this.windGusts10MMax,
    this.precipitationProbabilityMax,
    this.rainSum,
    this.precipitationSum,
    required this.initiallyExpanded,
    required this.title,
  });

  final int? humidity;
  final double? wind;
  final double? visibility;
  final double? feels;
  final double? evaporation;
  final double? precipitation;
  final int? direction;
  final double? pressure;
  final double? rain;
  final int? cloudcover;
  final double? windgusts;
  final double? uvIndex;
  final double? dewpoint2M;
  final int? precipitationProbability;
  final double? shortwaveRadiation;
  final double? apparentTemperatureMin;
  final double? apparentTemperatureMax;
  final double? uvIndexMax;
  final int? windDirection10MDominant;
  final double? windSpeed10MMax;
  final double? windGusts10MMax;
  final int? precipitationProbabilityMax;
  final double? rainSum;
  final double? precipitationSum;
  final bool initiallyExpanded;
  final String title;

  @override
  Widget build(BuildContext context) {
    final statusData = StatusData();
    final message = Message();

    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      child: ExpansionTile(
        shape: const Border(),
        title: Text(title, style: context.textTheme.labelLarge),
        initiallyExpanded: initiallyExpanded,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 5),
            child: Wrap(
              alignment: WrapAlignment.spaceEvenly,
              spacing: 5,
              children: _buildWeatherDescriptions(context, statusData, message),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildWeatherDescriptions(
    BuildContext context,
    StatusData statusData,
    Message message,
  ) {
    final List<Widget> descriptions = [];

    String addMessageOrDefault(String? message) {
      if (message == null || message.isEmpty || message == 'null') {
        return 'no_desc_data'.tr;
      }
      return message;
    }

    void addDescriptionIfNotNull({
      required dynamic value,
      required String imageName,
      required String desc,
      String? message,
    }) {
      final stringValue = value?.toString();
      if (stringValue != null &&
          stringValue.isNotEmpty &&
          !stringValue.startsWith('null')) {
        descriptions.add(
          DescWeather(
            imageName: imageName,
            value: stringValue,
            desc: desc,
            message: addMessageOrDefault(message),
          ),
        );
      }
    }

    final weatherData = [
      {
        'value': statusData.getDegree(apparentTemperatureMin?.round()),
        'imageName': 'assets/images/cold.png',
        'desc': 'apparentTemperatureMin'.tr,
      },
      {
        'value': statusData.getDegree(apparentTemperatureMax?.round()),
        'imageName': 'assets/images/hot.png',
        'desc': 'apparentTemperatureMax'.tr,
      },
      {
        'value': uvIndexMax?.round(),
        'imageName': 'assets/images/uv.png',
        'desc': 'uvIndex'.tr,
        'message': message.getUvIndex(uvIndexMax?.round()),
      },
      {
        'value': '$windDirection10MDominant°',
        'imageName': 'assets/images/windsock.png',
        'desc': 'direction'.tr,
        'message': message.getDirection(windDirection10MDominant),
      },
      {
        'value': statusData.getSpeed(windSpeed10MMax?.round()),
        'imageName': 'assets/images/wind.png',
        'desc': 'wind'.tr,
      },
      {
        'value': statusData.getSpeed(windGusts10MMax?.round()),
        'imageName': 'assets/images/windgusts.png',
        'desc': 'windgusts'.tr,
      },
      {
        'value': '$precipitationProbabilityMax%',
        'imageName': 'assets/images/precipitation_probability.png',
        'desc': 'precipitationProbability'.tr,
      },
      {
        'value': statusData.getPrecipitation(rainSum),
        'imageName': 'assets/images/water.png',
        'desc': 'rain'.tr,
      },
      {
        'value': statusData.getPrecipitation(precipitationSum),
        'imageName': 'assets/images/rainfall.png',
        'desc': 'precipitation'.tr,
      },
      {
        'value': statusData.getDegree(dewpoint2M?.round()),
        'imageName': 'assets/images/dew.png',
        'desc': 'dewpoint'.tr,
      },
      {
        'value': statusData.getDegree(feels?.round()),
        'imageName': 'assets/images/temperature.png',
        'desc': 'feels'.tr,
      },
      {
        'value': statusData.getVisibility(visibility),
        'imageName': 'assets/images/fog.png',
        'desc': 'visibility'.tr,
      },
      {
        'value': '$direction°',
        'imageName': 'assets/images/windsock.png',
        'desc': 'direction'.tr,
        'message': message.getDirection(direction),
      },
      {
        'value': statusData.getSpeed(wind?.round()),
        'imageName': 'assets/images/wind.png',
        'desc': 'wind'.tr,
      },
      {
        'value': statusData.getSpeed(windgusts?.round()),
        'imageName': 'assets/images/windgusts.png',
        'desc': 'windgusts'.tr,
      },
      {
        'value': statusData.getPrecipitation(evaporation?.abs()),
        'imageName': 'assets/images/evaporation.png',
        'desc': 'evaporation'.tr,
      },
      {
        'value': statusData.getPrecipitation(precipitation),
        'imageName': 'assets/images/rainfall.png',
        'desc': 'precipitation'.tr,
      },
      {
        'value': statusData.getPrecipitation(rain),
        'imageName': 'assets/images/water.png',
        'desc': 'rain'.tr,
      },
      {
        'value': '$precipitationProbability%',
        'imageName': 'assets/images/precipitation_probability.png',
        'desc': 'precipitationProbability'.tr,
      },
      {
        'value': '$humidity%',
        'imageName': 'assets/images/humidity.png',
        'desc': 'humidity'.tr,
      },
      {
        'value': '$cloudcover%',
        'imageName': 'assets/images/cloudy.png',
        'desc': 'cloudcover'.tr,
      },
      {
        'value': statusData.getPressure(pressure?.round()),
        'imageName': 'assets/images/atmospheric.png',
        'desc': 'pressure'.tr,
        'message': message.getPressure(pressure?.round()),
      },
      {
        'value': uvIndex?.round(),
        'imageName': 'assets/images/uv.png',
        'desc': 'uvIndex'.tr,
        'message': message.getUvIndex(uvIndex?.round()),
      },
      {
        'value': '${shortwaveRadiation?.round()} ${'W/m2'.tr}',
        'imageName': 'assets/images/shortwave_radiation.png',
        'desc': 'shortwaveRadiation'.tr,
      },
    ];

    for (var data in weatherData) {
      addDescriptionIfNotNull(
        value: data['value'],
        imageName: '${data['imageName']}',
        desc: '${data['desc']}',
        message: data['message'] as String?,
      );
    }

    return descriptions;
  }
}
