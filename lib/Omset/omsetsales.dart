import 'omsetmodel.dart';
import 'omsettoko.dart';
import 'omsetcontroller.dart';
import '../services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:intl/intl.dart';

class OmsetSales extends StatefulWidget {
  String areaKey;
  String areaName;
  String nik;
  String periode;

  OmsetSales({Key key, @required this.areaKey, @required this.areaName, @required this.nik, @required this.periode})
      : super(key: key);

  @override
  _OmsetSales createState() =>
      _OmsetSales(areaKey: areaKey, areaName: areaName, nik: nik, periode: periode);
}

class _OmsetSales extends State<OmsetSales> {
  String areaKey;
  String areaName;
  String nik;
  String periode;

  _OmsetSales({Key key, @required this.areaKey, @required this.areaName, @required this.nik, @required this.periode});

  OmsetSalesDataSource _omsetDataSource = OmsetSalesDataSource([], null, null, null, null);
  bool isLoaded = false;
  bool isLoadedTotal = false;
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  int _sortColumnIndex;
  bool _sortAscending = true;
  var loading = false;
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  Future<void> _fetchData() async {
    final result = await fetchResultSales(http.Client(), areaKey, nik, periode);
    if (!isLoaded) {
      setState(() {
        _omsetDataSource = OmsetSalesDataSource(result, nik, periode, areaKey, context);
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

  void _sort<T>(Comparable<T> getField(OmsetSalesModel d), int columnIndex,
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
        title: const Text('Omset Sales'),
      ),
      body: RefreshIndicator(
        key: refreshKey,
        child: Scrollbar(
          child: ListView(
            padding: const EdgeInsets.all(20.0),
            children: <Widget>[
              dataSales(),
            ],
          ),
        ),
        onRefresh: refreshList,
      ),
    );
  }

  Widget dataSales() {
    return PaginatedDataTable(
      header: Text(areaName),
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
          label: const Text('Sales'),
          onSort: (int columnIndex, bool ascending) => _sort<String>(
                  (OmsetSalesModel d) => d.nama_sales,
              columnIndex,
              ascending),
        ),
        DataColumn(
          label: const Text('MTD'),
          onSort: (int columnIndex, bool ascending) => _sort<num>(
                  (OmsetSalesModel d) => d.persentase_omset,
              columnIndex,
              ascending),
        ),
        DataColumn(
          label: const Text('Target'),
          onSort: (int columnIndex, bool ascending) => _sort<num>(
                  (OmsetSalesModel d) => d.target_value,
              columnIndex,
              ascending),
        ),
        /*DataColumn(
                    label: const Text('Target Volume'),
                    numeric: true,
                    onSort: (int columnIndex, bool ascending) => _sort<num>((OmsetSalesModel d) => d.target_volume, columnIndex, ascending),
                  ),*/
        DataColumn(
          label: const Text('Realisasi'),
          onSort: (int columnIndex, bool ascending) => _sort<num>(
                  (OmsetSalesModel d) => d.net_exc_ppn,
              columnIndex,
              ascending),
        ),
        DataColumn(
          label: const Text('Status Tagihan'),
          onSort: (int columnIndex, bool ascending) => _sort<num>(
                  (OmsetSalesModel d) => d.persentase,
              columnIndex,
              ascending),
        ),
        DataColumn(
          label: const Text('Target Tagih'),
          onSort: (int columnIndex, bool ascending) => _sort<num>(
                  (OmsetSalesModel d) => d.target_tagih,
              columnIndex,
              ascending),
        ),
        DataColumn(
          label: const Text('Total Bayar'),
          onSort: (int columnIndex, bool ascending) => _sort<num>(
                  (OmsetSalesModel d) => d.total_bayar,
              columnIndex,
              ascending),
        ),
      ],
      source: _omsetDataSource,
    );
  }
}
