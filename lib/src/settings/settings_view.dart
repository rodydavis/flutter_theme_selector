import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_theme_selector/src/settings/settings_service.dart';
import 'package:flutter_theme_selector/src/settings/widgets/color_field.dart';
import 'package:flutter_theme_selector/src/settings/widgets/font_selector.dart';
import 'package:flutter_theme_selector/src/settings/widgets/theme_chooser_panel.dart';
import 'package:flutter_theme_selector/src/utils.dart';
import 'package:signals/signals_flutter.dart';

/// Displays the various settings that can be customized by the user.
///
/// When a user changes a setting, the SettingsController is updated and
/// Widgets that listen to the SettingsController are rebuilt.
class SettingsView extends StatefulWidget {
  SettingsView({super.key, required this.signals});

  static const routeName = '/settings';

  final SettingsSignalsService signals;

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    return Watch.builder(builder: (context) {
      final textTheme = Theme.of(context).textTheme;
      return Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                Text(
                  "Theme Mode",
                  style: textTheme.bodyLarge,
                ),
                Spacer(),
                DropdownButton<ThemeMode>(
                  value: widget.signals.themeMode.value,
                  onChanged: (v) => widget.signals.themeMode.value = v!,
                  items: const [
                    DropdownMenuItem(
                      value: ThemeMode.system,
                      child: Text('System Theme'),
                    ),
                    DropdownMenuItem(
                      value: ThemeMode.light,
                      child: Text('Light Theme'),
                    ),
                    DropdownMenuItem(
                      value: ThemeMode.dark,
                      child: Text('Dark Theme'),
                    )
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            FontSelector(
              service: widget.signals,
              fontList: ['Abril Fatface', 'Bokor', 'Noto Sans', 'Roboto'],
            ),
            SizedBox(
              height: 16,
            ),
            Divider(),
            SizedBox(
              height: 16,
            ),
            ColorField(
              color: int.parse(widget.signals.seed.value).toColor()!,
              title: "Seed Color",
              onChanged: (color) {
                widget.signals.seed.value = color.value.toString();
              },
            ),
            SizedBox(
              height: 16,
            ),
            Row(children: [
              Text(
                "Dynamic Variant",
                style: textTheme.bodyLarge,
              ),
              Spacer(),
              ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 200),
                  child: DropdownSearch<String>(
                    selectedItem: widget.signals.variant.value.name,
                    items: (_, __) =>
                        DynamicSchemeVariant.values.map((e) => e.name).toList(),
                    onChanged: (newValue) {
                      widget.signals.variant.value = DynamicSchemeVariant.values
                          .firstWhere((e) => e.name == newValue);
                    },
                  ))
            ]),
            Row(
              children: [
                Text(
                  "Contrast",
                  style: textTheme.bodyLarge,
                ),
                Spacer(),
                Slider(
                  value: double.parse(widget.signals.contrast.value),
                  min: -1,
                  max: 1,
                  divisions: 20,
                  label: widget.signals.contrast.value.toString(),
                  onChanged: (value) {
                    widget.signals.contrast.value = value.toString();
                  },
                ),
              ],
            ),
            Divider(),
            ThemeChooserPanel(
              onTap: (String value) {
                //TODO make a function that allows passing the whole scheme in case we have
                // constructed schemes that don't just use a seed color
                widget.signals.seed.value = value;
              },
              schemes: [
                ColorScheme.fromSeed(
                    seedColor: Colors.blue,
                    contrastLevel: double.parse(widget.signals.contrast.value)),
                ColorScheme.fromSeed(
                    seedColor: Colors.green,
                    contrastLevel: double.parse(widget.signals.contrast.value)),
                ColorScheme.fromSeed(
                    seedColor: Colors.yellow,
                    contrastLevel: double.parse(widget.signals.contrast.value))
              ],
            ),
            Divider(),
            ThemeChooserPanel(
              displayOnlyPrimary: true,
              onTap: (value) {
                //TODO make a function that allows passing the whole scheme in case we have
                // constructed schemes that don't just use a seed color
                print(value);
                widget.signals.seed.value = value;
              },
              schemes: [
                ColorScheme.fromSeed(
                    seedColor: Colors.blue,
                    contrastLevel: double.parse(widget.signals.contrast.value)),
                ColorScheme.fromSeed(
                    seedColor: Colors.green,
                    contrastLevel: double.parse(widget.signals.contrast.value)),
                ColorScheme.fromSeed(
                    seedColor: Colors.yellow,
                    contrastLevel: double.parse(widget.signals.contrast.value))
              ],
            ),
          ],
        ),
      );
    });
  }
}
