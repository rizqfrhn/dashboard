import 'omsetmodel.dart';
import 'omsetsales.dart';
import 'omsetcontroller.dart';
import '../services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:intl/intl.dart';

class OmsetArea extends StatefulWidget {
  String nama_regional;
  String nik;
  String periode;

  OmsetArea({Key key, @required this.nama_regional, @required this.nik, @required this.periode})
      : super(key: key);

  @override
  _OmsetArea createState() =>
      _OmsetArea(nama_regional: nama_regional, nik: nik, periode: periode);
}

class _OmsetArea extends State<OmsetArea> {
  String nama_regional;
  String nik;
  String periode;

  _OmsetArea({Key key, @required this.nama_regional, @required this.nik, @required this.periode});

  OmsetAreaDataSource _omsetDataSource = OmsetAreaDataSource([], null, null, null);
  bool isLoaded = false;
  bool isLoadedTotal = false;
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  int _sortColumnIndex;
  bool _sortAscending = true;
  var loading = false;
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  Future<void> _fetchData() async {
    final result = await fetchResultArea(http.Client(), nama_regional, nik, periode);
    if (!isLoaded) {
      setState(() {
        _omsetDataSource = OmsetAreaDataSource(result, nik, periode, context);
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

  void _sort<T>(Comparable<T> getField(OmsetAreaModel d), int columnIndex,
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
        title: const Text('Omset Area'),
      ),
      body: RefreshIndicator(
        key: refreshKey,
        child: Scrollbar(
          child: ListView(
            padding: const EdgeInsets.all(20.0),
            children: <Widget>[
              dataArea(),
            ],
          ),
        ),
        onRefresh: refreshList,
      ),
    );
  }

  Widget dataArea() {
    return PaginatedDataTable(
      header: Text(nama_regional),
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
          label: const Text('Area'),
          onSort: (int columnIndex, bool ascending) => _sort<String>(
                  (OmsetAreaModel d) => d.nama_area,
              columnIndex,
              ascending),
        ),
        DataColumn(
          label: const Text('Day'),
          onSort: (int columnIndex, bool ascending) => _sort<num>(
                  (OmsetAreaModel d) => d.persentase_harian,
              columnIndex,
              ascending),
        ),
        DataColumn(
          label: const Text('MTD'),
          onSort: (int columnIndex, bool ascending) => _sort<num>(
                  (OmsetAreaModel d) => d.persentase,
              columnIndex,
              ascending),
        ),
        DataColumn(
          label: const Text('Target'),
          onSort: (int columnIndex, bool ascending) => _sort<num>(
                  (OmsetAreaModel d) => d.target_value,
              columnIndex,
              ascending),
        ),
        /*DataColumn(
                    label: const Text('Target Volume'),
                    numeric: true,
                    onSort: (int columnIndex, bool ascending) => _sort<num>((OmsetAreaModel d) => d.target_volume, columnIndex, ascending),
                  ),*/
        DataColumn(
          label: const Text('Realisasi'),
          onSort: (int columnIndex, bool ascending) => _sort<num>(
                  (OmsetAreaModel d) => d.net_exc_ppn,
              columnIndex,
              ascending),
        ),
      ],
      source: _omsetDataSource,
    );
  }
}
