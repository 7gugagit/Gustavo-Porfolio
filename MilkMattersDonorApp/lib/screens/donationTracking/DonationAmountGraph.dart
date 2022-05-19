import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:milk_matters_donor_app/models/GraphAmountDataPoint.dart';
import 'package:milk_matters_donor_app/services/LocalDatabaseService.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_core/core.dart';

/// The stateful widget which displays the donation amount graph
class DonationAmountGraph extends StatefulWidget {

  @override
  /// Create the widget's state
  _DonationAmountGraphState createState() => _DonationAmountGraphState();
}

/// The widget's state
class _DonationAmountGraphState extends State<DonationAmountGraph> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    /// Register the Syncfusion license to provide access to the package
    SyncfusionLicense.registerLicense('NT8mJyc2IWhia31hfWN9Z2doYmF8YGJ8ampqanNiYmlmamlmanMDHmg3Oj08fTE8ICA6ZxM0PjI6P30wPD4=');
    /// Setup the provider to access the local SQL database
    final localDBProvider = Provider.of<LocalDatabaseService>(context);

    return Scaffold(
        //backgroundColor: Theme.of(context).backgroundColor,
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(5,5,5,0),
                /// Load the tracked donations from the database, but show a loading spinner while doing so.
                /// Use the loaded data to create the line graph
                child: FutureBuilder(
                  future: localDBProvider.getAllTrackedDonationsForAmountGraph(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Container(child: Center(child: CupertinoActivityIndicator(radius: 50.0)));
                    }
                    else {
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
                          series: <LineSeries<GraphAmountDataPoint, DateTime>>[
                            LineSeries<GraphAmountDataPoint, DateTime>(
                                dataSource: snapshot.data,
                                xValueMapper: (GraphAmountDataPoint donation, _) => DateFormat("dd/MM/yyyy").parse(donation.date),
                                yValueMapper: (GraphAmountDataPoint donation, _) {
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
          ],
        ),
      /// Floating action button
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add, color: Colors.white,),
          //backgroundColor: Theme.of(context).primaryColor,
          onPressed: () async {
            Navigator.pushNamed(context, '/recordADonation');
          }
      ),
    );
  }
}
