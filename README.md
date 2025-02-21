# Storybook Toolkit Tester

## Setup:

1. Import `storybook_toolkit_tester` package:
   ```yaml
   dev_dependencies:
     storybook_toolkit_tester: ^1.4.0-dev.0 
   ```

2. Create test file, e.g. `storybook_test.dart`.

3. Add the following content there:

   ```dart
   void main() => testStorybook(
     storybook,
     devices: { Devices.ios.iPhoneSE, Devices.android.pixel4, Devices.ios.iPadAir4 },
     filterStories: (Story story) {
       final skipStories = [];
       return !skipStories.contains(story.name);
     },
   );

   final storybook = Storybook(
     stories: [
       Story(
         name: 'Button',
         builder: (context) => ElevatedButton(
           onPressed: () {},
           child: const Text('Button'),
         ),
       ),
       Story(
         name: 'CounterPage',
         builder: (context) => const CounterPage(),
       ),
     ],
   );
   ```

5. Generate golden images by running: `flutter test --update-goldens --tags=storybook`.

