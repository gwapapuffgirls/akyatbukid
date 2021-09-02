import 'package:flutter/material.dart';

class DropdownMenu extends StatefulWidget{
  @override
  DropdownMenuState createState() => DropdownMenuState();
}

class DropdownMenuState extends State<DropdownMenu> {

  var selectedItem;
  List<String> _dropdownItems = <String> [
   'First',
    'Second',
    'Third',
  ];

  @override
  Widget build(BuildContext context) {
    return Container (
      
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
               
                SizedBox(width: 20.0),
                DropdownButton(
                  items: _dropdownItems.map((value) => DropdownMenuItem(
                    child: Text(
                      value,
                      style: TextStyle(color: Color.fromRGBO(153, 153, 153, 1.0)),
                    ),
                    value: value,
                  ))
                  .toList(),
                  onChanged: (selecteddropitem) {
                    setState(() {
                      selectedItem = selecteddropitem;
                    });
                  },
                  value: selectedItem,
                  isExpanded: false,
                  hint: Text(
                    'Choose a mountain',
                    style: TextStyle(color: Color.fromRGBO(153, 153, 153, 1.0)),
                  ),
                )
              ],
            )
          )
        ],
      )
    );
  }
}