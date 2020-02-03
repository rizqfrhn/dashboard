import '../Model/dashboard.dart';
import '../services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:data_tables/data_tables.dart';

class Dashboard extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Dashboard> {
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  int _sortColumnIndex;
  bool _sortAscending = true;
  List<DashboardModel> _list = [];
  var loading = false;

  _fetchData() async {
    setState(() {
      loading = true;
    });
    final response =
    await http.get(
        "${url}/GetChannel");
    if (response.statusCode == 200) {
      _list = (json.decode(response.body)['Table'] as List)
          .map((data) => new DashboardModel.fromJson(data))
          .toList();
      setState(() {
        loading = false;
        _items = _list;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchData();
  }

  void _sort<T>(
      Comparable<T> getField(DashboardModel d), int columnIndex, bool ascending) {
    _items.sort((DashboardModel a, DashboardModel b) {
      if (!ascending) {
        final DashboardModel c = a;
        a = b;
        b = c;
      }
      final Comparable<T> aValue = getField(a);
      final Comparable<T> bValue = getField(b);
      return Comparable.compare(aValue, bValue);
    });
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  List<DashboardModel> _items = [];
  int _rowsOffset = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NativeDataTable.builder(
        rowsPerPage: _rowsPerPage,
        itemCount: _items?.length ?? 0,
        firstRowIndex: _rowsOffset,
        handleNext: () async {
          setState(() {
            _rowsOffset += _rowsPerPage;
          });
        },
        handlePrevious: () {
          setState(() {
            _rowsOffset -= _rowsPerPage;
          });
        },
        itemBuilder: (int index) {
          final DashboardModel dashboard = _items[index];
          return DataRow.byIndex(
              index: index,
              selected: dashboard.selected,
              onSelectChanged: (bool value) {
                if (dashboard.selected != value) {
                  setState(() {
                    dashboard.selected = value;
                  });
                }
              },
              cells: <DataCell>[
                DataCell(Text('${dashboard.nama_channel}')),
                DataCell(Text('${dashboard.kode_channel}')),
                DataCell(Text('${dashboard.status_aktif}')),
              ]);
        },
        header: const Text('Data Management'),
        sortColumnIndex: _sortColumnIndex,
        sortAscending: _sortAscending,
        onRefresh: () async {
          await new Future.delayed(new Duration(seconds: 3));
          setState(() {
            _items = _list;
          });
          return null;
        },
        onRowsPerPageChanged: (int value) {
          setState(() {
            _rowsPerPage = value;
          });
          /*print("New Rows: $value");*/
        },
        // mobileItemBuilder: (BuildContext context, int index) {
        //   final i = _desserts[index];
        //   return ListTile(
        //     title: Text(i?.name),
        //   );
        // },
        onSelectAll: (bool value) {
          for (var row in _items) {
            setState(() {
              row.selected = value;
            });
          }
        },
        rowCountApproximate: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () {},
          ),
        ],
        selectedActions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              setState(() {
                for (var item in _items
                    ?.where((d) => d?.selected ?? false)
                    ?.toSet()
                    ?.toList()) {
                  _items.remove(item);
                }
              });
            },
          ),
        ],
        columns: <DataColumn>[
          DataColumn(
              label: const Text('Channel Name'),
              onSort: (int columnIndex, bool ascending) => _sort<String>(
                      (DashboardModel d) => d.nama_channel, columnIndex, ascending)),
          DataColumn(
              label: const Text('Channel Code'),
              onSort: (int columnIndex, bool ascending) => _sort<String>(
                      (DashboardModel d) => d.kode_channel, columnIndex, ascending)),
          DataColumn(
              label: const Text('Active Status'),
              onSort: (int columnIndex, bool ascending) =>
                  _sort<String>((DashboardModel d) => d.status_aktif, columnIndex, ascending)),
        ],
      ),
    );
  }
}