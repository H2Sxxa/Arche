import 'dart:async';

import 'package:arche/arche.dart';
import 'package:flutter/material.dart';

class ProgressIndicatorController extends ChangeNotifier {
  ProgressIndicatorWidgetData? _internal;
  ProgressIndicatorWidgetData? get data => _internal;
  set data(ProgressIndicatorWidgetData? value) {
    _internal = value;
    notifyListeners();
  }

  ValueChanged<String?>? updateText;
  ValueChanged<double?>? updateProgress;
}

class ProgressIndicatorWidget extends StatefulWidget {
  final ProgressIndicatorWidgetData data;
  final ProgressIndicatorController? controller;

  /// The Padding of the Text
  final EdgeInsetsGeometry padding;
  final bool useLinear;
  final FutureOr Function(
    BuildContext context,
    ProgressIndicatorWidgetData data,
    ValueChanged<String?> updateText,
    ValueChanged<double?> updateProgress,
  )?
  onInit;

  final Widget Function(ProgressIndicatorWidgetState state)? builder;

  const ProgressIndicatorWidget({
    super.key,
    this.data = const ProgressIndicatorWidgetData(),
    this.controller,
    this.onInit,
    this.useLinear = false,
    this.padding = const EdgeInsets.all(12),
    this.builder,
  });

  @override
  State<StatefulWidget> createState() => ProgressIndicatorWidgetState();
}

@immutable
class ProgressIndicatorWidgetData {
  final String? text;
  final double? progress;
  const ProgressIndicatorWidgetData({this.progress, this.text});

  ProgressIndicatorWidgetData copy({double? progress, String? text}) {
    return ProgressIndicatorWidgetData(
      progress: progress ?? this.progress,
      text: text ?? this.text,
    );
  }
}

class ProgressIndicatorWidgetState extends State<ProgressIndicatorWidget>
    with RefreshMountedStateMixin {
  late ProgressIndicatorWidgetData data;

  @override
  void initState() {
    super.initState();

    data = widget.data;
    updateProgress(value) => refreshMountedFn(() {
      data = widget.data.copy(progress: value);
      widget.controller?.data = data;
    });
    updateText(value) => refreshMountedFn(() {
      data = widget.data.copy(text: value);
      widget.controller?.data = data;
    });
    widget.controller?.updateProgress = updateProgress;
    widget.controller?.updateText = updateText;
    widget.controller?.data = data;
    var onInit = widget.onInit;
    if (onInit != null) {
      onInit(context, data, updateText, updateProgress);
    }
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var builder = widget.builder;
    return builder != null
        ? builder(this)
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              widget.useLinear
                  ? LinearProgressIndicator(value: data.progress)
                  : CircularProgressIndicator(value: data.progress),
              Visibility(
                visible: data.text != null,
                child: Padding(
                  padding: widget.padding,
                  child: Text(data.text.toString()),
                ),
              ),
            ],
          );
  }
}
