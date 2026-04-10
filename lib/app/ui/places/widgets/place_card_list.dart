import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:rain/app/controller/controller.dart';
import 'package:rain/app/data/db.dart';
import 'package:rain/app/ui/places/view/place_info.dart';
import 'package:rain/app/ui/places/widgets/place_card.dart';
import 'package:rain/app/ui/widgets/confirmation_dialog.dart';
import 'package:rain/app/utils/navigation_helper.dart';
import 'package:reorderables/reorderables.dart';

class PlaceCardList extends StatefulWidget {
  const PlaceCardList({super.key, required this.searchCity});
  final String searchCity;

  @override
  State<PlaceCardList> createState() => _PlaceCardListState();
}

class _PlaceCardListState extends State<PlaceCardList> {
  final weatherController = Get.put(WeatherController());

  @override
  Widget build(BuildContext context) {
    final weatherCards = _filterWeatherCards(
      weatherController.weatherCards,
      widget.searchCity,
    );

    return CustomScrollView(slivers: [_buildReorderableList(weatherCards)]);
  }

  List<WeatherCard> _filterWeatherCards(
    List<WeatherCard> weatherCards,
    String searchCity,
  ) => weatherCards
      .where(
        (weatherCard) =>
            searchCity.isEmpty ||
            weatherCard.city!.toLowerCase().contains(searchCity),
      )
      .toList();

  Widget _buildReorderableList(List<WeatherCard> weatherCards) {
    return ReorderableSliverList(
      delegate: ReorderableSliverChildBuilderDelegate(
        (context, index) => _buildDismissibleCard(context, weatherCards[index]),
        childCount: weatherCards.length,
      ),
      onReorder: (oldIndex, newIndex) async {
        await weatherController.reorder(oldIndex, newIndex);
      },
    );
  }

  Widget _buildDismissibleCard(BuildContext context, WeatherCard weatherCard) =>
      Dismissible(
        key: ValueKey(weatherCard.id),
        direction: DismissDirection.endToStart,
        background: _buildDismissibleBackground(),
        confirmDismiss: (_) => _showDeleteConfirmationDialog(context),
        onDismissed: (_) async =>
            await weatherController.deleteCardWeather(weatherCard),
        child: _buildCardGestureDetector(context, weatherCard),
      );

  Widget _buildDismissibleBackground() => Container(
    alignment: Alignment.centerRight,
    child: const Padding(
      padding: EdgeInsets.only(right: 15),
      child: Icon(IconsaxPlusLinear.trash_square, color: Colors.red),
    ),
  );

  Future<bool> _showDeleteConfirmationDialog(BuildContext context) =>
      showDeleteConfirmation(
        context: context,
        title: 'deletedCardWeather',
        message: 'deletedCardWeatherQuery',
        onConfirm: () => NavigationHelper.back(result: true),
      );

  Widget _buildCardGestureDetector(
    BuildContext context,
    WeatherCard weatherCard,
  ) => GestureDetector(
    onTap: () => NavigationHelper.toDownToUp(
      () => PlaceInfo(weatherCard: weatherCard),
    ),
    child: PlaceCard(
      time: weatherCard.time!,
      timeDaily: weatherCard.timeDaily!,
      timeDay: weatherCard.sunrise!,
      timeNight: weatherCard.sunset!,
      weather: weatherCard.weathercode!,
      degree: weatherCard.temperature2M!,
      district: weatherCard.district!,
      city: weatherCard.city!,
      timezone: weatherCard.timezone!,
    ),
  );
}
