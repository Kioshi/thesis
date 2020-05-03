import 'package:flutter/material.dart';
import 'package:thesis/models/ToggableItem.dart';

class ToggleText extends StatefulWidget {
  final TogglableItem _item;
  final VoidCallback callback;

  ToggleText(this._item, {this.callback});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ToggleTextState(_item);
  }
}

class ToggleTextState extends State<ToggleText> {
  final TogglableItem _item;

  ToggleTextState(this._item);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => {setState(() => _item.enabled = !_item.enabled)},
        child: Card(
            color: _item.enabled ? Theme.of(context).primaryColorDark : Theme.of(context).disabledColor,
            child: Padding(
                padding: const EdgeInsets.all(4.0), child: Text(_item.text, style: _item.enabled ? null : TextStyle(decoration: TextDecoration.lineThrough)))));
  }
}
