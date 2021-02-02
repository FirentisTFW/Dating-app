import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

class DateSelectionField extends StatelessWidget {
  final DateTime _birthDate;
  final Function _setBirthDate;

  const DateSelectionField(this._birthDate, this._setBirthDate, {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: FlatButton(
        padding: const EdgeInsets.all(0),
        minWidth: double.infinity,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            _birthDate != null
                ? 'Birth date: ' + DateFormat('yMd').format(_birthDate)
                : 'Choose birth date',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        onPressed: () => _showDatePicker(context),
      ),
    );
  }

  void _showDatePicker(BuildContext context) {
    DatePicker.showDatePicker(
      context,
      currentTime: DateTime(DateTime.now().year - 20),
      maxTime: DateTime(DateTime.now().year - 16),
      theme: DatePickerTheme(
        itemHeight: 40,
        itemStyle: TextStyle(
            color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
        cancelStyle: TextStyle(
            color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
        doneStyle: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 22,
            fontWeight: FontWeight.bold),
      ),
      onConfirm: _setBirthDate,
    );
    FocusScope.of(context).unfocus();
  }
}
