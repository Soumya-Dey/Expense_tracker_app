import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionList extends StatefulWidget {
  final List<Transaction> transactions;
  final Function removeTxMethod;

  TransactionList(this.transactions, this.removeTxMethod);

  @override
  _TransactionListState createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  final titleEditController = TextEditingController();
  final amountEditController = TextEditingController();
  DateTime selectedDateOnEdit;

  void presentEditingDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }

      setState(() {
        selectedDateOnEdit = pickedDate;
      });
    });
  }

  void showInfoDialog(BuildContext context, int index) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            elevation: 5,
            title: Text(
              widget.transactions[index].title,
              style: Theme.of(context).textTheme.title,
            ),
            content: Container(
              height: 50,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                      "₹${widget.transactions[index].amount.toStringAsFixed(2)}"),
                  SizedBox(
                    height: 4,
                  ),
                  Text(DateFormat.yMMMd()
                      .format(widget.transactions[index].date)),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  "CLOSE",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              Tooltip(
                message: "Edit transaction",
                preferBelow: false,
                child: FlatButton(
                    child: Icon(
                      Icons.edit,
                      color: Theme.of(context).accentColor,
                    ),
                    onPressed: () {
                      showEditingDialog(context, index);
                      //Navigator.of(context).pop();
                    }),
              ),
            ],
          );
        });
  }

  void showEditingDialog(BuildContext context, int index) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            elevation: 5,
            title: Text("Edit transaction"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(
                    labelText: "Title",
                  ),
                  keyboardType: TextInputType.text,
                  controller: titleEditController,
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: "Amount",
                  ),
                  keyboardType: TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  controller: amountEditController,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        selectedDateOnEdit == null
                            ? "No Date chosen!"
                            : DateFormat.yMd().format(selectedDateOnEdit),
                      ),
                    ),
                    FlatButton(
                      padding: EdgeInsets.all(6),
                      textColor: Theme.of(context).primaryColor,
                      child: Text(
                        "Choose Date",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onPressed: presentEditingDatePicker,
                    ),
                  ],
                )
              ],
            ),
            actions: <Widget>[
              FlatButton(
                  child: Text(
                    "CANCEL",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
              FlatButton(
                child: Text(
                  "DONE",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  setState(() {
                    widget.transactions[index].title = titleEditController.text;
                    widget.transactions[index].amount =
                        double.parse(amountEditController.text);
                    widget.transactions[index].date = selectedDateOnEdit;
                  });

                  Navigator.of(context).pop();
                },
              ),
              SizedBox(
                width: 2,
              ),
            ],
          );
        });
  }

  void showDeletionDialog(BuildContext context, int index) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            elevation: 5,
            title: Text("Delete transaction?"),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  "CANCEL",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              FlatButton(
                child: Text(
                  "DELETE",
                  style: TextStyle(
                    color: Theme.of(context).errorColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  widget.removeTxMethod(index);
                  Navigator.of(context).pop();
                },
              ),
              SizedBox(
                width: 2,
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return widget.transactions.isEmpty
        ? LayoutBuilder(builder: (ctx, constraints) {
            return Column(
              children: <Widget>[
                Text(
                  "No transaction added yet!",
                  style: Theme.of(context).textTheme.title,
                ),
                SizedBox(
                  height: 50,
                ),
                Container(
                  height: constraints.maxHeight * 0.6,
                  child: Image.asset(
                    "assets/images/waiting.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            );
          })
        : ListView.builder(
            itemBuilder: (context, index) {
              return Card(
                elevation: 3,
                margin: EdgeInsets.symmetric(
                  vertical: 4,
                  horizontal: 8,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ListTile(
                    title: Text(
                      widget.transactions[index].title,
                      style: Theme.of(context).textTheme.title,
                    ),
                    subtitle: Row(
                      children: <Widget>[
                        Text(
                          mediaQuery.size.width > 560
                              ? DateFormat.yMMMEd()
                                  .format(widget.transactions[index].date)
                              : DateFormat.yMMMd()
                                  .format(widget.transactions[index].date),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          "₹${widget.transactions[index].amount.toStringAsFixed(2)}",
                        )
                      ],
                    ),
                    trailing: mediaQuery.size.width > 660
                        ? FlatButton.icon(
                            textColor: Theme.of(context).errorColor,
                            label: Text(
                              "DELETE",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            icon: Icon(
                              Icons.delete_outline,
                              color: Theme.of(context).errorColor,
                            ),
                            onPressed: () => showDeletionDialog(context, index),
                          )
                        : IconButton(
                            tooltip: "Delete transaction",
                            icon: Icon(
                              Icons.delete_outline,
                              color: Theme.of(context).errorColor,
                            ),
                            onPressed: () => showDeletionDialog(context, index),
                          ),
                    onTap: () => showInfoDialog(context, index),
                    onLongPress: () => showEditingDialog(context, index),
                  ),
                ),
              );
            },
            itemCount: widget.transactions.length,
          );
  }
}
