import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:text_lumine/lumine_info.dart';

import 'package:text_lumine/text_lumine.dart';

void main() {
  testWidgets('Text lumine has RichText and its InlineSpan is TextSpan',
      (tester) async {
    const text = "How to test";

    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr,
        child:
            TextLumine.withHighlightedWords(text, substrings: const ["test"])));

    // Create the Finder.
    final richTextFinder = find.text(text, findRichText: true);

    // Expect to find the rich text.
    expect(richTextFinder, findsOneWidget);

    // Expect main text span
    final richText = richTextFinder.evaluate().single.widget as RichText;
    final mainTextSpan = richText.text;

    expect(mainTextSpan, const TypeMatcher<TextSpan>());
  });

  testWidgets('Text lumine has correct TextSpans with highlighted words',
      (tester) async {
    const text = "How to test";

    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr,
        child:
            TextLumine.withHighlightedWords(text, substrings: const ["test"])));

    // Get rich text.
    final richTextFinder = find.text(text, findRichText: true);
    final richText = richTextFinder.evaluate().single.widget as RichText;
    final mainTextSpan = richText.text as TextSpan;
    final textSpanChildren = mainTextSpan.children!;

    expect(textSpanChildren, isNotNull);
    expect(textSpanChildren.length, 2);

    expect(textSpanChildren[0].toPlainText(), "How to ");
    expect(textSpanChildren[1].toPlainText(), "test");
  });

  testWidgets(
      'Text lumine has correct TextSpans with highlighted words considering diacritics',
      (tester) async {
    const text = "Làm sao để thử nghiệm";

    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr,
        child: TextLumine.withHighlightedWords(text,
            substrings: const ["thử nghiệm", "Lam sao"])));

    // Get rich text.
    final richTextFinder = find.text(text, findRichText: true);
    final richText = richTextFinder.evaluate().single.widget as RichText;
    final mainTextSpan = richText.text as TextSpan;
    final textSpanChildren = mainTextSpan.children!;

    expect(textSpanChildren, isNotNull);
    expect(textSpanChildren.length, 2);

    expect(textSpanChildren[0].toPlainText(), "Làm sao để ");
    expect(textSpanChildren[1].toPlainText(), "thử nghiệm");
  });

  testWidgets(
      'Text lumine has correct TextSpans with highlighted words regardless of diacritics',
      (tester) async {
    const text = "Làm sao để thử nghiệm";

    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr,
        child: TextLumine.withHighlightedWords(text,
            substrings: const ["thu nghiem"], ignoreDiacritics: true)));

    // Get rich text.
    final richTextFinder = find.text(text, findRichText: true);
    final richText = richTextFinder.evaluate().single.widget as RichText;
    final mainTextSpan = richText.text as TextSpan;
    final textSpanChildren = mainTextSpan.children!;

    expect(textSpanChildren, isNotNull);
    expect(textSpanChildren.length, 2);

    expect(textSpanChildren[0].toPlainText(), "Làm sao để ");
    expect(textSpanChildren[1].toPlainText(), "thử nghiệm");
  });

  testWidgets(
      'Text lumine builds Text widget without highlighted word considering case',
      (tester) async {
    const text = "How to test";

    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr,
        child:
            TextLumine.withHighlightedWords(text, substrings: const ["Test"])));

    // Expect.
    final textFinder = find.text(text);
    final elements = textFinder.evaluate();

    expect(elements.length, isPositive);

    final textWidget = textFinder.evaluate().single.widget;

    expect(textWidget, const TypeMatcher<Text>());
    expect((textWidget as Text).data, text);
  });

  testWidgets(
      'Text lumine has correct TextSpans with highlighted words ignoring case',
      (tester) async {
    const text = "How to test";

    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr,
        child: TextLumine.withHighlightedWords(text,
            substrings: const ["Test"], ignoreCase: true)));

    // Get rich text.
    final richTextFinder = find.text(text, findRichText: true);
    final richText = richTextFinder.evaluate().single.widget as RichText;
    final mainTextSpan = richText.text as TextSpan;
    final textSpanChildren = mainTextSpan.children!;

    expect(textSpanChildren, isNotNull);
    expect(textSpanChildren.length, 2);

    expect(textSpanChildren[0].toPlainText(), "How to ");
    expect(textSpanChildren[1].toPlainText(), "test");
  });

  testWidgets('Text lumine has correct TextSpans with LumineInfo list',
      (tester) async {
    const text = "How to do a test";

    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr,
        child: TextLumine(text,
            lumineInfoList: [LumineInfo(4, length: 2), LumineInfo(12)])));

    // Get rich text.
    final richTextFinder = find.text(text, findRichText: true);
    final richText = richTextFinder.evaluate().single.widget as RichText;
    final mainTextSpan = richText.text as TextSpan;
    final textSpanChildren = mainTextSpan.children!;

    expect(textSpanChildren, isNotNull);
    expect(textSpanChildren.length, 4);

    expect(textSpanChildren[0].toPlainText(), "How ");
    expect(textSpanChildren[1].toPlainText(), "to");
    expect(textSpanChildren[2].toPlainText(), " do a ");
    expect(textSpanChildren[3].toPlainText(), "test");
  });

  testWidgets(
      'Text lumine builds Text widget without neither highlighted words nor lumine info list',
      (tester) async {
    const text = "How to test";

    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr, child: TextLumine(text)));

    // Expect.
    final textFinder = find.text(text);
    final elements = textFinder.evaluate();

    expect(elements.length, isPositive);

    final textWidget = textFinder.evaluate().single.widget;

    expect(textWidget, const TypeMatcher<Text>());
    expect((textWidget as Text).data, text);
  });
}
