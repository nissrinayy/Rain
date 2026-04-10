import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:rain/app/controller/controller.dart';
import 'package:rain/app/ui/places/widgets/place_card_list.dart';
import 'package:rain/app/ui/widgets/text_form.dart';

class PlaceList extends StatefulWidget {
  const PlaceList({super.key});

  @override
  State<PlaceList> createState() => _PlaceListState();
}

class _PlaceListState extends State<PlaceList> {
  final weatherController = Get.find<WeatherController>();
  final TextEditingController searchTasks = TextEditingController();
  String filter = '';

  @override
  void initState() {
    super.initState();
    applyFilter('');
  }

  void applyFilter(String value) {
    filter = value.toLowerCase();
    setState(() {});
  }

  void clearSearch() {
    searchTasks.clear();
    applyFilter('');
  }

  @override
  Widget build(BuildContext context) => Obx(() => _buildContent(context));

  Widget _buildContent(BuildContext context) {
    if (weatherController.isLoading.isTrue) {
      return _buildLoadingState(context);
    }

    if (weatherController.weatherCards.isEmpty) {
      return _buildEmptyState(context);
    } else {
      return _buildListView(context);
    }
  }

  Widget _buildLoadingState(BuildContext context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircularProgressIndicator(),
        const SizedBox(height: 16),
        Text(
          'loading'.tr,
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    ),
  );

  Widget _buildEmptyState(BuildContext context) => Center(
    child: SingleChildScrollView(
      child: Column(
        children: [
          Image.asset('assets/icons/City.png', scale: 6),
          SizedBox(
            width: Get.size.width * 0.8,
            child: Text(
              'noWeatherCard'.tr,
              textAlign: TextAlign.center,
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    ),
  );

  Widget _buildListView(BuildContext context) => NestedScrollView(
    physics: const NeverScrollableScrollPhysics(),
    headerSliverBuilder: (context, innerBoxIsScrolled) => [
      _buildSearchField(context),
    ],
    body: RefreshIndicator(
      onRefresh: _handleRefresh,
      child: PlaceCardList(searchCity: filter),
    ),
  );

  Widget _buildSearchField(BuildContext context) => SliverToBoxAdapter(
    child: MyTextForm(
      labelText: 'search'.tr,
      type: TextInputType.text,
      icon: const Icon(IconsaxPlusLinear.search_normal_1, size: 20),
      variant: TextFieldVariant.card,
      controller: searchTasks,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      onChanged: applyFilter,
      iconButton: searchTasks.text.isNotEmpty
          ? IconButton(
              onPressed: clearSearch,
              icon: const Icon(
                IconsaxPlusLinear.close_circle,
                color: Colors.grey,
                size: 20,
              ),
            )
          : null,
    ),
  );

  Future<void> _handleRefresh() async {
    await weatherController.updateCacheCard(true);
    setState(() {});
  }
}
