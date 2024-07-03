import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../theme.dart';
import '../recipe_model.dart';

class RecipeDisplayWidget extends StatelessWidget {
  const RecipeDisplayWidget({
    super.key,
    required this.recipe,
    this.subheading,
  });

  final Recipe recipe;
  final Widget? subheading;

  List<Widget> _buildsubjects(List<String> subjects) {
    final widgets = <Widget>[];
    for (var ingredient in subjects) {
      widgets.add(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Symbols.stat_0_rounded,
              size: 12,
            ),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              child: Text(
                ingredient,
                softWrap: true,
              ),
            ),
          ],
        ),
      );
    }

    return widgets;
  }

  List<Widget> _buildsteps(List<String> steps) {
    final widgets = <Widget>[];

    // check for existing numbers in steps.
    if (steps.first.startsWith(RegExp('[0-9]'))) {
      for (var instruction in steps) {
        widgets.add(Text(instruction));
        widgets.add(const SizedBox(height: MarketplaceTheme.spacing6));
      }
    } else {
      for (var i = 0; i < steps.length; i++) {
        widgets.add(Text(
          '${i + 1}. ${steps[i]}',
          softWrap: true,
        ));
        widgets.add(const SizedBox(height: MarketplaceTheme.spacing6));
      }
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(MarketplaceTheme.defaultBorderRadius),
            color: MarketplaceTheme.primary.withOpacity(.5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            recipe.title,
                            softWrap: true,
                            style: MarketplaceTheme.heading2,
                          ),
                          if (subheading != null)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: MarketplaceTheme.spacing7,
                              ),
                              child: subheading,
                            ),
                        ],
                      ),
                    ),
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateColor.resolveWith((states) {
                          if (states.contains(WidgetState.hovered)) {
                            return MarketplaceTheme.scrim.withOpacity(.6);
                          }
                          return Colors.white;
                        }),
                        shape: WidgetStateProperty.resolveWith(
                          (states) {
                            return RoundedRectangleBorder(
                              side: const BorderSide(
                                  color: MarketplaceTheme.primary),
                              borderRadius: BorderRadius.circular(
                                MarketplaceTheme.defaultBorderRadius,
                              ),
                            );
                          },
                        ),
                        textStyle: WidgetStateTextStyle.resolveWith(
                          (states) {
                            return MarketplaceTheme.dossierParagraph.copyWith(
                              color: Colors.black45,
                            );
                          },
                        ),
                      ),
                      onPressed: () async {
                        await showDialog<dynamic>(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: Padding(
                                padding: const EdgeInsets.all(
                                    MarketplaceTheme.spacing7),
                                child: Text(recipe.description),
                              ),
                            );
                          },
                        );
                      },
                      child: Transform.translate(
                        offset: const Offset(0, 5),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: MarketplaceTheme.spacing6),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 35,
                                height: 35,
                                child: SvgPicture.asset(
                                  'assets/chef_cat.svg',
                                  semanticsLabel: 'Chef cat icon',
                                ),
                              ),
                              Transform.translate(
                                offset: const Offset(1, -6),
                                child: Transform.rotate(
                                  angle: -pi / 20.0,
                                  child: Text(
                                    'Chef Noodle \n says...',
                                    style: MarketplaceTheme.label,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const Divider(
                  height: 40,
                  color: Colors.black26,
                ),
                Table(
                  columnWidths: const {
                    0: FlexColumnWidth(2),
                    1: FlexColumnWidth(3),
                  },
                  children: [
                    TableRow(
                      children: [
                        Text(
                          'dificulty:',
                          style: MarketplaceTheme.paragraph.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(recipe.dificulty.join(', '))
                      ],
                    ),
                    TableRow(children: [
                      Text(
                        'formula:',
                        style: MarketplaceTheme.paragraph.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(recipe.formula)
                    ]),
                    TableRow(children: [
                      Text(
                        'Nutrition per serving:',
                        style: MarketplaceTheme.paragraph.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(''),
                    ]),
                    ...recipe.otherInfo.entries.map((entry) {
                      return TableRow(children: [
                        Row(
                          children: [
                            const Icon(
                              Symbols.stat_0_rounded,
                              size: 12,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: Text(
                                entry.key,
                                style: MarketplaceTheme.label,
                                softWrap: true,
                              ),
                            ),
                          ],
                        ),
                        Text(entry.value as String,
                            style: MarketplaceTheme.label)
                      ]);
                    }),
                  ],
                ),
              ],
            ),
          ),

          /// Body section
          Padding(
            padding: const EdgeInsets.all(MarketplaceTheme.spacing4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: MarketplaceTheme.spacing7,
                  ),
                  child: Text('subjects:', style: MarketplaceTheme.subheading1),
                ),
                ..._buildsubjects(recipe.subjects),
                const SizedBox(height: MarketplaceTheme.spacing4),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: MarketplaceTheme.spacing7),
                  child: Text('steps:', style: MarketplaceTheme.subheading1),
                ),
                ..._buildsteps(recipe.steps),
              ],
            ),
          )
        ],
      ),
    );
  }
}
