import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import './widgets/transaction_list.dart';
import './widgets/new_transaction.dart';
import './widgets/chart.dart';
import './models/transaction.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          accentColor: Colors.orange,
          buttonColor: Colors.black,
          scaffoldBackgroundColor: Color.fromRGBO(255, 255, 255, 0.92),
          fontFamily: "OpenSans",
          textTheme: ThemeData.light().textTheme.copyWith(
                title: TextStyle(
                  fontFamily: "OpenSans",
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
          appBarTheme: AppBarTheme(
            textTheme: ThemeData.light().textTheme.copyWith(
                  title: TextStyle(
                    fontFamily: "OpenSans",
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
          )),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [
    // Transaction(
    //   id: "t1",
    //   title: "Item 1",
    //   amount: 568.16,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   id: "t2",
    //   title: "Item 2",
    //   amount: 123.67,
    //   date: DateTime.now(),
    // ),
  ];

  bool _showChart = false;

  // this method returns the list of transactions
  // of last 7 days from the _userTransactions list
  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      // isAfter() method returns the date on which
      // it is called on if the date comes after the
      // argument, which is also a date object
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addNewTransaction(
      String txTitle, double txAmount, DateTime chosenDate) {
    final newTx = Transaction(
      title: txTitle,
      amount: txAmount,
      date: chosenDate,
      id: DateTime.now().toString(),
    );

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _removeTransaction(int index) {
    setState(() {
      _userTransactions.removeAt(index);
    });
  }

  void _showTransactionAddingDialog(BuildContext contx) {
    showModalBottomSheet(
      context: contx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          behavior: HitTestBehavior.opaque,
          child: NewTransaction(_addNewTransaction),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    final isLandscape = (mediaQuery.orientation == Orientation.landscape);

    final PreferredSizeWidget appBar = Platform.isAndroid
        ? AppBar(
            title: Text('Expense Tracker'),
            actions: <Widget>[
              Tooltip(
                message: "Add transaction",
                verticalOffset: 40,
                child: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () => _showTransactionAddingDialog(context),
                ),
              )
            ],
          )
        : CupertinoNavigationBar(
            middle: Text('Expense Tracker'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  child: Tooltip(
                    message: "Add transaction",
                    verticalOffset: 40,
                    child: Icon(CupertinoIcons.add),
                  ),
                  onTap: () => _showTransactionAddingDialog(context),
                ),
              ],
            ),
          );

    var extraHeight = appBar.preferredSize.height + mediaQuery.padding.top;

    final transactionList = Container(
      height: (mediaQuery.size.height - extraHeight) * 0.7,
      child: TransactionList(_userTransactions, _removeTransaction),
    );

    final pageBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            if (isLandscape)
              Container(
                margin: EdgeInsets.only(top: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Show Chart",
                      style: Theme.of(context).textTheme.title,
                    ),
                    Switch.adaptive(
                      activeColor: Theme.of(context).accentColor,
                      value: _showChart,
                      onChanged: (val) {
                        setState(() {
                          _showChart = val;
                        });
                      },
                    ),
                  ],
                ),
              ),
            if (!isLandscape)
              Column(
                children: <Widget>[
                  Container(
                    height: (mediaQuery.size.height - extraHeight) * 0.3,
                    child: Chart(_recentTransactions),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 12),
                    child: Text(
                      "Your transactions",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color.fromRGBO(120, 120, 120, 0.8)
                      ),
                    ),
                  ),
                ],
              ),
            if (!isLandscape) transactionList,
            if (isLandscape)
              _showChart
                  ? Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      height: (mediaQuery.size.height - extraHeight) * 0.7,
                      child: Chart(_recentTransactions),
                    )
                  : transactionList,
          ],
        ),
      ),
    );

    return Platform.isAndroid
        ? Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButton: Tooltip(
              message: "Add transaction",
              preferBelow: false,
              verticalOffset: 40,
              child: Platform.isIOS
                  ? Container()
                  : FloatingActionButton(
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      onPressed: () => _showTransactionAddingDialog(context),
                    ),
            ),
          )
        : CupertinoPageScaffold(
            child: pageBody,
            navigationBar: appBar,
          );
  }
}
