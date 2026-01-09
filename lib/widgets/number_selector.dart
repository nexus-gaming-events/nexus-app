import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants.dart';

class NumberSelector extends StatelessWidget {
  final TextEditingController controller;
  final int minValue;
  final int maxValue;
  final VoidCallback onChanged;
  final Color buttonColor;

  const NumberSelector({
    Key? key,
    required this.controller,
    this.minValue = 0,
    this.maxValue = 100,
    required this.onChanged,
    this.buttonColor = AppConstants.accentColor2,
  }) : super(key: key);

  void _increment() {
    int current = int.tryParse(controller.text) ?? minValue;
    if (current < maxValue) {
      controller.text = (current + 1).toString();
      onChanged();
    }
  }

  void _decrement() {
    int current = int.tryParse(controller.text) ?? minValue;
    if (current > minValue) {
      controller.text = (current - 1).toString();
      onChanged();
    }
  }

  void _validateInput(String value) {
    if (value.isEmpty) return;
    int? number = int.tryParse(value);
    if (number != null) {
      if (number < minValue) {
        controller.text = minValue.toString();
        onChanged();
      } else if (number > maxValue) {
        controller.text = maxValue.toString();
        onChanged();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: AppConstants.iconSizeExtraSmall(context) * 1.4,
      width: AppConstants.iconSizeSmall(context) * 1.8,
      decoration: BoxDecoration(
        color: AppConstants.secondaryColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(0),
          topRight: Radius.circular(AppConstants.borderRadiusMax),
          bottomLeft: Radius.circular(0),
          bottomRight: Radius.circular(AppConstants.borderRadiusMax),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: AppConstants.paddingLarge(context)),
          SizedBox(
            width: AppConstants.paddingLarge(context) * 1.3,
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.justify,
              textAlignVertical: TextAlignVertical.center,
              maxLines: 1,
              scrollPhysics: NeverScrollableScrollPhysics(),
              enableInteractiveSelection: false,
              decoration: InputDecoration(
                border: InputBorder.none,
                counterText: '',
                contentPadding: EdgeInsets.zero,
                isDense: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(3),
              ],
              style: TextStyle(
                color: AppConstants.textColor,
                fontSize: AppConstants.fontSizeMediumResponsive(context),
                fontWeight: FontWeight.bold,
                height: 1.0,
              ),
              onChanged: _validateInput,
            ),
          ),
          SizedBox(width: AppConstants.paddingLarge(context)*1.3),
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: _increment,
                child: Container(
                  width: AppConstants.iconSizeExtraSmall(context) * 0.6,
                  height: AppConstants.iconSizeExtraSmall(context) * 0.5,
                  decoration: BoxDecoration(
                    color: buttonColor,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(AppConstants.borderRadiusMax),
                      topLeft: Radius.circular(4),
                      bottomLeft: Radius.circular(4),
                      bottomRight: Radius.circular(4),
                    ),
                  ),
                  child: Icon(
                    Icons.keyboard_arrow_up,
                    color: AppConstants.textColor,
                    size: AppConstants.iconSizeExtraSmall(context) * 0.4,
                  ),
                ),
              ),
              SizedBox(height: 2),
              InkWell(
                onTap: _decrement,
                child: Container(
                  width: AppConstants.iconSizeExtraSmall(context) * 0.6,
                  height: AppConstants.iconSizeExtraSmall(context) * 0.5,
                  decoration: BoxDecoration(
                    color: buttonColor,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(AppConstants.borderRadiusMax),
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(4),
                      bottomLeft: Radius.circular(4),
                    ),
                  ),
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    color: AppConstants.textColor,
                    size: AppConstants.iconSizeExtraSmall(context) * 0.4,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
