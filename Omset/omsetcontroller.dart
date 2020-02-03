import 'omsetarea.dart';
import 'omsetsales.dart';
import 'omsettoko.dart';
import 'omsetmodel.dart';
import '../services.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:percent_indicator/percent_indicator.dart';

//GENERAL//

class FlutterMoneyFormatter {
  FlutterMoneyFormatter({/*@required this.symbol,*/
    @required this.amount,
    /*@required this.fractionDigits*/}) {
    /*this.symbol = this.symbol ?? '\$';
    this.fractionDigits = this.fractionDigits ?? 2;*/
    String output = compactNonSymbol;
  }

  // The [symbol] that will be used on formatted output, default value is $ (Dollar Sign)
  /*String symbol;*/
  double amount;
  // The fraction digits that will be used on formatted output, default value is 2.
  /*int fractionDigits;*/


  String get compactNonSymbol {
    String compacted = NumberFormat.compact(locale: "in").format(amount);
    return 'Rp. $compacted';
    /*String numerics = RegExp(r'(\d+\.\d+)|(\d+)')
        .allMatches(compacted)
        .map((_) => _.group(0))
        .toString()
        .replaceAll('(', '')
        .replaceAll(')', '');

    String alphas = compacted.replaceAll(numerics, '');

    String reformat = NumberFormat.currency(
        symbol: symbol,
        decimalDigits: numerics.indexOf('.') == -1 ? 0 : fractionDigits)
        .format(num.parse(numerics));

    return '$reformat $alphas';*/
  }
}

/*Widget value_({String value1, String value2, String separator, Color color}) {
  return new Container(
    child: new Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Text(value1, style: TextStyle(color: color)),
          new Container(width: 8.0),
          new Text(separator, style: TextStyle(color: color)),
          new Container(width: 8.0),
          new Text(value2, style: TextStyle(color: color)),
        ]
    ),
  );
}*/

//OMSET//

List<OmsetTotalModel> list = [];
List<PeriodeModel> periodelist = [];
List<BrandModel> brandlist = [];
List<TokoModel> orderSOlist = [];
var loading = false;
var refreshKey = GlobalKey<RefreshIndicatorState>();
PeriodeModel periodeSelection;
double persentase = 0;
double target = 0;
double realisasi = 0;
double totalToko = 0;
double totalOrderSO = 0;
double persentaseToko = 0;

Future<List<OmsetModel>> fetchResultOmset(http.Client client, String nik, String periode) async {
  Map data = {
    'lokasi' : '',
    'tahun': '',
    'minggu': '',
    'nik': nik,
    'periode': periode
  };

  final response =
  await client.post('${url}/GetDataOmsetRegionalGabung?', body: data);

  // Use the compute function to run parsePhotos in a separate isolate.
  return compute(parseOmset, response.body);
}

// A function that converts a response body into a List<Photo>.
List<OmsetModel> parseOmset(String responseBody) {
  final parsed = jsonDecode(responseBody)['Table'].cast<Map<String, dynamic>>();

  return parsed.map<OmsetModel>((json) => OmsetModel.fromJson(json)).toList();
}

class OmsetDataSource extends DataTableSource {
  final String nik;
  final String periode;
  final List<OmsetModel> _items;
  final BuildContext context;
  OmsetDataSource(this._items, this.nik, this.periode, this.context);

  void sort<T>(Comparable<T> getField(OmsetModel d), bool ascending) {
    _items.sort((OmsetModel a, OmsetModel b) {
      if (!ascending) {
        final OmsetModel c = a;
        a = b;
        b = c;
      }
      final Comparable<T> aValue = getField(a);
      final Comparable<T> bValue = getField(b);
      return Comparable.compare(aValue, bValue);
    });
    notifyListeners();
  }

  int _selectedCount = 0;

  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    if (index >= _items.length)
      return null;
    final OmsetModel omset = _items[index];
    return DataRow.byIndex(
      index: index,
      /*selected: omset.selected,
      onSelectChanged: (bool value) {
        if (omset.selected != value) {
          _selectedCount += value ? 1 : -1;
          assert(_selectedCount >= 0);
          omset.selected = value;
          notifyListeners();
        }
      },*/
      cells: <DataCell>[
        DataCell(Container(child: Text('${omset.nama_regional}'), width: 80.0), onTap: () {Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OmsetArea(nama_regional: omset.nama_regional, nik: nik, periode: periode,)),
        );}),
        DataCell(Padding(
          padding: EdgeInsets.all(0.0),
          child: new LinearPercentIndicator(
            width: 75,
            animation: true,
            lineHeight: 20.0,
            animationDuration: 2000,
            percent: omset.persentase_bulan / 100 <= 0.0 ? 0.0 :
            omset.persentase_bulan / 100 >= 1.0 ? 1.0 :
            omset.persentase_bulan / 100,
            center: Text('${omset.persentase_bulan.toStringAsFixed(2)}%', style: TextStyle(color: Colors.white)),
            linearStrokeCap: LinearStrokeCap.roundAll,
            progressColor: omset.persentase_bulan <= 80 ? Colors.red :
            omset.persentase_bulan <= 90 ? Colors.orange :
            Colors.green,
            /*progressColor: omset.persentase_bulan <= 40 ? Colors.red :
            omset.persentase_bulan <= 60 ? Colors.amberAccent :
            omset.persentase_bulan <= 80 ? Colors.lightBlueAccent :
            omset.persentase_bulan <= 90 ? Colors.lightGreen :
            Colors.green,*/
          ),
        ), onTap: () {Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OmsetArea(nama_regional: omset.nama_regional, nik: nik, periode: periode,)),
        );}/*Text('${omset.persentase_bulan.toStringAsFixed(2)}')*/),
        DataCell(Text(FlutterMoneyFormatter(amount: omset.target_omset).compactNonSymbol), onTap: () {Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OmsetArea(nama_regional: omset.nama_regional, nik: nik, periode: periode,)),
        );}),
        /*DataCell(Text('${omset.target_volume.toStringAsFixed(0)}')),*/
        DataCell(Text(FlutterMoneyFormatter(amount: omset.net_exc_ppn).compactNonSymbol), onTap: () {Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OmsetArea(nama_regional: omset.nama_regional, nik: nik, periode: periode,)),
        );}),
      ],
    );
  }

  @override
  int get rowCount => _items.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;

  void _selectAll(bool checked) {
    for (OmsetModel dessert in _items)
      dessert.selected = checked;
    _selectedCount = checked ? _items.length : 0;
    notifyListeners();
  }
}

fetchDataTotal(String nik, String periode) async {
  Map data = {
    'lokasi': '',
    'tahun': '',
    'minggu': '',
    'nik': nik,
    'periode': periode
  };

  var response =
  await http.post(
      '${url}/GetWidgetDashboardNewOmsetAreaTotal?',
      body: data);
  if (response.statusCode == 200) {
    list = (json.decode(response.body)['Table'] as List)
        .map((data) => new OmsetTotalModel.fromJson(data))
        .toList();
    persentase = list[0].persentase;
    target = list[0].target_omset;
    realisasi = list[0].net_exc_ppn;
  }
}

fetchToko(String nik, String periode) async {
  Map data = {
    'lokasi': '',
    'periode': periode,
    'nik': nik,
    'nikSales' : ''
  };

  var response =
  await http.post(
      '${url}/GetDataPersentaseToko?',
      body: data);
  if (response.statusCode == 200) {
    orderSOlist = (json.decode(response.body)['Table'] as List)
        .map((data) => new TokoModel.fromJson(data))
        .toList();
    totalToko = orderSOlist[0].total;
    totalOrderSO = orderSOlist[0].total_order_so;
    persentaseToko = orderSOlist[0].persentase;
  }
}

fetchBrand(String nik, String periode) async {
  Map data = {
    'lokasi': '',
    'periode': periode,
    'nik': nik
  };

  var response =
  await http.post(
      '${url}/GetDataBrandPareto?',
      body: data);
  if (response.statusCode == 200) {
    brandlist = (json.decode(response.body)['Table'] as List)
        .map((data) => new BrandModel.fromJson(data))
        .toList();
  }
}

fetchDataPeriode() async {
  var response =
  await http.post(
      '${url}/GetDataPeriode');
  if (response.statusCode == 200) {
    periodelist = (json.decode(response.body)['Table'] as List)
        .map((data) => new PeriodeModel.fromJson(data))
        .toList();
  }
}

//OMSET AREA//

Future<List<OmsetAreaModel>> fetchResultArea(
    http.Client client, String regional, String nik, String periode) async {
  Map data = {
    'rawSearch': '',
    'lokasi': regional,
    'periode': periode,
    'nik': nik
  };

  final response = await client.post(
      '${url}/GetWidgetDashboardNewOmsetArea?',
      body: data);

  // Use the compute function to run parsePhotos in a separate isolate.
  return compute(parseOmsetArea, response.body);
}

// A function that converts a response body into a List<Photo>.
List<OmsetAreaModel> parseOmsetArea(String responseBody) {
  final parsed = jsonDecode(responseBody)['Table'].cast<Map<String, dynamic>>();

  return parsed
      .map<OmsetAreaModel>((json) => OmsetAreaModel.fromJson(json))
      .toList();
}

class OmsetAreaDataSource extends DataTableSource {
  final String nik;
  final String periode;
  final List<OmsetAreaModel> _items;
  final BuildContext context;

  OmsetAreaDataSource(this._items, this.nik, this.periode, this.context);

  void sort<T>(Comparable<T> getField(OmsetAreaModel d), bool ascending) {
    _items.sort((OmsetAreaModel a, OmsetAreaModel b) {
      if (!ascending) {
        final OmsetAreaModel c = a;
        a = b;
        b = c;
      }
      final Comparable<T> aValue = getField(a);
      final Comparable<T> bValue = getField(b);
      return Comparable.compare(aValue, bValue);
    });
    notifyListeners();
  }

  int _selectedCount = 0;

  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    if (index >= _items.length) return null;
    final OmsetAreaModel omsetArea = _items[index];
    return DataRow.byIndex(
      index: index,
      cells: <DataCell>[
        DataCell(Container(child: Text('${omsetArea.nama_area}'), width: 80.0), onTap: () { Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OmsetSales(
            areaKey: omsetArea.area_key,
            areaName: omsetArea.nama_area,
            nik: nik,
            periode: periode,)),
        );}),
        DataCell(
            Padding(
              padding: EdgeInsets.all(0.0),
              child: new LinearPercentIndicator(
                width: 75,
                animation: true,
                lineHeight: 20.0,
                animationDuration: 2000,
                percent: omsetArea.persentase / 100 <= 0.0
                    ? 0.0
                    : omsetArea.persentase / 100 >= 1.0
                    ? 1.0
                    : omsetArea.persentase / 100,
                center: Text('${omsetArea.persentase.toStringAsFixed(2)}%',
                    style: TextStyle(color: Colors.white)),
                linearStrokeCap: LinearStrokeCap.roundAll,
                progressColor: omsetArea.persentase <= 80
                    ? Colors.red : omsetArea.persentase <= 90
                    ? Colors.orange
                    : Colors.green,
              ),
            ),
            onTap: () { Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => OmsetSales(
                areaKey: omsetArea.area_key,
                areaName: omsetArea.nama_area,
                nik: nik,
                periode: periode,)),
            );
            }
        ),
        DataCell(Text(FlutterMoneyFormatter(amount: omsetArea.target_value).compactNonSymbol), onTap: () { Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OmsetSales(
            areaKey: omsetArea.area_key,
            areaName: omsetArea.nama_area,
            nik: nik,
            periode: periode,)),
        );}),
        /*DataCell(Text('${omset.target_volume.toStringAsFixed(0)}')),*/
        DataCell(Text(FlutterMoneyFormatter(amount: omsetArea.net_exc_ppn).compactNonSymbol), onTap: () { Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OmsetSales(
            areaKey: omsetArea.area_key,
            areaName: omsetArea.nama_area,
            nik: nik,
            periode: periode,)),
        );}),
      ],
    );
  }

  @override
  int get rowCount => _items.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;

  void _selectAll(bool checked) {
    for (OmsetAreaModel dessert in _items) dessert.selected = checked;
    _selectedCount = checked ? _items.length : 0;
    notifyListeners();
  }
}

//OMSET SALES//

Future<List<OmsetSalesModel>> fetchResultSales(
    http.Client client, String regional, String nik, String periode) async {
  Map data = {
    'lokasi': regional,
    'periode': periode,
    'nik': nik,
  };

  final response = await client.post(
      '${url}/GetDetailOmsetSales?',
      body: data);

  // Use the compute function to run parsePhotos in a separate isolate.
  return compute(parseOmsetSales, response.body);
}

// A function that converts a response body into a List<Photo>.
List<OmsetSalesModel> parseOmsetSales(String responseBody) {
  final parsed = jsonDecode(responseBody)['Table'].cast<Map<String, dynamic>>();

  return parsed
      .map<OmsetSalesModel>((json) => OmsetSalesModel.fromJson(json))
      .toList();
}

class OmsetSalesDataSource extends DataTableSource {
  final String nik;
  final String periode;
  final String areaKey;
  final List<OmsetSalesModel> _items;
  final BuildContext context;

  OmsetSalesDataSource(this._items, this.nik, this.periode, this.areaKey, this.context);

  void sort<T>(Comparable<T> getField(OmsetSalesModel d), bool ascending) {
    _items.sort((OmsetSalesModel a, OmsetSalesModel b) {
      if (!ascending) {
        final OmsetSalesModel c = a;
        a = b;
        b = c;
      }
      final Comparable<T> aValue = getField(a);
      final Comparable<T> bValue = getField(b);
      return Comparable.compare(aValue, bValue);
    });
    notifyListeners();
  }

  int _selectedCount = 0;

  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    if (index >= _items.length)
      return null;
    final OmsetSalesModel omsetSales = _items[index];
    return DataRow.byIndex(
      index: index,
      cells: <DataCell>[
        DataCell(Container(child: Text('${omsetSales.nama_sales}'), width: 80.0), onTap: () { Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OmsetToko(
              areaKey: areaKey,
              nik: nik,
              periode: periode,
              nikSales: omsetSales.nik,
              salesName: omsetSales.nama_sales)),
        );}),
        DataCell(
            Padding(
              padding: EdgeInsets.all(0.0),
              child: new LinearPercentIndicator(
                width: 75,
                animation: true,
                lineHeight: 20.0,
                animationDuration: 2000,
                percent: omsetSales.persentase_omset / 100 <= 0.0
                    ? 0.0
                    : omsetSales.persentase_omset / 100 >= 1.0
                    ? 1.0
                    : omsetSales.persentase_omset / 100,
                center: Text('${omsetSales.persentase_omset.toStringAsFixed(2)}%',
                    style: TextStyle(color: Colors.white)),
                linearStrokeCap: LinearStrokeCap.roundAll,
                progressColor: omsetSales.persentase_omset <= 80
                    ? Colors.red : omsetSales.persentase_omset <= 90
                    ? Colors.orange
                    : Colors.green,
              ),
            ), onTap: () { Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OmsetToko(
              areaKey: areaKey,
              nik: nik,
              periode: periode,
              nikSales: omsetSales.nik,
              salesName: omsetSales.nama_sales)),
        );}
        ),
        DataCell(Text(FlutterMoneyFormatter(amount: omsetSales.target_value).compactNonSymbol), onTap: () { Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OmsetToko(
              areaKey: areaKey,
              nik: nik,
              periode: periode,
              nikSales: omsetSales.nik,
              salesName: omsetSales.nama_sales)),
        );}),
        /*DataCell(Text('${omset.target_volume.toStringAsFixed(0)}')),*/
        DataCell(Text(FlutterMoneyFormatter(amount: omsetSales.net_exc_ppn).compactNonSymbol), onTap: () { Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OmsetToko(
              areaKey: areaKey,
              nik: nik,
              periode: periode,
              nikSales: omsetSales.nik,
              salesName: omsetSales.nama_sales)),
        );}),
        DataCell(
            Padding(
              padding: EdgeInsets.all(0.0),
              child: new LinearPercentIndicator(
                width: 75,
                animation: true,
                lineHeight: 20.0,
                animationDuration: 2000,
                percent: omsetSales.persentase / 100 <= 0.0
                    ? 0.0
                    : omsetSales.persentase / 100 >= 1.0
                    ? 1.0
                    : omsetSales.persentase / 100,
                center: Text('${omsetSales.persentase.toStringAsFixed(2)}%',
                    style: TextStyle(color: Colors.white)),
                linearStrokeCap: LinearStrokeCap.roundAll,
                progressColor: omsetSales.persentase <= 80
                    ? Colors.red : omsetSales.persentase <= 90
                    ? Colors.orange
                    : Colors.green,
              ),
            ), onTap: () { Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OmsetToko(
              areaKey: areaKey,
              nik: nik,
              periode: periode,
              nikSales: omsetSales.nik,
              salesName: omsetSales.nama_sales)),
        );}
        ),
        DataCell(Text(FlutterMoneyFormatter(amount: omsetSales.target_tagih).compactNonSymbol), onTap: () { Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OmsetToko(
              areaKey: areaKey,
              nik: nik,
              periode: periode,
              nikSales: omsetSales.nik,
              salesName: omsetSales.nama_sales)),
        );}),
        DataCell(Text(FlutterMoneyFormatter(amount: omsetSales.total_bayar).compactNonSymbol), onTap: () { Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OmsetToko(
              areaKey: areaKey,
              nik: nik,
              periode: periode,
              nikSales: omsetSales.nik,
              salesName: omsetSales.nama_sales)),
        );}),
      ],
    );
  }

  @override
  int get rowCount => _items.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;

  void _selectAll(bool checked) {
    for (OmsetSalesModel dessert in _items) dessert.selected = checked;
    _selectedCount = checked ? _items.length : 0;
    notifyListeners();
  }
}

//OMSET TOKO//

Future<List<OmsetTokoModel>> fetchResultToko(
    http.Client client, String regional, String nik, String periode, String nikSales) async {
  Map data = {
    'lokasi': regional,
    'periode': periode,
    'nik': nik,
    'nikSales': nikSales
  };

  final response = await client.post(
      '${url}/GetDetailOmsetSalesToko?',
      body: data);

  // Use the compute function to run parsePhotos in a separate isolate.
  return compute(parseOmsetToko, response.body);
}

// A function that converts a response body into a List<Photo>.
List<OmsetTokoModel> parseOmsetToko(String responseBody) {
  final parsed = jsonDecode(responseBody)['Table'].cast<Map<String, dynamic>>();

  return parsed
      .map<OmsetTokoModel>((json) => OmsetTokoModel.fromJson(json))
      .toList();
}

class OmsetTokoDataSource extends DataTableSource {
  final String nik;
  final String periode;
  final String areaKey;
  final String nikSales;
  final List<OmsetTokoModel> _items;
  final BuildContext context;

  OmsetTokoDataSource(this._items, this.nik, this.periode, this.areaKey, this.nikSales, this.context);

  void sort<T>(Comparable<T> getField(OmsetTokoModel d), bool ascending) {
    _items.sort((OmsetTokoModel a, OmsetTokoModel b) {
      if (!ascending) {
        final OmsetTokoModel c = a;
        a = b;
        b = c;
      }
      final Comparable<T> aValue = getField(a);
      final Comparable<T> bValue = getField(b);
      return Comparable.compare(aValue, bValue);
    });
    notifyListeners();
  }

  int _selectedCount = 0;

  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    if (index >= _items.length) return null;
    final OmsetTokoModel omsetToko = _items[index];
    return DataRow.byIndex(
      index: index,
      cells: <DataCell>[
        DataCell(Container(child: Text('${omsetToko.nama_toko}'), width: 80.0)),
        DataCell(
          Padding(
            padding: EdgeInsets.all(0.0),
            child: new LinearPercentIndicator(
              width: 75,
              animation: true,
              lineHeight: 20.0,
              animationDuration: 2000,
              percent: omsetToko.persentase_omset / 100 <= 0.0
                  ? 0.0
                  : omsetToko.persentase_omset / 100 >= 1.0
                  ? 1.0
                  : omsetToko.persentase_omset / 100,
              center: Text('${omsetToko.persentase_omset.toStringAsFixed(2)}%',
                  style: TextStyle(color: Colors.white)),
              linearStrokeCap: LinearStrokeCap.roundAll,
              progressColor: omsetToko.persentase_omset <= 80
                  ? Colors.red : omsetToko.persentase_omset <= 90
                  ? Colors.orange
                  : Colors.green,
            ),
          ),
        ),
        DataCell(Text(FlutterMoneyFormatter(amount: omsetToko.target_value).compactNonSymbol)),
        /*DataCell(Text('${omset.target_volume.toStringAsFixed(0)}')),*/
        DataCell(Text(FlutterMoneyFormatter(amount: omsetToko.net_exc_ppn).compactNonSymbol)),
      ],
    );
  }

  @override
  int get rowCount => _items.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;

  void _selectAll(bool checked) {
    for (OmsetTokoModel dessert in _items) dessert.selected = checked;
    _selectedCount = checked ? _items.length : 0;
    notifyListeners();
  }
}