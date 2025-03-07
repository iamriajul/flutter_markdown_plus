// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// TODO(goderbauer): Restructure the examples to avoid this ignore, https://github.com/flutter/flutter/issues/110208.
// ignore_for_file: avoid_implementing_value_types

import 'package:flutter/material.dart';
import 'package:flutter_markdown_latex/flutter_markdown_latex.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:markdown/markdown.dart' as md;

import '../shared/markdown_demo_widget.dart';

// ignore_for_file: public_member_api_docs

const String _markdownData = '''
## ChatGPT Response

Welcome to ChatGPT! Below is an example of a response with Markdown and LaTeX code:

### Markdown Example

You can use Markdown to format text easily. Here are some examples:

- **Bold Text**: **This text is bold**
- *Italic Text*: *This text is italicized*
- [Link](https://www.example.com): [This is a link](https://www.example.com)
- Lists:
  1. Item 1
  2. Item 2
  3. Item 3

### LaTeX Example

You can also use LaTeX for mathematical expressions. Here's an example:

- **Equation**: \( f(x) = x^2 + 2x + 1 \)
- **Integral**: \( \int_{0}^{1} x^2 \, dx \)
- **Matrix**:

\[
\begin{bmatrix}
1 & 2 & 3 \\
4 & 5 & 6 \\
7 & 8 & 9
\end{bmatrix}
\]

### Conclusion

Markdown and LaTeX can be powerful tools for formatting text and mathematical expressions in your Flutter app. If you have any questions or need further assistance, feel free to ask!
''';

const String _notes = '''
# Latex & ChatGPT Response Demo
---

## Overview

...
''';

class MarkdownLatexPluginDemo extends StatelessWidget implements MarkdownDemoWidget {
  const MarkdownLatexPluginDemo({super.key});

  static const String _title = 'Latex & ChatGPT Response Demo';

  @override
  String get title => MarkdownLatexPluginDemo._title;

  @override
  String get description => 'Shows the functionality of the LaTeX plugin with a ChatGPT response.';

  @override
  Future<String> get data => Future<String>.value(_markdownData);

  @override
  Future<String> get notes => Future<String>.value(_notes);

  static MarkdownElementBuilder builder = LatexElementBuilder();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Markdown(
          data: _markdownData,
          builders: {'latex': builder},
          extensionSet: md.ExtensionSet(
            [LatexBlockSyntax()],
            [LatexInlineSyntax()],
          ),
        ),
      ),
    );
  }
}
