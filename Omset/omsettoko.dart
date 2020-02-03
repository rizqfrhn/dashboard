import 'omsetmodel.dart';
import 'omsetcontroller.dart';
import '../services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:intl/intl.dart';

class OmsetToko extends StatefulWidget {
  String areaKey;
  String nik;
  String periode;
  String nikSales;
  String salesName;

  OmsetToko({Key key, @required this.areaKey,
    @required this.nik,
    @required this.periode,
    @required this.nikSales,
    @required this.salesName})
      : super(key: key);

  @override
  _OmsetToko createState() =>
      _OmsetToko(areaKey: areaKey, nik: nik, periode: periode, nikSales: nikSales, salesName: salesName);
}

class _OmsetToko extends State<OmsetToko> {
  String areaKey;
  String nik;
  String periode;
  String nikSales;
  String salesName;

  _OmsetToko({Key key, @required this.areaKey,
    @required this.nik,
    @required this.periode,
    @required this.nikSales,
    @required this.salesName});

  OmsetTokoDataSource _omsetDataSource = OmsetTokoDataSource([], null, null, null, null, null);
  bool isLoaded = false;
  bool isLoadedTotal = false;
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  int _sortColumnIndex;
  bool _sortAscending = true;
  var loading = false;
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  Future<void> _fetchData() async {
    final result = await fetchResultToko(http.Client(), areaKey, nik, periode, nikSales);
    if (!isLoaded) {
      setState(() {
        _omsetDataSource = OmsetTokoDataSource(result, nik, periode, areaKey, nikSales, context);
        bool isLoaded = true;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchData();
    /*refreshList();*/
  }

  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _fetchData();
    });

    return null;
  }

  void _sort<T>(Comparable<T> getField(OmsetTokoModel d), int columnIndex,
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
      appBar: AppBar(
        title: const Text('Omset Toko'),
      ),
      body: RefreshIndicator(
        key: refreshKey,
        child: Scrollbar(
          child: ListView(
            padding: const EdgeInsets.all(20.0),
            children: <Widget>[
              dataToko(),
            ],
          ),
        ),
        onRefresh: refreshList,
      ),
    );
  }

  Widget dataToko() {
    return PaginatedDataTable(
      header: Text(salesName),
      rowsPerPage: _rowsPerPage,
      onRowsPerPageChanged: (int value) {
        setState(() {
          _rowsPerPage = value;
        });
      },
      sortColumnIndex: _sortColumnIndex,
      sortAscending: _sortAscending,
      dataRowHeight: 45.0,
      columnSpacing: 15.0,
      horizontalMargin: 15.0,
      /*onSelectAll: _omsetDataSource._selectAll,*/
      columns: <DataColumn>[
        DataColumn(
          label: const Text('Toko'),
          onSort: (int columnIndex, bool ascending) => _sort<String>(
                  (OmsetTokoModel d) => d.nama_toko,
              columnIndex,
              ascending),
        ),
        DataColumn(
          label: const Text('Status'),
          onSort: (int columnIndex, bool ascending) => _sort<num>(
                  (OmsetTokoModel d) => d.persentase_omset,
              columnIndex,
              ascending),
        ),
        DataColumn(
          label: const Text('Target'),
          onSort: (int columnIndex, bool ascending) => _sort<num>(
                  (OmsetTokoModel d) => d.target_value,
              columnIndex,
              ascending),
        ),
        /*DataColumn(
                    label: const Text('Target Volume'),
                    numeric: true,
                    onSort: (int columnIndex, bool ascending) => _sort<num>((OmsetTokoModel d) => d.target_volume, columnIndex, ascending),
                  ),*/
        DataColumn(
          label: const Text('Realisasi'),
          onSort: (int columnIndex, bool ascending) => _sort<num>(
                  (OmsetTokoModel d) => d.net_exc_ppn,
              columnIndex,
              ascending),
        ),
      ],
      source: _omsetDataSource,
    );
  }
}
