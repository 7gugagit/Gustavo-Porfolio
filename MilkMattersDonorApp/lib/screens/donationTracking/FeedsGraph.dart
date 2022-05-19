import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:milk_matters_donor_app/models/GraphFeedsDataPoint.dart';
import 'package:milk_matters_donor_app/services/LocalDatabaseService.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_core/core.dart';

/// The stateful widget which displays the 50ml feeds graph
class FeedsGraph extends StatefulWidget {

  @override
  /// Create the widget's state
  _FeedsGraphState createState() => _FeedsGraphState();
}

/// The widget's state
class _FeedsGraphState extends State<FeedsGraph> {

  @override
  Widget build(BuildContext context) {

    /// Register the Syncfusion license to provide access to the package
    SyncfusionLicense.registerLicense('NT8mJyc2IWhia31hfWN9Z2doYmF8YGJ8ampqanNiYmlmamlmanMDHmg3Oj08fTE8ICA6ZxM0PjI6P30wPD4=');
    /// Setup the provider to access the local SQL database
    final localDBProvider = Provider.of<LocalDatabaseService>(context);
    var iconColor = Colors.white;

    return Scaffold(
        body: Column(
          children: [
            Expanded(
              child: Padding(
                    padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                    // container to act as yellow background card
                    child: FutureBuilder(
                      future: localDBProvider.getAllTrackedDonationsForFeedGraph(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Container(child: Center(child: CupertinoActivityIndicator(radius: 50.0)));
                        }
                        else {
                          // the line graph
                          return SfCartesianChart(
                              primaryXAxis: DateTimeAxis(
                                  intervalType: DateTimeIntervalType.days,
                                  interval: 1,
                                  rangePadding: ChartRangePadding.round
                              ),
                              zoomPanBehavior: ZoomPanBehavior(
                                enablePanning: true,
                                enablePinching: true,
                              ),
                              tooltipBehavior: TooltipBehavior(enable: true),
                              enableAxisAnimation: true,
                              // the list of datapoints and how to determine x and y values
                              series: <LineSeries<GraphFeedsDataPoint, DateTime>>[
                                LineSeries<GraphFeedsDataPoint, DateTime>(
                                    dataSource: snapshot.data,
                                    xValueMapper: (GraphFeedsDataPoint donation, _) => DateFormat("dd/MM/yyyy").parse(donation.date),
                                    yValueMapper: (GraphFeedsDataPoint donation, _) {
                                      return donation.amount;
                                    },
                                    // Enable data label
                                    dataLabelSettings: DataLabelSettings(isVisible: true),
                                    markerSettings: MarkerSettings(
                                        isVisible: true,
                                        // Marker shape is set to diamond
                                        shape: DataMarkerType.diamond
                                    )
                                )
                              ]
                          );
                        }
                      },
                    ),
              ),
            ),
            ///Floating action button

          ],
        ),
      floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add, color: iconColor),
              //backgroundColor: Theme.of(context).primaryColor,
              onPressed: () async {
              Navigator.pushNamed(context, '/recordADonation');
            }

    ),

        );
  }
}
