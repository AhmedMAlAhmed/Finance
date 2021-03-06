import 'package:finance/bill.dart';
import 'package:finance/widgets/inpuNote.dart';
import 'package:finance/widgets/inputNumber.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../widgets/button.dart';
import '../database/db.dart';
import '../main.dart';

class addBill extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return addBillpage();
  }
}

class addBillpage extends State<addBill> {
  String catagories = 'اختارنوع المصروف';
  late var _Textvalue = '0';
  late var _note = 'NO NOTE';
  late DateTime _date = DateTime.now();
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  late var input;
  late var Note;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("اضافة مصروف"),
      ),
      body: Column(
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () async {
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now(),
                        ).then((selectDate) {
                          _date = selectDate!;
                        });
                      },
                      icon: Icon(Icons.calendar_today)),
                  Text(formatter.format(_date))
                ],
              )),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: input = inputMoney(_Textvalue)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: DropdownButton(
              onChanged: null,
              items: [],
            ),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              child: Note = inputNote(_note))
        ],
      ),
      bottomSheet: Container(
          width: double.infinity,
          child: Button("اضافة", () async {
            _Textvalue = await input.getValue();
            _note = await Note.getNote();
            late double _value = double.parse(_Textvalue);
            late String _formatted = formatter.format(_date);
            Bill bill = Bill(
                id: 1,
                date: _formatted,
                value: _value,
                type: 'car',
                note: _note);
            await DBhelper.instance.insertBill(bill);
            DBhelper.instance.getBillsTotal();
            DBhelper.instance.getTotalBalance();
            DBhelper.instance.getAvrage();
            Bills = (await DBhelper.instance.PrintBills());
            print("success");
            Navigator.pop(context);
          })),
    );
  }
}
