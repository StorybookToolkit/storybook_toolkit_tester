library storybook_toolkit_tester;

export 'devices.dart';

import 'dart:async';

import 'package:adaptive_golden_test/adaptive_golden_test.dart';
import 'package:flutter/material.dart';
import 'package:recase/recase.dart';
import 'package:meta/meta.dart';
import 'package:storybook_toolkit/storybook_toolkit.dart';
import 'package:storybook_toolkit_tester/devices.dart';

@isTest
Future<void> testStorybook(
  Storybook storybook, {
  Set<Device> devices = const {Device.pixel5, Device.iPhone8, Device.iPhone13},
  bool Function(Story story)? filterStories,
  String rootPath = 'goldens',
}) async {
  AdaptiveTestConfiguration.instance.setDeviceVariants({
    for (Device device in devices)
      WindowConfigData(
        device.name,
        size: device.size,
        pixelDensity: device.pixelDensity,
        targetPlatform: device.targetPlatform,
        borderRadius: device.borderRadius,
        safeAreaPadding: device.safeAreaPadding,
        keyboardSize: device.keyboardSize,
        homeIndicator: device.homeIndicator,
        notchSize: device.notchSize,
        punchHole: device.punchHole,
      ),
  });
  await loadFonts();
  setupFileComparatorWithThreshold();

  for (final story in storybook.stories.where((s) => filterStories?.call(s) ?? true)) {
    testAdaptiveWidgets(
      'Run ${story.name} test',
      (tester, variant) async {
        await tester.pumpWidget(
          AdaptiveWrapper(
            windowConfig: variant,
            tester: tester,
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Storybook(
                initialStory: story.name,
                showPanel: false,
                wrapperBuilder: storybook.wrapperBuilder,
                stories: storybook.stories,
              ),
            ),
          ),
        );

        //await tester.expectGolden(variant);
        //await tester.tap(find.byKey(ValueKey("TestField")));
        if (story.loadDuration != null) await tester.pumpAndSettle(story.loadDuration!);
        await tester.expectGolden(
          variant,
          pathBuilder: (_) => "$rootPath/${story.name.snakeCase}/${variant.name}.png",
        );
      },
      tags: ['storybook'],
    );
  }
}
