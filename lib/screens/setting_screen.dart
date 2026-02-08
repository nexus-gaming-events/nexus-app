import 'package:flutter/material.dart';
import 'package:nexus_app/data_manager.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../constants.dart';
import '../classes/user_settings.dart';
import 'dart:math' as math;
import '../widgets/back_button_widget.dart';
import '../widgets/base_screen_container.dart';
import '../widgets/header_container.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Map<String, String> availableImages = {};
  String selectedImagePath = '';
  Color selectedColor1 = Colors.blue;
  Color selectedColor2 = Colors.purple;
  List<String> blendModes = ['linear', 'radial', 'sweep'];
  String selectedBlendMode = 'linear';
  Gradient selectedGradient = const LinearGradient(
    colors: [Colors.blue, Colors.purple],
  );
  double sliderValue = 0.0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    await UserSettings.loadFromJson();
    setState(() {
      _SettingLoader();
      _isLoading = false;
    });
  }

  void _SettingLoader() {
    for (var entry in UserSettings.availableImages.entries) {
      availableImages[entry.key] = entry.value;
    }
    final selfUser = DataManager.getSelfUser();
    if (selfUser?.imageUrl.isNotEmpty ?? false) {
      availableImages['UserImage'] = selfUser!.imageUrl;
    }
    selectedImagePath = UserSettings.userImagePath;

    // Load gradient settings with null safety
    if (UserSettings.bannerGradient.colors.length >= 2) {
      selectedGradient = UserSettings.bannerGradient;
      selectedColor1 = UserSettings.bannerGradient.colors[0];
      selectedColor2 = UserSettings.bannerGradient.colors[1];

      if (selectedGradient is LinearGradient) {
        selectedBlendMode = 'linear';
      } else if (selectedGradient is RadialGradient) {
        selectedBlendMode = 'radial';
      } else if (selectedGradient is SweepGradient) {
        selectedBlendMode = 'sweep';
      }
    }

    sliderValue = UserSettings.paramter;
  }

  void _openColorPicker(Color currentColor, Function(Color) onColorSelected) {
    Color tempColor = currentColor;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pick a color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: currentColor,
              onColorChanged: (Color color) {
                tempColor = color;
              },
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Done'),
              onPressed: () {
                setState(() {
                  onColorSelected(tempColor);
                  _updateGradient();
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _updateGradient() {
    if (selectedBlendMode == 'linear') {
      selectedGradient = LinearGradient(
        colors: [selectedColor1, selectedColor2],
        begin: Alignment(-1, 0.0),
        end: Alignment(sliderValue + 1, 0.0),
      );
    } else if (selectedBlendMode == 'radial') {
      selectedGradient = RadialGradient(
        colors: [selectedColor1, selectedColor2],
        radius: sliderValue + 1,
      );
    } else if (selectedBlendMode == 'sweep') {
      selectedGradient = SweepGradient(
        colors: [selectedColor1, selectedColor2],
        startAngle: 0,
        endAngle: (4 * (math.pi + 1) * (sliderValue / 2.0 + 0.5)).clamp(
          0.000000000001,
          (4 * math.pi + 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(color: AppConstants.accentColor1),
      );
    }

    return BaseScreenContainer(
      alignment: Alignment.topCenter,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          HeaderContainer(
            customPadding: AppConstants.paddingLarge(context),
            child: Row(
              children: [
                BackButtonWidget(),
                SizedBox(
                  width: AppConstants.mainContainerWidth(context) * 0.01,
                ),
                Expanded(
                  child: Text(
                    'Settings',
                    style: TextStyle(
                      color: AppConstants.textColor,
                      fontSize: AppConstants.fontSizeXLargeResponsive(context),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: AppConstants.paddingLarge(context) * 1.5),
          Container(
            padding: EdgeInsets.only(left: AppConstants.paddingSmall(context)),
            alignment: Alignment.centerLeft,
            child: Text(
              'Select the style for the profile banner',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: AppConstants.textColor,
                fontSize: AppConstants.fontSizeLargeResponsive(context),
              ),
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.only(
              left: AppConstants.paddingMedium(context),
              right: AppConstants.paddingMedium(context),
              top: AppConstants.paddingMedium(context),
            ),
            width: AppConstants.mainContainerWidth(context),
            height: AppConstants.mainContainerHeight(context) * 0.4,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: AppConstants.semitransparentTextColor,
                  width: 1.0,
                ),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      height: AppConstants.mainContainerHeight(context) * 0.05,
                      width: AppConstants.mainContainerWidth(context) * 0.25,
                      child: ElevatedButton(
                        onPressed: () {
                          _openColorPicker(selectedColor1, (color) {
                            selectedColor1 = color;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppConstants.secondaryColor,
                          padding: EdgeInsets.symmetric(
                            horizontal: AppConstants.paddingSmall(context),
                            vertical: AppConstants.paddingSmall(context),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppConstants.borderRadiusSmall(context),
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: AppConstants.iconSizeSmall(context) * 0.5,
                              height: AppConstants.iconSizeSmall(context) * 0.5,
                              decoration: BoxDecoration(
                                color: selectedColor1,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2.0,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: AppConstants.paddingMedium(context),
                            ),
                            Text(
                              'Color 1',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: AppConstants.fontSizeMediumResponsive(
                                  context,
                                ),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: AppConstants.mainContainerWidth(context) * 0.05,
                    ),
                    Container(
                      height: AppConstants.mainContainerHeight(context) * 0.05,
                      width: AppConstants.mainContainerWidth(context) * 0.25,
                      child: ElevatedButton(
                        onPressed: () {
                          _openColorPicker(selectedColor2, (color) {
                            selectedColor2 = color;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppConstants.secondaryColor,
                          padding: EdgeInsets.symmetric(
                            horizontal: AppConstants.paddingSmall(context),
                            vertical: AppConstants.paddingSmall(context),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppConstants.borderRadiusSmall(context),
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: AppConstants.iconSizeSmall(context) * 0.5,
                              height: AppConstants.iconSizeSmall(context) * 0.5,
                              decoration: BoxDecoration(
                                color: selectedColor2,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2.0,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: AppConstants.paddingMedium(context),
                            ),
                            Text(
                              'Color 2',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: AppConstants.fontSizeMediumResponsive(
                                  context,
                                ),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: AppConstants.mainContainerWidth(context) * 0.05,
                    ),
                    Container(
                      height: AppConstants.mainContainerHeight(context) * 0.05,
                      width: AppConstants.mainContainerWidth(context) * 0.25,
                      padding: EdgeInsets.symmetric(
                        horizontal: AppConstants.paddingSmall(context),
                      ),
                      decoration: BoxDecoration(
                        color: AppConstants.secondaryColor,
                        borderRadius: BorderRadius.circular(
                          AppConstants.borderRadiusSmall(context),
                        ),
                      ),
                      child: DropdownButton<String>(
                        value: selectedBlendMode,
                        isExpanded: true,
                        underline: SizedBox(),
                        dropdownColor: AppConstants.secondaryColor,
                        style: TextStyle(
                          color: AppConstants.textColor,
                          fontSize: AppConstants.fontSizeMediumResponsive(
                            context,
                          ),
                        ),
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: AppConstants.textColor,
                        ),
                        items: blendModes.map((mode) {
                          return DropdownMenuItem<String>(
                            value: mode,
                            child: Text(
                              mode.toUpperCase(),
                              style: TextStyle(
                                color: AppConstants.textColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedBlendMode = value!;
                            _updateGradient();
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppConstants.paddingLarge(context)),
                Slider(
                  value: sliderValue,
                  min: -1.0,
                  max: 1.0,
                  divisions: 100,
                  label: sliderValue.toStringAsFixed(2),
                  activeColor: AppConstants.semitransparentTextColor,
                  inactiveColor: AppConstants.semitransparentTextColor,
                  onChanged: (double value) {
                    setState(() {
                      sliderValue = value;
                      _updateGradient();
                    });
                  },
                ),
                SizedBox(height: AppConstants.paddingLarge(context)),
                Container(
                  width: AppConstants.mainContainerWidth(context) * 0.8,
                  height: AppConstants.mainContainerHeight(context) * 0.2,
                  decoration: BoxDecoration(
                    gradient: selectedGradient,
                    borderRadius: BorderRadius.circular(
                      AppConstants.borderRadiusSmall(context),
                    ),
                    border: Border.all(
                      color: AppConstants.accentColor1,
                      width: 2.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: AppConstants.paddingLarge(context)),
          Container(
            height: AppConstants.mainContainerHeight(context) * 0.06,
            width: AppConstants.mainContainerWidth(context) * 0.4,
            child: ElevatedButton(
              onPressed: () {
                UserSettings.bannerGradient = selectedGradient;
                UserSettings.paramter = sliderValue;
                UserSettings.userImagePath = selectedImagePath;
                UserSettings().saveToJson();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingLarge(context),
                  vertical: AppConstants.paddingMedium(context),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    AppConstants.borderRadiusSmall(context),
                  ),
                ),
              ),
              child: Text(
                'SAVE',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: AppConstants.fontSizeLargeResponsive(context),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
