library storybook_toolkit_tester;

import 'dart:async';

import 'package:adaptive_golden_test/adaptive_golden_test.dart';
import 'package:flutter/material.dart';
import 'package:recase/recase.dart';
import 'package:meta/meta.dart';
import 'package:storybook_toolkit/storybook_toolkit.dart';

@isTest
Future<void> testStorybook(
  Storybook storybook, {
  Set<DeviceInfo>? devices,
  bool isFrameVisible = false,
  bool Function(Story story)? filterStories,
  String Function(PathContext)? goldenPathBuilder,
  String rootPath = 'goldens',
}) async {
  AdaptiveTestConfiguration.instance.setDeviceVariants(devices ??
      {
        Devices.ios.iPhoneSE,
        Devices.ios.iPhone12,
        Devices.android.samsungGalaxyS20,
      });
  await loadFonts();
  setupFileComparatorWithThreshold();

  for (final story in storybook.stories.where((s) => filterStories?.call(s) ?? true)) {
    testAdaptiveWidgets(
      'Run ${story.name} test',
      (tester, variant) async {
        await tester.pumpWidget(
          AdaptiveWrapper(
            device: variant,
            orientation: Orientation.portrait,
            isFrameVisible: isFrameVisible,
            showVirtualKeyboard: false,
            child: Storybook(
              initialStory: story.name,
              showPanel: false,
              wrapperBuilder: storybook.wrapperBuilder,
              stories: storybook.stories,
            ),
          ),
        );

        if (story.loadDuration != null) await tester.pumpAndSettle(story.loadDuration!);
        await tester.expectGolden(
          variant,
          pathBuilder: (_) {
            final path = story.name.split('/').map((e) => e.snakeCase).join('/');
            final fileName = "${variant.name.replaceAll(' ', '_')}.png";

            final PathContext context = (rootPath: rootPath, path: path, file: fileName);
            return story.goldenPathBuilder?.call(context) ??
                goldenPathBuilder?.call(context) ??
                "$rootPath/$path/$fileName";
          },
        );
      },
      tags: ['storybook', ...story.tags],
    );
  }
}
