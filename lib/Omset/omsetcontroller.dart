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
import 'package:fl_chart/fl_chart.dart';

//GENERAL//

class FlutterMoneyFormatter {
  FlutterMoneyFormatter({@required this.amount,}){}

  double amount;

  String get compact {
    String compacted = NumberFormat.compact(locale: "in").format(amount);
    return 'Rp. $compacted';
  }
  String get compactNonSymbol {
    String compacted = NumberFormat.compact(locale: "in").format(amount);
    return '$compacted';
  }
}

// OMSET //

List<OmsetTotalModel> list = [];
List<OmsetSOModel> listSO = [];
List<OmsetTagihModel> listTagihan = [];
List<PeriodeModel> listPeriode = [];
List<BrandModel> listBrand = [];
List<TokoModel> listToko = [];
List<RuteModel> listRute = [];
List<OmsetCallECModel> listCallEC = [];
List<OmsetLineChartModel> listLineChart = [];
Map<DateTime, double> lineChartSO = lineSO();
Map<DateTime, double> lineChartSJ = lineSJ();
Map<DateTime, double> lineChartTG = lineTagihan();
bool loading = false;
var refreshKey = GlobalKey<RefreshIndicatorState>();
PeriodeModel periodeSelection;
double target = 0, realisasi = 0, persentase = 0,
    targetHari = 0, realisasiHari = 0, persentaseHari = 0;
double so = 0, sj = 0, fk = 0, persentase_kirim = 0, persentase_faktur = 0;
double totalToko = 0, totalOrderSO = 0, persentaseToko = 0, totalRute = 0,
    totalTokoRute = 0, persentaseRute = 0;
double targetTagihan = 0, totalBayar = 0, persentaseTagihan = 0,
    targetTagihanHari = 0, totalBayarHari = 0, persentaseTagihanHari = 0;
double targetOmset = 0, rataCall = 0, rataEC = 0,
    rataFk = 0, jumlahSales = 0, estimasiPersentase = 0;
double targetOmsetLast = 0, rataCallLast = 0, rataECLast = 0,
    rataFkLast = 0, jumlahSalesLast = 0, estimasiPersentaseLast = 0;
var now = new DateTime.now();
int monthChart = now.month;
int yearChart = now.year;

Default() {
  list.clear();
  listSO.clear();
  listTagihan.clear();
  listPeriode.clear();
  listBrand.clear();
  listToko.clear();
  listCallEC.clear();
  listLineChart.clear();
  listRute.clear();
  target = 0; realisasi = 0; persentase = 0;
  targetHari = 0; realisasiHari = 0; persentaseHari = 0;
  so = 0; sj = 0; fk = 0; persentase_kirim = 0; persentase_faktur = 0;
  totalToko = 0; totalOrderSO = 0; persentaseToko = 0; totalRute = 0;
  totalTokoRute = 0; persentaseRute = 0;
  targetTagihan = 0; totalBayar = 0; persentaseTagihan = 0;
  targetTagihanHari = 0; totalBayarHari = 0; persentaseTagihanHari = 0;
  targetOmset = 0; rataCall = 0; rataEC = 0;
  rataFk = 0; jumlahSales = 0; estimasiPersentase = 0;
  targetOmsetLast = 0; rataCallLast = 0; rataECLast = 0;
  rataFkLast = 0; jumlahSalesLast = 0; estimasiPersentaseLast = 0;
}

fetchDataChart(String nik, String periode) async {
  Map dataParam = {
    'lokasi': '',
    'nik': nik,
    'periode': periode
  };

  var responselineChart =
  await http.post(
      '${url}/GetWidgetHarianChart?',
      body: dataParam);
  if (responselineChart.statusCode == 200) {
    listLineChart = (json.decode(responselineChart.body)['Table'] as List)
        .map((data) => new OmsetLineChartModel.fromJson(data))
        .toList();
    lineChartSO = lineSO();
    lineChartSJ = lineSJ();
    lineChartTG = lineTagihan();
  }
}

fetchDataBrand(String nik, String periode) async {
  Map dataParam = {
    'lokasi': '',
    'nik': nik,
    'periode': periode
  };

  var responseBrand =
  await http.post(
      '${url}/GetDataBrandPareto?',
      body: dataParam);
  if (responseBrand.statusCode == 200) {
    listBrand = (json.decode(responseBrand.body)['Table'] as List)
        .map((data) => new BrandModel.fromJson(data))
        .toList();
  }
}

fetchDataCallEC(String nik, String periode) async {
  Map dataParam = {
    'lokasi': '',
    'nik': nik,
    'periode': periode
  };

  var responseCallEC =
  await http.post(
      '${url}/GetWidgetCallEc?',
      body: dataParam);
  if (responseCallEC.statusCode == 200) {
    listCallEC = (json.decode(responseCallEC.body)['Table'] as List)
        .map((data) => new OmsetCallECModel.fromJson(data))
        .toList();
    targetOmset = listCallEC[0].target_omset;
    rataCall = listCallEC[0].rata_call;
    rataEC = listCallEC[0].rata_ec;
    rataFk = listCallEC[0].rata_fk;
    jumlahSales = listCallEC[0].jumlah_sales;
    estimasiPersentase = listCallEC[0].estimasi_persentase;
    targetOmsetLast = listCallEC[0].target_omset_last;
    rataCallLast = listCallEC[0].rata_call_last;
    rataECLast = listCallEC[0].rata_ec_last;
    rataFkLast = listCallEC[0].rata_fk_last;
    jumlahSalesLast = listCallEC[0].jumlah_sales_last;
    estimasiPersentaseLast = listCallEC[0].estimasi_persentase_last;
  }
}

fetchDataDsToko(String nik, String periode) async {
// Detail Toko
  Map dataToko = {
    'lokasi': '',
    'periode': periode,
    'nik': nik,
    'nikSales' : ''
  };

  var responseToko =
  await http.post(
      '${url}/GetDataPersentaseToko?',
      body: dataToko);
  if (responseToko.statusCode == 200) {
    listToko = (json.decode(responseToko.body)['Table'] as List)
        .map((data) => new TokoModel.fromJson(data))
        .toList();
    totalToko = listToko[0].total;
    totalOrderSO = listToko[0].total_order_so;
    persentaseToko = listToko[0].persentase;
  }
}

fetchDataRute(String nik, String periode) async {
// Detail Toko
  Map dataRute = {
    'lokasi': '',
    'periode': periode,
    'nik': nik,
  };

  var responseRute =
  await http.post(
      '${url}/GetSumRuteToko?',
      body: dataRute);
  if (responseRute.statusCode == 200) {
    listRute = (json.decode(responseRute.body)['Table'] as List)
        .map((data) => new RuteModel.fromJson(data))
        .toList();
    totalRute = listRute[0].total_rute;
    totalTokoRute = listRute[0].total_toko;
    persentaseRute = listRute[0].persentase;
  }
}

fetchDataTagihan(String nik, String periode) async {
  Map dataOmset = {
    'lokasi': '',
    'tahun': '',
    'minggu': '',
    'nik': nik,
    'periode': periode
  };

  var responseTagihan =
  await http.post(
      '${url}/GetWidgetDashboardTagihanTotal?',
      body: dataOmset);
  if (responseTagihan.statusCode == 200) {
    listTagihan = (json.decode(responseTagihan.body)['Table'] as List)
        .map((data) => new OmsetTagihModel.fromJson(data))
        .toList();
    targetTagihan = listTagihan[0].target_tagih;
    totalBayar = listTagihan[0].total_bayar;
    persentaseTagihan = listTagihan[0].persentase;
    targetTagihanHari = listTagihan[0].target_hari;
    totalBayarHari = listTagihan[0].total_bayar_hari;
    persentaseTagihanHari = listTagihan[0].persentase_hari;
  }
}

fetchDataSO(String nik, String periode) async {
// Detail SO
  Map dataParam = {
    'lokasi': '',
    'nik': nik,
    'periode': periode
  };

  var responseSO =
  await http.post(
      '${url}/GetWidgetOrder?',
      body: dataParam);
  if (responseSO.statusCode == 200) {
    listSO = (json.decode(responseSO.body)['Table'] as List)
        .map((data) => new OmsetSOModel.fromJson(data))
        .toList();
    so = listSO[0].so;
    sj = listSO[0].sj;
    fk = listSO[0].fk;
    persentase_kirim = listSO[0].persentase_kirim;
    persentase_faktur = listSO[0].persentase_faktur;
  }
}

fetchData(String nik, String periode) async {
// Detail Omset & Tagihan
  Map dataOmset = {
    'lokasi': '',
    'tahun': '',
    'minggu': '',
    'nik': nik,
    'periode': periode
  };

  var response =
  await http.post(
      '${url}/GetWidgetDashboardNewOmsetAreaTotal?',
      body: dataOmset);
  if (response.statusCode == 200) {
    list = (json.decode(response.body)['Table'] as List)
        .map((data) => new OmsetTotalModel.fromJson(data))
        .toList();
    target = list[0].target_omset;
    realisasi = list[0].net_exc_ppn;
    persentase = list[0].persentase;
    targetHari = list[0].target_omset_hari;
    realisasiHari = list[0].net_exc_ppn_hari;
    persentaseHari = list[0].persentase_hari;
  }

// Periode
  var responsePeriode =
  await http.post(
      '${url}/GetDataPeriode');
  if (responsePeriode.statusCode == 200) {
    listPeriode = (json.decode(responsePeriode.body)['Table'] as List)
        .map((data) => new PeriodeModel.fromJson(data))
        .toList();
  }
}

/*fetchDataTotal(String nik, String periode) async {
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
    target = list[0].target_omset;
    realisasi = list[0].net_exc_ppn;
    persentase = list[0].persentase;
    target_hari = list[0].target_omset_hari;
    realisasi_hari = list[0].net_exc_ppn_hari;
    persentase_hari = list[0].persentase_hari;
  }
}

fetchDataSO(String nik, String periode) async {
  Map data = {
    'lokasi': '',
    'nik': nik,
    'periode': periode
  };

  var response =
  await http.post(
      '${url}/GetWidgetOrder?',
      body: data);
  if (response.statusCode == 200) {
    listSO = (json.decode(response.body)['Table'] as List)
        .map((data) => new OmsetSOModel.fromJson(data))
        .toList();
    so = listSO[0].so;
    sj = listSO[0].sj;
    fk = listSO[0].fk;
    persentase_kirim = listSO[0].persentase_kirim;
    persentase_faktur = listSO[0].persentase_faktur;
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
}*/

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

  return compute(parseOmset, response.body);
}

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
            percent: omset.persentase_harian / 100 <= 0.0 ? 0.0 :
            omset.persentase_harian / 100 >= 1.0 ? 1.0 :
            omset.persentase_harian / 100,
            center: Text('${omset.persentase_harian.toStringAsFixed(2)}%', style: TextStyle(color: Colors.white)),
            linearStrokeCap: LinearStrokeCap.roundAll,
            progressColor: omset.persentase_harian <= 80 ? Colors.red :
            omset.persentase_harian <= 90 ? Colors.orange :
            Colors.green,
          ),
        ), onTap: () {Navigator.push(
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
        DataCell(Text(FlutterMoneyFormatter(amount: omset.target_omset).compact), onTap: () {Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OmsetArea(nama_regional: omset.nama_regional, nik: nik, periode: periode,)),
        );}),
        /*DataCell(Text('${omset.target_volume.toStringAsFixed(0)}')),*/
        DataCell(Text(FlutterMoneyFormatter(amount: omset.net_exc_ppn).compact), onTap: () {Navigator.push(
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

LineChartData chartData() {
  return LineChartData(
    lineTouchData: LineTouchData(
      touchTooltipData: LineTouchTooltipData(
        tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
      ),
      touchCallback: (LineTouchResponse touchResponse) {
        print(touchResponse);
      },
      handleBuiltInTouches: true,
    ),
    gridData: const FlGridData(
      show: false,
    ),
    titlesData: FlTitlesData(
      bottomTitles: SideTitles(
        showTitles: true,
        reservedSize: 22,
        textStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        margin: 10,
        getTitles: (value) {
          switch (value.toInt()) {
            case 2:
              return 'SEPT';
            case 7:
              return 'OCT';
            case 12:
              return 'DEC';
          }
          return '';
        },
      ),
      leftTitles: SideTitles(
        showTitles: true,
        textStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        getTitles: (value) {
          switch (value.toInt()) {
            case 1:
              return '1m';
            case 2:
              return '2m';
            case 3:
              return '3m';
            case 4:
              return '5m';
          }
          return '';
        },
        margin: 8,
        reservedSize: 30,
      ),
    ),
    borderData: FlBorderData(
      show: true,
      border: Border(
        bottom: BorderSide(
          color: Colors.white,
          width: 3,
        ),
        left: BorderSide(
          color: Colors.transparent,
        ),
        right: BorderSide(
          color: Colors.transparent,
        ),
        top: BorderSide(
          color: Colors.transparent,
        ),
      ),
    ),
    minX: 0,
    maxX: 14,
    maxY: 4,
    minY: 0,
    lineBarsData: linesBarData(),
  );
}

List<LineChartBarData> linesBarData() {
  LineChartBarData lineChart1 = const LineChartBarData(
    spots: [
      FlSpot(1, 1),
      FlSpot(3, 1.5),
      FlSpot(5, 1.4),
      FlSpot(7, 3.4),
      FlSpot(10, 2),
      FlSpot(12, 2.2),
      FlSpot(13, 1.8),
    ],
    isCurved: true,
    colors: [
      Color(0xff4af699),
    ],
    barWidth: 8,
    isStrokeCapRound: true,
    dotData: FlDotData(
      show: false,
    ),
    belowBarData: BarAreaData(
      show: false,
    ),
  );
  final LineChartBarData lineChart2 = LineChartBarData(
    spots: [
      FlSpot(1, 1),
      FlSpot(3, 2.8),
      FlSpot(7, 1.2),
      FlSpot(10, 2.8),
      FlSpot(12, 2.6),
      FlSpot(13, 3.9),
    ],
    isCurved: true,
    colors: [
      Color(0xffaa4cfc),
    ],
    barWidth: 8,
    isStrokeCapRound: true,
    dotData: FlDotData(
      show: false,
    ),
    belowBarData: BarAreaData(show: false, colors: [
      Color(0x00aa4cfc),
    ]),
  );
  return [
    lineChart1,
    lineChart2,
  ];
}

Map<DateTime, double> lineSO() {
  Map<DateTime, double> data = {};

  if (listLineChart.length != 0) {
    for (var i in listLineChart)
      data[DateTime(i.tahun, i.bulan, i.tgl)] = i.total_so;
  } else {
    data[DateTime.now()] = 0;
  }

  return data;
}

Map<DateTime, double> lineSJ() {
  Map<DateTime, double> data = {};

  if (listLineChart.length != 0) {
    for (var i in listLineChart)
      data[DateTime(i.tahun, i.bulan, i.tgl)] = i.total_harga_sj;
  } else {
    data[DateTime.now()] = 0;
  }

  return data;
}

Map<DateTime, double> lineTagihan() {
  Map<DateTime, double> data = {};

  if (listLineChart.length != 0) {
    for (var i in listLineChart)
      data[DateTime(i.tahun, i.bulan, i.tgl)] = i.total_bayar;
  } else {
    data[DateTime.now()] = 0;
  }

  return data;
}

// OMSET AREA //

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

  return compute(parseOmsetArea, response.body);
}

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
                percent: omsetArea.persentase_harian / 100 <= 0.0
                    ? 0.0
                    : omsetArea.persentase_harian / 100 >= 1.0
                    ? 1.0
                    : omsetArea.persentase_harian / 100,
                center: Text('${omsetArea.persentase_harian.toStringAsFixed(2)}%',
                    style: TextStyle(color: Colors.white)),
                linearStrokeCap: LinearStrokeCap.roundAll,
                progressColor: omsetArea.persentase_harian <= 80
                    ? Colors.red : omsetArea.persentase_harian <= 90
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
        DataCell(Text(FlutterMoneyFormatter(amount: omsetArea.target_value).compact), onTap: () { Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OmsetSales(
            areaKey: omsetArea.area_key,
            areaName: omsetArea.nama_area,
            nik: nik,
            periode: periode,)),
        );}),
        /*DataCell(Text('${omset.target_volume.toStringAsFixed(0)}')),*/
        DataCell(Text(FlutterMoneyFormatter(amount: omsetArea.net_exc_ppn).compact), onTap: () { Navigator.push(
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

// OMSET SALES //

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

  return compute(parseOmsetSales, response.body);
}

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
        DataCell(Text(FlutterMoneyFormatter(amount: omsetSales.target_value).compact), onTap: () { Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OmsetToko(
              areaKey: areaKey,
              nik: nik,
              periode: periode,
              nikSales: omsetSales.nik,
              salesName: omsetSales.nama_sales)),
        );}),
        /*DataCell(Text('${omset.target_volume.toStringAsFixed(0)}')),*/
        DataCell(Text(FlutterMoneyFormatter(amount: omsetSales.net_exc_ppn).compact), onTap: () { Navigator.push(
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
        DataCell(Text(FlutterMoneyFormatter(amount: omsetSales.target_tagih).compact), onTap: () { Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OmsetToko(
              areaKey: areaKey,
              nik: nik,
              periode: periode,
              nikSales: omsetSales.nik,
              salesName: omsetSales.nama_sales)),
        );}),
        DataCell(Text(FlutterMoneyFormatter(amount: omsetSales.total_bayar).compact), onTap: () { Navigator.push(
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

// OMSET TOKO //

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

  return compute(parseOmsetToko, response.body);
}

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
        DataCell(Text(FlutterMoneyFormatter(amount: omsetToko.target_value).compact)),
        /*DataCell(Text('${omset.target_volume.toStringAsFixed(0)}')),*/
        DataCell(Text(FlutterMoneyFormatter(amount: omsetToko.net_exc_ppn).compact)),
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