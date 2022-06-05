library text_lumine;

import 'package:flutter/widgets.dart';
import 'package:text_lumine/default_text_styles.dart';
import 'package:text_lumine/lumine_info.dart';
import 'package:text_lumine/lumine_info_service.dart';

/// Text lumine.
class TextLumine extends StatelessWidget {
  final String text;
  final TextStyle? normalTextStyle;
  late final List<LumineInfo> _lumineInfoList;

  TextLumine(this.text,
      {Key? key, this.normalTextStyle, List<LumineInfo>? lumineInfoList})
      : super(key: key) {
    _lumineInfoList =
        LumineInfoService().rectifyHighlightInfoList(text, lumineInfoList);
  }

  TextLumine.withHighlightedWords(this.text,
      {required List<String> substrings,
      Key? key,
      this.normalTextStyle,
      bool ignoreDiacritics = false,
      bool ignoreCase = false,
      TextStyle? style})
      : super(key: key) {
    // Generate lumine info list from highlighted substrings.
    var lumineInfoService = LumineInfoService();

    var lumineInfoList = lumineInfoService.generateLumineInfoList(
        text, substrings,
        ignoreDiacritics: ignoreDiacritics,
        ignoreCase: ignoreCase,
        style: style);

    _lumineInfoList =
        lumineInfoService.rectifyHighlightInfoList(text, lumineInfoList);
  }

  @override
  Widget build(BuildContext context) {
    if (_lumineInfoList.isEmpty) {
      // No highlighted text. Return a simple Text widget.
      return Text(text,
          style: normalTextStyle ?? DefaultTextStyles.normalTextStyle);
    }

    return _buildRichText();
  }

  RichText _buildRichText() {
    final textSpans = _generateTextSpans();

    return RichText(
      text: TextSpan(children: textSpans),
    );
  }

  List<TextSpan> _generateTextSpans() {
    if (_lumineInfoList.isEmpty) {
      return [];
    }

    final List<TextSpan> textSpans = [];

    _lumineInfoList.sort((firstInfo, secondInfo) =>
        firstInfo.startIndex.compareTo(secondInfo.startIndex));

    if (_lumineInfoList[0].startIndex > 0) {
      // No highlight info for the first part of the text.
      // Create first text span.
      textSpans.add(TextSpan(
          text: text.substring(0, _lumineInfoList[0].startIndex),
          style: normalTextStyle ?? DefaultTextStyles.normalTextStyle));
    }

    var expectedStartIndex = _lumineInfoList[0].startIndex;

    for (var lumineInfo in _lumineInfoList) {
      if (expectedStartIndex < lumineInfo.startIndex) {
        // Add text between two lumines.
        textSpans.add(TextSpan(
            text: text.substring(expectedStartIndex, lumineInfo.startIndex),
            style: normalTextStyle ?? DefaultTextStyles.normalTextStyle));
      }

      if (lumineInfo.length == null || lumineInfo.length! <= 0) {
        continue;
      }

      final endIndex = lumineInfo.startIndex + lumineInfo.length!;

      textSpans.add(TextSpan(
          text: text.substring(lumineInfo.startIndex, endIndex),
          style: lumineInfo.style ?? DefaultTextStyles.highlightingTextStyle));

      expectedStartIndex = endIndex;
    }

    final lastLumineIndex =
        _lumineInfoList.last.startIndex + (_lumineInfoList.last.length ?? 0);

    if (lastLumineIndex < text.length) {
      // The last highlight does not cover the whole text.
      textSpans.add(TextSpan(
          text: text.substring(lastLumineIndex),
          style: normalTextStyle ?? DefaultTextStyles.normalTextStyle));
    }

    return textSpans;
  }
}
