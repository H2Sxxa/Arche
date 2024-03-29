import 'dart:async';

import 'package:arche/arche.dart';
import 'package:flutter/material.dart';

extension Dialogs on ComplexDialog {
  Future<void> text({
    BuildContext? context,
    Widget? content,
    Widget? title,
  }) async {
    return await withChild(AlertDialog(
      title: title,
      content: Padding(
        padding: const EdgeInsets.all(8),
        child: content,
      ),
      actions: [
        TextButton(
          onPressed: () => navigator(context).pop(),
          child: Text(
              MaterialLocalizations.of(context ?? this.context!).okButtonLabel),
        )
      ],
    )).prompt(context: context);
  }

  Future<bool> confirm({
    BuildContext? context,
    Widget? content,
    Widget? title,
    bool cancel = false,
    EdgeInsetsGeometry padding = const EdgeInsets.all(8),
  }) async {
    var locale = MaterialLocalizations.of(context ?? this.context!);
    var nav = navigator(context);
    return await withChild(AlertDialog(
          title: title,
          content: Padding(
            padding: padding,
            child: content,
          ),
          actions: [
            TextButton(
              onPressed: () => nav.pop(true),
              child: Text(locale.okButtonLabel),
            ),
            TextButton(
              onPressed: () => nav.pop(false),
              child: Text(locale.cancelButtonLabel),
            )
          ],
        )).prompt<bool>(context: context) ??
        cancel;
  }

  Future<String?> input({
    BuildContext? context,
    Widget? title,
    bool obscureText = false,
    bool autofocus = false,
    TextInputType? keyboardType,
    InputDecoration decoration = const InputDecoration(),
  }) async {
    var ctrl = TextEditingController();
    var nav = navigator(context);
    return await withChild(
      AlertDialog(
        title: title,
        content: Padding(
          padding: const EdgeInsets.all(8),
          child: TextField(
            obscureText: obscureText,
            decoration: decoration,
            autofocus: autofocus,
            controller: ctrl,
            keyboardType: keyboardType,
            onSubmitted: (value) => nav.pop(value),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () {
                var text = ctrl.text;
                if (text.isEmpty) {
                  nav.pop(null);
                } else {
                  nav.pop(text);
                }
                ctrl.dispose();
              },
              child: Text(MaterialLocalizations.of(context ?? this.context!)
                  .okButtonLabel))
        ],
      ),
    ).prompt(context: context);
  }

  void license({
    BuildContext? context,
    String? applicationName,
    String? applicationVersion,
    Widget? applicationIcon,
    String? applicationLegalese,
    List<Widget>? children,
  }) async {
    await withChild(AboutDialog(
      applicationIcon: applicationIcon,
      applicationLegalese: applicationLegalese,
      applicationName: applicationName,
      applicationVersion: applicationVersion,
      children: children,
    )).prompt(context: context);
  }
}
