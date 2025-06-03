// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:markdown/markdown.dart' as md;

import 'utils.dart';

void main() {
  group('Block Container Builder', () {
    testWidgets(
      'custom container for paragraph',
      (WidgetTester tester) async {
        const String data = 'This is a paragraph';

        // Define a custom block container builder that adds a colored container
        Widget builder(
          BuildContext context,
          Widget child,
          md.Element element,
          TextStyle? preferredStyle,
          TextStyle? parentStyle,
        ) {
          return Container(
            color: Colors.lightBlue[100],
            padding: const EdgeInsets.all(8.0),
            child: child,
          );
        }

        await tester.pumpWidget(
          boilerplate(
            Markdown(
              data: data,
              blockContainerBuilder: builder,
            ),
          ),
        );

        // Verify that the container is applied
        expect(find.byType(Container), findsWidgets);

        // Find the container with our specific color
        final Container container = tester.widget<Container>(
          find.ancestor(
            of: find.text('This is a paragraph'),
            matching: find.byType(Container),
          ).first,
        );

        expect(container.color, Colors.lightBlue[100]);
        expect(container.padding, const EdgeInsets.all(8.0));
      },
    );

    testWidgets(
      'custom container for header',
      (WidgetTester tester) async {
        const String data = '# Header';

        // Define a custom block container builder that adds a border
        Widget builder(
          BuildContext context,
          Widget child,
          md.Element element,
          TextStyle? preferredStyle,
          TextStyle? parentStyle,
        ) {
          return Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.red),
              borderRadius: BorderRadius.circular(4.0),
            ),
            padding: const EdgeInsets.all(4.0),
            margin: const EdgeInsets.symmetric(vertical: 4.0),
            child: child,
          );
        }

        await tester.pumpWidget(
          boilerplate(
            Markdown(
              data: data,
              blockContainerBuilder: builder,
            ),
          ),
        );

        // Verify that the container is applied
        expect(find.byType(Container), findsWidgets);

        // Find the container with our specific decoration
        final Container container = tester.widget<Container>(
          find.ancestor(
            of: find.text('Header'),
            matching: find.byType(Container),
          ).first,
        );

        expect(container.decoration, isA<BoxDecoration>());
        final BoxDecoration decoration = container.decoration as BoxDecoration;
        expect(decoration.border, isNotNull);
        expect(decoration.borderRadius, isNotNull);
      },
    );

    testWidgets(
      'custom container for blockquote',
      (WidgetTester tester) async {
        const String data = '> This is a blockquote';

        // Define a custom block container builder that adds a background color
        Widget builder(
          BuildContext context,
          Widget child,
          md.Element element,
          TextStyle? preferredStyle,
          TextStyle? parentStyle,
        ) {
          // Only customize blockquotes
          if (element.tag == 'blockquote') {
            return Container(
              color: Colors.grey[200],
              padding: const EdgeInsets.all(16.0),
              margin: const EdgeInsets.all(8.0),
              child: child,
            );
          }
          return child;
        }

        await tester.pumpWidget(
          boilerplate(
            Markdown(
              data: data,
              blockContainerBuilder: builder,
            ),
          ),
        );

        // Verify that the container is applied
        expect(find.byType(Container), findsWidgets);

        // Find the container with our specific color
        final Container container = tester.widget<Container>(
          find.ancestor(
            of: find.text('This is a blockquote'),
            matching: find.byType(Container),
          ).first,
        );

        expect(container.color, Colors.grey[200]);
        expect(container.padding, const EdgeInsets.all(16.0));
        expect(container.margin, const EdgeInsets.all(8.0));
      },
    );

    testWidgets(
      'custom container for list',
      (WidgetTester tester) async {
        const String data = '- Item 1\n- Item 2\n- Item 3';

        // Define a custom block container builder that adds a background color
        Widget builder(
          BuildContext context,
          Widget child,
          md.Element element,
          TextStyle? preferredStyle,
          TextStyle? parentStyle,
        ) {
          // Only customize lists
          if (element.tag == 'ul') {
            return Container(
              decoration: BoxDecoration(
                color: Colors.amber[100],
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: const EdgeInsets.all(8.0),
              child: child,
            );
          }
          return child;
        }

        await tester.pumpWidget(
          boilerplate(
            Markdown(
              data: data,
              blockContainerBuilder: builder,
            ),
          ),
        );

        // Verify that the container is applied
        expect(find.byType(Container), findsWidgets);

        // The list items should be inside a container with our custom decoration
        final Container container = tester.widget<Container>(
          find.ancestor(
            of: find.text('Item 1'),
            matching: find.byType(Container),
          ).first,
        );

        expect(container.decoration, isA<BoxDecoration>());
        final BoxDecoration decoration = container.decoration as BoxDecoration;
        expect(decoration.color, Colors.amber[100]);
        expect(decoration.borderRadius, isNotNull);
      },
    );

    testWidgets(
      'custom container for code block',
      (WidgetTester tester) async {
        const String data = '```\ncode block\n```';

        // Define a custom block container builder that adds a background color
        Widget builder(
          BuildContext context,
          Widget child,
          md.Element element,
          TextStyle? preferredStyle,
          TextStyle? parentStyle,
        ) {
          // Only customize code blocks
          if (element.tag == 'pre') {
            return Container(
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(4.0),
              ),
              padding: const EdgeInsets.all(16.0),
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: child,
            );
          }
          return child;
        }

        await tester.pumpWidget(
          boilerplate(
            Markdown(
              data: data,
              blockContainerBuilder: builder,
            ),
          ),
        );

        // Verify that the container is applied
        expect(find.byType(Container), findsWidgets);

        // Find containers with our specific decoration
        final Finder containerFinder = find.byWidgetPredicate((Widget widget) {
          if (widget is Container && widget.decoration is BoxDecoration) {
            final BoxDecoration decoration = widget.decoration as BoxDecoration;
            return decoration.color == Colors.grey[900];
          }
          return false;
        });

        expect(containerFinder, findsOneWidget);
      },
    );

    testWidgets(
      'custom container with decorative tooltip',
      (WidgetTester tester) async {
        const String data = 'This text has a decorative tooltip';

        // Define a custom block container builder that adds a decorative tooltip-like appearance
        Widget builder(
          BuildContext context,
          Widget child,
          md.Element element,
          TextStyle? preferredStyle,
          TextStyle? parentStyle,
        ) {
          return Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.yellow[100],
                  border: Border.all(color: Colors.orange),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                padding: const EdgeInsets.all(8.0),
                child: child,
              ),
              Positioned(
                top: -10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: const Text(
                    'Tooltip info',
                    style: TextStyle(color: Colors.white, fontSize: 10.0),
                  ),
                ),
              ),
            ],
          );
        }

        await tester.pumpWidget(
          boilerplate(
            Markdown(
              data: data,
              blockContainerBuilder: builder,
            ),
          ),
        );

        // Verify that the Stack widget is present
        expect(find.byType(Stack), findsWidgets);

        // Verify the decorative tooltip text is present
        expect(find.text('Tooltip info'), findsOneWidget);

        // Verify the container is still present
        expect(find.byType(Container), findsWidgets);

        // Verify the main content is present
        expect(find.text('This text has a decorative tooltip'), findsOneWidget);
      },
    );
  });
}
