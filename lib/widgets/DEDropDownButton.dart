import 'package:flutter/material.dart';

typedef ToStringFunction = String Function<T>(T);
typedef OnSelectedCallback = void Function<T>(T);

class DEDropDownButton<T> extends StatefulWidget {
  String label;
  T selectedValue;
  List<T> values;
  ToStringFunction toStringFunction;
  OnSelectedCallback callback;

  DEDropDownButton(this.label, this.selectedValue, this.values, this.toStringFunction, {this.callback});

  @override
  State<StatefulWidget> createState() {
    return DEDropDownButtonState(this.label, this.selectedValue, this.values, this.toStringFunction, this.callback);
  }
}

class DEDropDownButtonState<T> extends State<DEDropDownButton> {
  String label;
  T selectedValue;
  List<T> values;
  ToStringFunction toStringFunction;
  OnSelectedCallback callback;

  DEDropDownButtonState(this.label, this.selectedValue, this.values, this.toStringFunction, this.callback);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
        decoration: InputDecoration(labelText: label),
        value: selectedValue,
        //isExpanded: true,
        items: values
            .map((e) => DropdownMenuItem(
                  value: e,
                  child: Align(
                      alignment: FractionalOffset.center,
                      child: Text(
                        toStringFunction(e),
                        style: Theme.of(context).textTheme.button,
                      )),
                ))
            .toList(),
        onChanged: (value) {
          setState(() {
            selectedValue = value;
          });
          callback(value);
        });
  }
}
