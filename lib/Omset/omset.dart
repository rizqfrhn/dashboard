import 'omsetmodel.dart';
import 'omsetarea.dart';
import 'omsetcontroller.dart';
import '../services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
  var loading = false;
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
    if (!isLoaded) {
      setState(() {
        _omsetDataSource = OmsetDataSource(result, nik, periode, context);
        bool isLoaded = true;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _fetchData(periode);
    fetchDataTotal(nik, periode);
    fetchBrand(nik, periode);
    fetchToko(nik, periode);
    fetchDataPeriode();
    periodeSelection = null;
    /*refreshList();*/

  }

  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _fetchData(periode);
      fetchDataTotal(nik, periode);
      fetchBrand(nik, periode);
      fetchToko(nik, periode);
      fetchDataPeriode();
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
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          MtDSection(),
                          liquidChart(),
                        ]
                    ),
                    OrderSOToko(),
                  ],
                ),
              ),
              dataOmset(),
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

    for (PeriodeModel listperiode in periodelist) {
      list.add(new RadioListTile(
        value: listperiode.kode_periode,
        groupValue: periode,
        onChanged: (newValue) {
          setState(() {
            /*debugPrint('VAL = $newValue');*/
            periode = newValue;
            monthFormat = new DateFormat("MMMM").format(DateTime.parse
              ('${listperiode.TAHUN}-${listperiode.BULAN}-01'));
            yearFormat = new DateFormat("yyyy").format(DateTime.parse
              ('${listperiode.TAHUN}-${listperiode.BULAN}-01'));
            _fetchData(periode);
            fetchDataTotal(nik, periode);
            fetchBrand(nik, periode);
            fetchToko(nik, periode);
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

  Container MtDSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
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
        width: MediaQuery.of(context).size.width / 3.5,
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
                value2: FlutterMoneyFormatter(amount: target).compactNonSymbol,
                separator: ':',
                color: Colors.white),*/
            Text('Target : ${FlutterMoneyFormatter(amount: target).compactNonSymbol}', style: TextStyle(color: Colors.white)),
            SizedBox(height: 10.0),
            Text('Realisasi : ${FlutterMoneyFormatter(amount: realisasi).compactNonSymbol}', style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  Container liquidChart() {
    return Container(
      /*margin: EdgeInsets.only(top: 50.0),*/
      margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
      child: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width / 3.0,
          height: MediaQuery.of(context).size.height / 6.0,
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

  Container OrderSOToko() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
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
          width: MediaQuery.of(context).size.width / 3.5,
          height: MediaQuery.of(context).size.height / 3.0,
          child: Column(
            children: <Widget>[
              Text('Distribusi Toko', style: TextStyle(fontSize: 18,
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
              ),
            ],
          ),
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
          label: const Text('Regional'),
          onSort: (int columnIndex, bool ascending) =>
              _sort<String>(
                      (OmsetModel d) => d.nama_regional, columnIndex,
                  ascending),
        ),
        DataColumn(
          label: const Text('Status'),
          onSort: (int columnIndex, bool ascending) =>
              _sort<num>(
                      (OmsetModel d) => d.persentase_bulan,
                  columnIndex, ascending),
        ),
        DataColumn(
          label: const Text('Target'),
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
          label: const Text('Realisasi'),
          onSort: (int columnIndex, bool ascending) =>
              _sort<num>(
                      (OmsetModel d) => d.net_exc_ppn, columnIndex,
                  ascending),
        ),
      ],
      source: _omsetDataSource,
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
          child: Column(
          children: [
            for ( var i in brandlist )
              Card(
                shape: RoundedRectangleBorder( borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5),
                  bottomLeft: Radius.circular(5),
                  bottomRight: Radius.circular(30),)),
                color: Colors.lightBlue,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(i.jenis_merk, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),),
                      Divider(
                        height: 11,
                        color: Colors.white,
                      ),
                      Text('Omset : ${FlutterMoneyFormatter(amount: i.omset).compactNonSymbol}', style: TextStyle(color: Colors.white)),
                      SizedBox(height: 5.0),
                      Text('Berat : ${(i.berat / 1000).toStringAsFixed(2)} Ton', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ],),
          ),
        ]
    );
  }
}