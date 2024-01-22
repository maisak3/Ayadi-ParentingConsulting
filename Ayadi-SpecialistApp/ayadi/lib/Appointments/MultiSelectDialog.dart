import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';


   // (selectedDay == "sun")?dayName = "الأحد": (selectedDay == "mon")?dayName = "الإثنين": (selectedDay == "tue")?dayName = "الثلاثاء": (selectedDay == "wed")?dayName = "الأربعاء": (selectedDay == "thu")?dayName = "الخميس": (selectedDay == "fri")?dayName = "الجمعة": (selectedDay == "sat")?dayName = "السبت": "";

   class MultiSelectDialog extends StatefulWidget {
  final List<String> options;
  final String? defaultSelectedOption;

  MultiSelectDialog({Key? key, required this.options, this.defaultSelectedOption})
      : super(key: key);

  @override
  _MultiSelectDialogState createState() => _MultiSelectDialogState();
}

class _MultiSelectDialogState extends State<MultiSelectDialog> {
  late List<bool> _selectedOptions;
  List<String> selectedOptions = [];

  @override
  void initState() {
    super.initState();
    _selectedOptions = List<bool>.filled(widget.options.length, false);
    if (widget.defaultSelectedOption != null) {
      int index = widget.options.indexOf(widget.defaultSelectedOption!);
      if (index != -1) {
        _selectedOptions[index] = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
       textDirection: TextDirection.rtl,
      child: AlertDialog(
        shape:  RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
        title: Text('اختر يومًا'),
        titleTextStyle: TextStyle(color: Color.fromARGB(255, 83, 40, 108) , fontSize: 20),
        content: SingleChildScrollView(
          child: ListBody(
            children: List<Widget>.generate(
              widget.options.length,
              (index) {
                return CheckboxListTile(
                  title: Text(widget.options[index]),
                  value: _selectedOptions[index],
                  onChanged: (bool? value) {
                    setState(() {
                      if (widget.defaultSelectedOption == widget.options[index]) {
                        _selectedOptions[index] = true;
                      } else {
                        _selectedOptions[index] = value!;
                      }
                    });
                  },
    
                  activeColor:  widget.defaultSelectedOption == widget.options[index]? Colors.grey:Color(0xff5e5a99),
                  checkColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                  
                );
              },
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('إلغاء', style: TextStyle(color: Colors.black54,)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('نسخ', style: TextStyle(color: Color.fromARGB(255, 83, 40, 108))),
            onPressed: () {
              selectedOptions = [];
              for (int i = 0; i < _selectedOptions.length; i++) {
                if (_selectedOptions[i]) {
                  selectedOptions.add(widget.options[i]);
                }
              }
              Navigator.of(context).pop(selectedOptions);
            },
          ),
        ],
      ),
    );
  }
}
