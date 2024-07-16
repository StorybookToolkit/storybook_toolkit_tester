# Storybook Toolkit Tester

## Setup:

1. Import `storybook_toolkit_tester` package:
   ```yaml
   dev_dependencies:
     storybook_toolkit_tester: ^1.1.0 
   ```

2. Create test file, e.g. `storybook_test.dart`.

3. Add the following content there:

   ```dart
   void main() => testStorybook(
     storybook,
     devices: {Device.iPhone8, Device.iPhone13, Device.pixel5, Device.iPadPro},
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

