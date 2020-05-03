import 'package:flutter/material.dart';

typedef ToStringFunction = String Function<T>(T);

class DEDropDownButton<T> extends StatefulWidget {
  String label;
  String hint = "Select item";
  T selectedValue;
  List<T> values;
  ToStringFunction toStringFunction;

  DEDropDownButton(this.label, this.selectedValue, this.values, this.toStringFunction, {this.hint});

  @override
  State<StatefulWidget> createState() {
    return DEDropDownButtonState(this.label, this.selectedValue, this.values, this.toStringFunction, this.hint);
  }
}

class DEDropDownButtonState<T> extends State<DEDropDownButton> {
  String label;
  String hint;
  T selectedValue;
  List<T> values;
  ToStringFunction toStringFunction;

  DEDropDownButtonState(this.label, this.selectedValue, this.values, this.toStringFunction, this.hint);

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
                      style: TextStyle(color: Colors.black),
                    )),
              ))
          .toList(),
      onChanged: (value) {
        setState(() {
          selectedValue = value;
        });
      },
      hint: Align(alignment: FractionalOffset.center, child: Text(hint)),
    );
  }
}
