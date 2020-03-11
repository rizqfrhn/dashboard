import 'omsetmodel.dart';
import 'omsetarea.dart';
import 'omsetcontroller.dart';
import '../services.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fl_chart/fl_chart.dart' as mainchart;
import 'package:fl_animated_linechart/fl_animated_linechart.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:intl/intl.dart';

var now = new DateTime.now();
var year = now.year;
var month = now.month < 10 ? '0' + now.month.toString() : now.month.toString();
var monthFormat = new DateFormat("MMMM").format(now);
var yearFormat = new DateFormat("yyyy").format(now);
var monthComboBox = new DateFormat("MMMM").format(now);
var yearComboBox = new DateFormat("yyyy").format(now);
final numformat = new NumberFormat("#,###");
bool isFilter = false;

class Omset extends StatefulWidget {
  String nik;

  Omset({Key key, @required this.nik}) : super(key: key);

  @override
  _Omset createState() => _Omset(nik: nik);
}

class _Omset extends State<Omset> {
  String nik;

  _Omset({Key key, @required this.nik});

  AnimationController _animationController;
  OmsetDataSource _omsetDataSource = OmsetDataSource([], null, null, null);
  bool loading = false;
  bool firstload;
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  PeriodeModel periodeSelection;
  String periode = 'O${year}${month}';
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  int _sortColumnIndex;
  bool _sortAscending = true;
  bool isLoaded = false;
  Color darkBlue = Color(0xff071d40);
  /*Widget appBarTitle = new Text('Omset');*/
  Icon actionIcon = new Icon(Icons.search);

  Future<void> _fetchData(String periode) async {
    final result = await fetchResultOmset(http.Client(), nik, periode);
    if (!loading) {
      setState(() {
        _omsetDataSource = OmsetDataSource(result, nik, periode, context);
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      loading = true;
      refreshList();
      new Timer.periodic(Duration(seconds: 20),  (Timer firstTime) =>
          setState((){
              refreshList();
              firstTime.cancel();
          })
      );
      new Timer.periodic(Duration(seconds: 300),  (Timer t) => setState((){refreshList();}));
      periodeSelection = null;
    });

  }

  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _fetchData(periode);
      fetchData(nik, periode);
      fetchDataTagihan(nik, periode);
      fetchDataSO(nik, periode);
      fetchDataChart(nik, periode);
      fetchDataBrand(nik, periode);
      fetchDataCallEC(nik, periode);
      fetchDataDsToko(nik, periode);
      fetchDataRute(nik, periode);
      loading = false;
    });

    return null;
  }

  void _sort<T>(Comparable<T> getField(OmsetModel d), int columnIndex,
      bool ascending) {
    _omsetDataSource.sort<T>(getField, ascending);
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        /*title: appBarTitle,*/
        flexibleSpace: new Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                /*begin: Alignment.topRight,
                  end: Alignment.topLeft,*/
                  colors: [Colors.blue, Colors.lightBlueAccent])
          ),
        ),
        actions: <Widget>[
          _appBar(),
        ],
        leading: new Container(),
      ),
      body: loading ? Center(child: CircularProgressIndicator()) :
      RefreshIndicator(
        key: refreshKey,
        child: Scrollbar(
          child: ListView(
            padding: const EdgeInsets.all(20.0),
            children: <Widget>[
              new Container(
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          DetailOmset('Omset', 'Real', 'Target', realisasi, target, persentase),
                          DetailOmset('Tagihan', 'Real', 'Target', totalBayar, targetTagihan, persentaseTagihan),
                          DetailOmset('SO SJ', 'SJ', 'SO', sj, so, persentase_kirim),
                          OrderRute(),
                          /*MtDSection(),*/
                        ]
                    ),
                    new Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          DetailOmset('Omset Hari', 'Real', 'Target', realisasiHari, targetHari, persentaseHari),
                          DetailOmset('Tagihan Hari', 'Real', 'Target', totalBayarHari, targetTagihanHari, persentaseTagihanHari),
                          DetailOmset('SO FK', 'FK', 'SO', fk, so, persentase_faktur),
                          OrderSOToko(),
                        ]
                    ),
                  ],
                ),
              ),
              liquidChart(),
              /*SizedBox(
                height: 15,
              ),*/
              lineChart_(),
              SizedBox(
                height: 15,
              ),
              dataOmset(),
              SizedBox(
                height: 15.0,
              ),
              avgData(),
              SizedBox(
                height: 15.0,
              ),
              brandView(),
            ],
          ),
        ),
        onRefresh: refreshList,
      ),
    );
  }

  Widget makeRadioTiles() {
    List<Widget> list = new List<Widget>();

    for (PeriodeModel listperiode in listPeriode) {
      list.add(new RadioListTile(
        value: listperiode.kode_periode,
        groupValue: periode,
        onChanged: (newValue) {
          setState(() {
            /*debugPrint('VAL = $newValue');*/
            Default();
            periode = newValue;
            monthFormat = new DateFormat("MMMM").format(DateTime.parse
              ('${listperiode.TAHUN}-${listperiode.BULAN}-01'));
            yearFormat = new DateFormat("yyyy").format(DateTime.parse
              ('${listperiode.TAHUN}-${listperiode.BULAN}-01'));
            monthChart = int.parse(listperiode.BULAN);
            yearChart = int.parse(listperiode.TAHUN);
            refreshList();
            Navigator.of(context).pop();
          });
        },
        controlAffinity: ListTileControlAffinity.trailing,
        title: new Text(
            '${monthComboBox = new DateFormat("MMMM").format(DateTime.parse
              ('${listperiode.TAHUN}-${listperiode.BULAN}-01'))} ${
                yearComboBox = new DateFormat("yyyy").format(DateTime.parse
                  ('${listperiode.TAHUN}-${listperiode.BULAN}-01'))}'),

      ));
    }

    Column column = new Column(children: list,);
    return column;
  }

  Widget _appBar() {
    return new Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Text('Filter',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
          new Container(width: 8.0),
          new IconButton (
            icon: actionIcon,
            onPressed: () {
              setState(() {
                showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40)),
                      elevation: 16,
                      child: Container(
                        width: 400,
                        decoration: new BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.rectangle,
                          borderRadius: new BorderRadius.circular(5.0),
                        ),
                        child: Center(
                          child: ListView(
                            padding: EdgeInsets.all(8.0),
                            children: <Widget>[
                              new Container(
                                padding: EdgeInsets.only(top: 15),
                                width: 300,
                                decoration: new BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.rectangle,
                                  borderRadius: new BorderRadius.circular(
                                      5.0),
                                ),
                                child: Center(
                                    child: Text('Select Periode',
                                        style: TextStyle(fontSize: 20,
                                            fontWeight: FontWeight.bold))
                                ),
                              ),
                              makeRadioTiles(),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              });
            },
          ),
        ]
    );
  }

  Container DetailOmset(String title_, String subtitle1_, String subtitle2_,
      double value1_, double value2_, double persentase_) {
    Orientation orientation = MediaQuery.of(context).orientation;
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(bottom: 10.0),
      width: orientation == Orientation.portrait
          ? MediaQuery.of(context).size.width * 0.44
          : MediaQuery.of(context).size.width * 0.47,
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      decoration: new BoxDecoration(
        color: Colors.lightBlue,
        shape: BoxShape.rectangle,
        borderRadius: new BorderRadius.only(
          topLeft: Radius.circular(5),
          topRight: Radius.circular(5),
          bottomLeft: Radius.circular(5),
          bottomRight: Radius.circular(5),),
        boxShadow: <BoxShadow>[
          new BoxShadow(
            color: Colors.black12,
            blurRadius: 10.0,
            offset: new Offset(0.0, 10.0),
          ),
        ],
      ),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(title_, style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            SizedBox(
              height: 7.5,
            ),
            Wrap(
              spacing: 10.0,
              runSpacing: 5.0,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(subtitle1_,
                        style: TextStyle(color: Colors.white)),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text('${FlutterMoneyFormatter(amount: value1_).compactNonSymbol}',
                        style: TextStyle(color: Colors.white)),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(subtitle2_,
                        style: TextStyle(color: Colors.white)),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text('${FlutterMoneyFormatter(amount: value2_).compactNonSymbol}',
                        style: TextStyle(color: Colors.white)),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 5.0,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: new LinearPercentIndicator(
                    width: MediaQuery.of(context).size.width * 0.3,
                    alignment: MainAxisAlignment.center,
                    animation: true,
                    lineHeight: 20.0,
                    animationDuration: 2000,
                    percent: 1.0,
                    center: Text('${persentase_.toStringAsFixed(2)} %', style: TextStyle(color: Colors.white)),
                    linearStrokeCap: LinearStrokeCap.roundAll,
                    progressColor: persentase_ <= 80 ? Colors.red :
                    persentase_ <= 90 ? Colors.orange :
                    Colors.green,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 7.5,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: new LinearPercentIndicator(
                animation: true,
                backgroundColor: Colors.white,
                lineHeight: 2.0,
                animationDuration: 2000,
                percent: persentase_ / 100 <= 0.0 ? 0.0 :
                persentase_ / 100 >= 1.0 ? 1.0 :
                persentase_ / 100,
                linearStrokeCap: LinearStrokeCap.roundAll,
                progressColor: persentase_ <= 80 ? Colors.red :
                persentase_ <= 90 ? Colors.orange :
                Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container MtDSection() {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(bottom: 10.0),
      width: MediaQuery.of(context).size.width * 0.42,
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      decoration: new BoxDecoration(
        color: Colors.lightBlue,
        shape: BoxShape.rectangle,
        borderRadius: new BorderRadius.only(
          topLeft: Radius.circular(5),
          topRight: Radius.circular(5),
          bottomLeft: Radius.circular(5),
          bottomRight: Radius.circular(5),),
        boxShadow: <BoxShadow>[
          new BoxShadow(
            color: Colors.black12,
            blurRadius: 10.0,
            offset: new Offset(0.0, 10.0),
          ),
        ],
      ),
      child: Container(
        child: Column(
          children: <Widget>[
            Text('Month to Date', style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            /*SizedBox(height: 20.0),*/
            Divider(
              height: 21,
              color: Colors.white,
            ),
            /*value_(value1: 'Target',
                value2: FlutterMoneyFormatter(amount: target).compact,
                separator: ':',
                color: Colors.white),*/
            Text('Target : ${FlutterMoneyFormatter(amount: target).compact}', style: TextStyle(color: Colors.white)),
            SizedBox(height: 10.0),
            Text('Realisasi : ${FlutterMoneyFormatter(amount: realisasi).compact}',
                style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  Container OrderRute() {
    Orientation orientation = MediaQuery.of(context).orientation;
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(bottom: 10.0),
      width: orientation == Orientation.portrait
          ? MediaQuery.of(context).size.width * 0.44
          : MediaQuery.of(context).size.width * 0.47,
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      decoration: new BoxDecoration(
        color: Colors.lightBlue,
        shape: BoxShape.rectangle,
        borderRadius: new BorderRadius.only(
          topLeft: Radius.circular(5),
          topRight: Radius.circular(5),
          bottomLeft: Radius.circular(5),
          bottomRight: Radius.circular(5),
        ),
        boxShadow: <BoxShadow>[
          new BoxShadow(
            color: Colors.black12,
            blurRadius: 10.0,
            offset: new Offset(0.0, 10.0),
          ),
        ],
      ),
      child: Center(
        child: Container(
          child: Column(
            children: <Widget>[
              Text('Rute Kirim', style: TextStyle(fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
              SizedBox(
                height: 7.5,
              ),
              Wrap(
                spacing: 10.0,
                runSpacing: 5.0,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text('Rute',
                          style: TextStyle(color: Colors.white)),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text('${numformat.format(totalRute)}',
                          style: TextStyle(color: Colors.white)),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text('',
                          style: TextStyle(color: Colors.white)),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(' / ',
                          style: TextStyle(color: Colors.white)),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text('Toko',
                          style: TextStyle(color: Colors.white)),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text('${numformat.format(totalTokoRute)}',
                          style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 5.0,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.3,
                child: new LinearPercentIndicator(
                  width: MediaQuery.of(context).size.width * 0.3,
                  alignment: MainAxisAlignment.center,
                  animation: true,
                  lineHeight: 20.0,
                  animationDuration: 2000,
                  percent: 1.0,
                  center: Text('${persentaseRute.toStringAsFixed(2)} %', style: TextStyle(color: Colors.white)),
                  linearStrokeCap: LinearStrokeCap.roundAll,
                  progressColor: persentaseRute <= 80 ? Colors.red :
                  persentaseRute <= 90 ? Colors.orange :
                  Colors.green,
                ),
              ),
              SizedBox(
                height: 7.5,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                child: new LinearPercentIndicator(
                  animation: true,
                  backgroundColor: Colors.white,
                  lineHeight: 2.0,
                  animationDuration: 2000,
                  percent: persentaseRute / 100 <= 0.0 ? 0.0 :
                  persentaseRute / 100 >= 1.0 ? 1.0 :
                  persentaseRute / 100,
                  linearStrokeCap: LinearStrokeCap.roundAll,
                  progressColor: persentaseRute <= 80 ? Colors.red :
                  persentaseRute <= 90 ? Colors.orange :
                  Colors.green,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container OrderSOToko() {
    Orientation orientation = MediaQuery.of(context).orientation;
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(bottom: 10.0),
      width: orientation == Orientation.portrait
          ? MediaQuery.of(context).size.width * 0.44
          : MediaQuery.of(context).size.width * 0.47,
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      decoration: new BoxDecoration(
        color: Colors.lightBlue,
        shape: BoxShape.rectangle,
        borderRadius: new BorderRadius.only(
          topLeft: Radius.circular(5),
          topRight: Radius.circular(5),
          bottomLeft: Radius.circular(5),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: <BoxShadow>[
          new BoxShadow(
            color: Colors.black12,
            blurRadius: 10.0,
            offset: new Offset(0.0, 10.0),
          ),
        ],
      ),
      child: Center(
        child: Container(
          child: Column(
            children: <Widget>[
              Text('Distribusi Toko', style: TextStyle(fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
              SizedBox(
                height: 7.5,
              ),
              Wrap(
                spacing: 10.0,
                runSpacing: 5.0,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text('SO',
                          style: TextStyle(color: Colors.white)),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text('${numformat.format(totalOrderSO)}',
                          style: TextStyle(color: Colors.white)),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text('',
                          style: TextStyle(color: Colors.white)),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(' / ',
                          style: TextStyle(color: Colors.white)),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text('Toko',
                          style: TextStyle(color: Colors.white)),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text('${numformat.format(totalToko)}',
                          style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 5.0,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.3,
                child: new LinearPercentIndicator(
                  width: MediaQuery.of(context).size.width * 0.3,
                  alignment: MainAxisAlignment.center,
                  animation: true,
                  lineHeight: 20.0,
                  animationDuration: 2000,
                  percent: 1.0,
                  center: Text('${persentaseToko.toStringAsFixed(2)} %', style: TextStyle(color: Colors.white)),
                  linearStrokeCap: LinearStrokeCap.roundAll,
                  progressColor: persentaseToko <= 80 ? Colors.red :
                  persentaseToko <= 90 ? Colors.orange :
                  Colors.green,
                ),
              ),
              SizedBox(
                height: 7.5,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                child: new LinearPercentIndicator(
                  animation: true,
                  backgroundColor: Colors.white,
                  lineHeight: 2.0,
                  animationDuration: 2000,
                  percent: persentaseToko / 100 <= 0.0 ? 0.0 :
                  persentaseToko / 100 >= 1.0 ? 1.0 :
                  persentaseToko / 100,
                  linearStrokeCap: LinearStrokeCap.roundAll,
                  progressColor: persentaseToko <= 80 ? Colors.red :
                  persentaseToko <= 90 ? Colors.orange :
                  Colors.green,
                ),
              ),
              /*Text('Distribusi Toko', style: TextStyle(fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
              /*SizedBox(height: 20.0),*/
              Divider(
                height: 21,
                color: Colors.white,
              ),
              Text('${numformat.format(totalOrderSO)} / ${numformat.format(totalToko)}', style: TextStyle(color: Colors.white)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                child: new LinearPercentIndicator(
                  animation: true,
                  lineHeight: 20.0,
                  animationDuration: 2000,
                  percent: persentaseToko / 100 <= 0.0 ? 0.0 :
                  persentaseToko / 100 >= 1.0 ? 1.0 :
                  persentaseToko / 100,
                  center: Text('${persentaseToko.toStringAsFixed(2)}%', style: TextStyle(color: Colors.white)),
                  linearStrokeCap: LinearStrokeCap.roundAll,
                  progressColor: persentaseToko <= 80 ? Colors.red :
                  persentaseToko <= 90 ? Colors.orange :
                  Colors.green,
                  /*progressColor: omset.persentase_bulan <= 40 ? Colors.red :
                  omset.persentase_bulan <= 60 ? Colors.amberAccent :
                  omset.persentase_bulan <= 80 ? Colors.lightBlueAccent :
                  omset.persentase_bulan <= 90 ? Colors.lightGreen :
                  Colors.green,*/
                ),
              ),*/
            ],
          ),
        ),
      ),
    );
  }

  Container liquidChart() {
    Orientation orientation = MediaQuery.of(context).orientation;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: Center(
        child: SizedBox(
          width: orientation == Orientation.portrait
              ? MediaQuery.of(context).size.width * 0.4
              :  MediaQuery.of(context).size.height * 0.5,
          height: orientation == Orientation.portrait
              ? MediaQuery.of(context).size.width * 0.4
              :  MediaQuery.of(context).size.height * 0.5,
          child: LiquidCircularProgressIndicator(
            value: persentase / 100 <= 0.0 ? 0.0 :
            persentase / 100 >= 1.0 ? 1.0 :
            persentase / 100,
            backgroundColor: Colors.white,
            valueColor: AlwaysStoppedAnimation(persentase <= 80 ? Colors.red :
            persentase <= 90 ? Colors.orange :
            Colors.green),
            borderWidth: 3,
            borderColor: persentase <= 80 ? Colors.red :
            persentase <= 90 ? Colors.orange :
            Colors.green,
            center: Text(
              "${persentase.toStringAsFixed(2)}%",
              style: TextStyle(
                color: persentase <= 60 ? Colors.black54 : Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget lineChart_() {
    Orientation orientation = MediaQuery.of(context).orientation;
    return AspectRatio(
      aspectRatio: orientation == Orientation.portrait ? 1.25 : 2.5,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          gradient: LinearGradient(
            colors: [Colors.white, Colors.white],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
          boxShadow: <BoxShadow>[
            new BoxShadow(
              color: Colors.black12,
              blurRadius: 10.0,
              offset: new Offset(0.0, 10.0),
            ),
          ],
        ),
        child: listLineChart.length > 0 ? Stack(
          children: <Widget>[
            Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    '${monthFormat} ${yearFormat}',
                    style: TextStyle(
                      color: darkBlue,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Daily Sales',
                    style: TextStyle(
                        color: darkBlue,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, top: 8.0, right: 15.0, bottom: 0.0),
                        child: AnimatedLineChart(
                          LineChart.fromDateTimeMaps(
                              [lineChartSO, lineChartSJ, lineChartTG],
                              [Colors.blue , Colors.orange, Colors.green],
                              ['', '', '']),
                          key: UniqueKey(),
                        ), //Unique key to force animations
                      )
                  ),
                  Wrap(
                    alignment: WrapAlignment.center,
                    runAlignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: <Widget>[
                      Icon(Icons.stop, color: Colors.blue),
                      Text(' : SO (Jt)'),
                      const SizedBox(
                        width: 10,
                      ),
                      Icon(Icons.stop, color: Colors.orange),
                      Text(' : SJ (Jt)'),
                      const SizedBox(
                        width: 10,
                      ),
                      Icon(Icons.stop, color: Colors.green),
                      Text(' : Tagihan (Jt)'),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                ]
            ),
          ],
        ) :
        Text('No Data Available',
            style: TextStyle(
              color: darkBlue, fontSize: 18),
            textAlign: TextAlign.center
        ),
      ),
    );
  }

  Widget dataOmset() {
    return PaginatedDataTable(

      header: new Text('${monthFormat} ${yearFormat}'),
      rowsPerPage: _rowsPerPage,
      onRowsPerPageChanged: (int value) {
        setState(() {
          _rowsPerPage = value;
        });
      },
      sortColumnIndex: _sortColumnIndex,
      sortAscending: _sortAscending,
      /*headingRowHeight: 30.0,*/
      dataRowHeight: 45.0,
      columnSpacing: 15.0,
      horizontalMargin: 15.0,
      /*onSelectAll: _omsetDataSource._selectAll,*/
      columns: <DataColumn>[
        DataColumn(
          label: Text('Regional'),
          onSort: (int columnIndex, bool ascending) =>
              _sort<String>(
                      (OmsetModel d) => d.nama_regional, columnIndex,
                  ascending),
        ),
        DataColumn(
          label: Text('Day'),
          onSort: (int columnIndex, bool ascending) =>
              _sort<num>(
                      (OmsetModel d) => d.persentase_harian,
                  columnIndex, ascending),
        ),
        DataColumn(
          label: Text('MTD'),
          onSort: (int columnIndex, bool ascending) =>
              _sort<num>(
                      (OmsetModel d) => d.persentase_bulan,
                  columnIndex, ascending),
        ),
        DataColumn(
          label: Text('Target'),
          onSort: (int columnIndex, bool ascending) =>
              _sort<num>(
                      (OmsetModel d) => d.target_omset, columnIndex,
                  ascending),
        ),
        /*DataColumn(
                    label: const Text('Target Volume'),
                    numeric: true,
                    onSort: (int columnIndex, bool ascending) => _sort<num>(
                    (OmsetModel d) => d.target_volume, columnIndex, ascending),
                  ),*/
        DataColumn(
          label: Text('Realisasi'),
          onSort: (int columnIndex, bool ascending) =>
              _sort<num>(
                      (OmsetModel d) => d.net_exc_ppn, columnIndex,
                  ascending),
        ),
      ],
      source: _omsetDataSource,
    );
  }

  Widget avgData() {
    return new Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Text("Ratio",
            style: Theme.of(context)
                .textTheme
                .title
                .apply(color: darkBlue, fontWeightDelta: 2),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Divider(
            height: 31,
            color: darkBlue,
          ),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 10.0),
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          width: MediaQuery.of(context).size.width * 0.95,
          decoration: new BoxDecoration(
            color: Colors.lightBlue,
            shape: BoxShape.rectangle,
            borderRadius: new BorderRadius.only(
              topLeft: Radius.circular(5),
              topRight: Radius.circular(5),
              bottomLeft: Radius.circular(5),
              bottomRight: Radius.circular(5),),
            boxShadow: <BoxShadow>[
              new BoxShadow(
                color: Colors.black12,
                blurRadius: 10.0,
                offset: new Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Wrap(
              alignment: WrapAlignment.spaceAround,
              spacing: 5.0,
              runSpacing: 5.0,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('',
                        style: TextStyle(color: Colors.white)),
                    SizedBox(height: 10.0),
                    Text('Target',
                        style: TextStyle(color: Colors.white)),
                    Text('Av Call',
                        style: TextStyle(color: Colors.white)),
                    Text('Av EC',
                        style: TextStyle(color: Colors.white)),
                    Text('Av Invoice',
                        style: TextStyle(color: Colors.white)),
                    Text('Sales',
                        style: TextStyle(color: Colors.white)),
                    Text('Estimasi',
                        style: TextStyle(color: Colors.white)),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text('',
                        style: TextStyle(color: Colors.white)),
                    SizedBox(height: 10.0),
                    Text(':',
                        style: TextStyle(color: Colors.white)),
                    Text(':',
                        style: TextStyle(color: Colors.white)),
                    Text(':',
                        style: TextStyle(color: Colors.white)),
                    Text(':',
                        style: TextStyle(color: Colors.white)),
                    Text(':',
                        style: TextStyle(color: Colors.white)),
                    Text(':',
                        style: TextStyle(color: Colors.white)),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text('Avg (3 Months)', style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                    SizedBox(height: 10.0),
                    Text('${FlutterMoneyFormatter(amount: targetOmsetLast).compact}',
                        style: TextStyle(color: Colors.white)),
                    Text('${rataCallLast.toStringAsFixed(0)}',
                        style: TextStyle(color: Colors.white)),
                    Text('${rataECLast.toStringAsFixed(0)}',
                        style: TextStyle(color: Colors.white)),
                    Text('${FlutterMoneyFormatter(amount: rataFkLast).compact}',
                        style: TextStyle(color: Colors.white)),
                    Text('${jumlahSalesLast.toStringAsFixed(0)}',
                        style: TextStyle(color: Colors.white)),
                    Text('${estimasiPersentaseLast.toStringAsFixed(2)} %',
                        style: TextStyle(color: Colors.white)),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text('MTD', style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                    SizedBox(height: 10.0),
                    Text('${FlutterMoneyFormatter(amount: targetOmset).compact}',
                        style: TextStyle(color: Colors.white)),
                    Text('${rataCall.toStringAsFixed(0)}',
                        style: TextStyle(color: Colors.white)),
                    Text('${rataEC.toStringAsFixed(0)}',
                        style: TextStyle(color: Colors.white)),
                    Text('${FlutterMoneyFormatter(amount: rataFk).compact}',
                        style: TextStyle(color: Colors.white)),
                    Text('${jumlahSales.toStringAsFixed(0)}',
                        style: TextStyle(color: Colors.white)),
                    Text('${estimasiPersentase.toStringAsFixed(2)} %',
                        style: TextStyle(color: Colors.white)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget brandView(){
    return new Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Text("Brand List",
              style: Theme.of(context)
                  .textTheme
                  .title
                  .apply(color: darkBlue, fontWeightDelta: 2),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Divider(
              height: 31,
              color: darkBlue,
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(bottom: 10.0),
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            width: MediaQuery.of(context).size.width * 0.95,
            decoration: new BoxDecoration(
              color: Colors.lightBlue,
              shape: BoxShape.rectangle,
              borderRadius: new BorderRadius.only(
                topLeft: Radius.circular(5),
                topRight: Radius.circular(5),
                bottomLeft: Radius.circular(5),
                bottomRight: Radius.circular(30),
              ),
              boxShadow: <BoxShadow>[
                new BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10.0,
                  offset: new Offset(0.0, 10.0),
                ),
              ],
            ),
            child: listBrand.length > 0 ? Column(
              children: [
                for ( var i in listBrand )
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child:  Wrap(
                      alignment: WrapAlignment.spaceAround,
                      spacing: 5.0,
                      runSpacing: 5.0,
                      children: <Widget>[
                        Center(
                            child: Text(i.jenis_merk,
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),)
                        ),
                        Divider(
                          height: 11,
                          color: Colors.white,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('Omset',
                                style: TextStyle(color: Colors.white)),
                            Text('Dist LY',
                                style: TextStyle(color: Colors.white)),
                            Text('Dist MTD',
                                style: TextStyle(color: Colors.white)),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Text(':',
                                style: TextStyle(color: Colors.white)),
                            Text(':',
                                style: TextStyle(color: Colors.white)),
                            Text(':',
                                style: TextStyle(color: Colors.white)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('${FlutterMoneyFormatter(amount: i.omset).compact}',
                                style: TextStyle(color: Colors.white)),
                            Text('${numformat.format(i.jumlah_toko_last_year)} Tk / '
                                '${numformat.format(i.total_toko_last_year)} Tk',
                                style: TextStyle(color: Colors.white)),
                            Text('${numformat.format(i.jumlah_toko)} Tk / '
                                '${numformat.format(i.total_toko_mtd)} Tk',
                                style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ],
                    ),/*Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Center(
                            child: Text(i.jenis_merk,
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),)
                        ),
                        Divider(
                          height: 11,
                          color: Colors.white,
                        ),
                        Text('Omset : ${FlutterMoneyFormatter(amount: i.omset).compact}',
                            style: TextStyle(color: Colors.white)),
                        SizedBox(height: 5.0),
                        Text('Berat : ${(i.berat / 1000).toStringAsFixed(2)} Ton', style: TextStyle(color: Colors.white)),
                      ],
                    ),*/
                  ),
              ],
            ) :
            Text('No Data Available',
              style: TextStyle(
                  fontSize: 18, color: Colors.white),
            ),
          ),
        ]
    );
  }
}