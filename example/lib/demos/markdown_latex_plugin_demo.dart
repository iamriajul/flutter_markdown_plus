// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// TODO(goderbauer): Restructure the examples to avoid this ignore, https://github.com/flutter/flutter/issues/110208.
// ignore_for_file: avoid_implementing_value_types

import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_markdown_plus_latex/flutter_markdown_plus_latex.dart';
import 'package:markdown/markdown.dart' as md;

import '../shared/markdown_demo_widget.dart';

// ignore_for_file: public_member_api_docs

const String _markdownData = r"""
This is inline latex: $f(x) = \sum_{i=0}^{n} \frac{a_i}{1+x}$

This is block level latex:

$$
c = \pm\sqrt{a^2 + b^2}
$$

This is inline latex with displayMode: $$f(x) = \sum_{i=0}^{n} \frac{a_i}{1+x}$$ and here is a very long text that should be in the same line.

The relationship between the height and the side length of an equilateral triangle is:

\[ \text{Height} = \frac{\sqrt{3}}{2} \times \text{Side Length} \]

\[ \text{X} = \frac{1}{2} \times \text{Y} \times \text{Z} = \frac{1}{2} \times 9 \times \frac{\sqrt{3}}{2} \times 9 = \frac{81\sqrt{3}}{4} \]

The basic form of the Taylor series is:

\[f(x) = f(a) + f'(a)(x-a) + \frac{f''(a)}{2!}(x-a)^2 + \frac{f'''(a)}{3!}(x-a)^3 + \cdots\]

where \(f(x)\) is the function to be expanded, \(a\) is the expansion point, \(f'(a)\), \(f''(a)\), \(f'''(a)\), etc., are the first, second, third, and so on derivatives of the function at point \(a\), and \(n!\) denotes the factorial of \(n\).

In particular, when \(a=0\), this expansion is called the Maclaurin series.

""";

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

  static LatexElementBuilder builder = LatexElementBuilder();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Markdown(
          data: _markdownData,
          selectable: true,
          builders: <String, MarkdownElementBuilder>{'latex': builder},
          extensionSet: md.ExtensionSet(
            <md.BlockSyntax>[LatexBlockSyntax()],
            <md.InlineSyntax>[LatexInlineSyntax()],
          ),
        ),
      ),
    );
  }
}
