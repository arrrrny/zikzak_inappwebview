import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview/zikzak_inappwebview.dart';

SessionRecipe buildRecipe() {
  return SessionRecipe(
    id: 'test-recipe',
    name: 'Test',
    entryUrl: 'https://shop.example.com',
    steps: [
      RecipeStepDefinition(id: 'login', instruction: 'Log in'),
      RecipeStepDefinition(
        id: 'open-order',
        instruction: 'Open an order',
        captureTap: true,
      ),
    ],
  );
}

Map<String, dynamic> tapPayload({
  String pageUrl = 'https://shop.example.com/orders',
  String text = 'Order detail',
}) {
  return {
    'selectorCandidates': ['div.order-card:first-of-type a'],
    'textContent': text,
    'tagName': 'A',
    'pageUrl': pageUrl,
  };
}

void main() {
  group('RecipeRecorder tap dedup', () {
    test('identical rapid double-tap is captured once', () {
      final events = <RecipeRecorderEvent>[];
      final recorder = RecipeRecorder.maybeCreate(
        recipe: buildRecipe(),
        onEvent: events.add,
      )!;
      recorder.confirmCurrentStep(); // move to the tap step

      recorder.handleTapPayload(tapPayload());
      recorder.handleTapPayload(tapPayload()); // accidental double-click

      expect(
        events.whereType<TapCaptured>().length,
        1,
        reason: 'second identical payload within the dedup window is dropped',
      );
      expect(recorder.partialRecording.steps[1].tapTarget, isNotNull);
    });

    test('different tap replaces the previous one (latest wins)', () {
      final events = <RecipeRecorderEvent>[];
      final recorder = RecipeRecorder.maybeCreate(
        recipe: buildRecipe(),
        onEvent: events.add,
      )!;
      recorder.confirmCurrentStep();

      recorder.handleTapPayload(tapPayload(text: 'First item'));
      recorder.handleTapPayload(tapPayload(text: 'Second item'));

      expect(events.whereType<TapCaptured>().length, 2);
      expect(
        recorder.partialRecording.steps[1].tapTarget?.textContent,
        'Second item',
      );
    });

    test('same tap on a different page is a new capture', () {
      final events = <RecipeRecorderEvent>[];
      final recorder = RecipeRecorder.maybeCreate(
        recipe: buildRecipe(),
        onEvent: events.add,
      )!;
      recorder.confirmCurrentStep();

      recorder.handleTapPayload(tapPayload());
      recorder.handleTapPayload(
        tapPayload(pageUrl: 'https://shop.example.com/orders?page=2'),
      );

      expect(events.whereType<TapCaptured>().length, 2);
    });

    test('redo clears the dedup state so the same tap can be re-captured', () {
      final events = <RecipeRecorderEvent>[];
      final recorder = RecipeRecorder.maybeCreate(
        recipe: buildRecipe(),
        onEvent: events.add,
      )!;
      recorder.confirmCurrentStep();

      recorder.handleTapPayload(tapPayload());
      recorder.redoCurrentStep();
      expect(recorder.partialRecording.steps[1].tapTarget, isNull);
      recorder.handleTapPayload(tapPayload());

      expect(events.whereType<TapCaptured>().length, 2);
      expect(recorder.partialRecording.steps[1].tapTarget, isNotNull);
    });
  });
}
