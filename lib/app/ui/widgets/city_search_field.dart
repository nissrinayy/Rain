import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:rain/app/api/api.dart';
import 'package:rain/app/api/city_api.dart';
import 'package:rain/app/ui/widgets/text_form.dart';
import 'package:rain/main.dart';

class CitySearchField extends StatefulWidget {
  const CitySearchField({
    super.key,
    required this.onSelected,
    this.controller,
    this.focusNode,
    this.variant = TextFieldVariant.card,
    this.margin = const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    this.elevation,
    this.icon,
    this.labelText,
    this.onChanged,
    this.iconButton,
  });

  final void Function(Result) onSelected;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextFieldVariant variant;
  final EdgeInsets margin;
  final double? elevation;
  final Icon? icon;
  final String? labelText;
  final void Function(String)? onChanged;
  final Widget? iconButton;

  @override
  State<CitySearchField> createState() => _CitySearchFieldState();
}

class _CitySearchFieldState extends State<CitySearchField> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();
  }

  @override
  void dispose() {
    if (widget.controller == null) _controller.dispose();
    if (widget.focusNode == null) _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final labelLarge = Theme.of(context).textTheme.labelLarge;

    return RawAutocomplete<Result>(
      focusNode: _focusNode,
      textEditingController: _controller,
      fieldViewBuilder:
          (
            BuildContext context,
            TextEditingController fieldController,
            FocusNode fieldFocusNode,
            VoidCallback onFieldSubmitted,
          ) => MyTextForm(
            labelText: widget.labelText ?? 'search'.tr,
            type: TextInputType.text,
            icon:
                widget.icon ??
                const Icon(IconsaxPlusLinear.global_search, size: 20),
            variant: widget.variant,
            controller: _controller,
            margin: widget.margin,
            elevation: widget.elevation,
            focusNode: _focusNode,
            onChanged: widget.onChanged,
            iconButton: widget.iconButton,
          ),
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<Result>.empty();
        }
        return WeatherAPI().getCity(textEditingValue.text, locale);
      },
      onSelected: (Result selection) {
        widget.onSelected(selection);
      },
      displayStringForOption: (Result option) =>
          '${option.name}, ${option.admin1}',
      optionsViewBuilder:
          (
            BuildContext context,
            AutocompleteOnSelected<Result> onSelected,
            Iterable<Result> options,
          ) => _buildOptionsView(context, onSelected, options, labelLarge),
    );
  }

  Widget _buildOptionsView(
    BuildContext context,
    AutocompleteOnSelected<Result> onSelected,
    Iterable<Result> options,
    TextStyle? labelLarge,
  ) => Align(
    alignment: Alignment.topLeft,
    child: Material(
      borderRadius: BorderRadius.circular(20),
      elevation: 4,
      child: SizedBox(
        width: 250,
        child: ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemCount: options.length,
          itemBuilder: (BuildContext context, int index) {
            final Result option = options.elementAt(index);
            return InkWell(
              onTap: () => onSelected(option),
              child: ListTile(
                title: Text(
                  '${option.name}, ${option.admin1}',
                  style: labelLarge,
                ),
              ),
            );
          },
        ),
      ),
    ),
  );
}
