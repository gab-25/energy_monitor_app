import 'package:energy_monitor_app/blocs/monitor/monitor_bloc.dart';
import 'package:energy_monitor_app/repositories/auth_repository.dart';
import 'package:energy_monitor_app/repositories/db_repository.dart';
import 'package:energy_monitor_app/services/shelly_cloud_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class MonitorTab extends StatelessWidget {
  const MonitorTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          MonitorBloc(context.read<AuthRepository>(), context.read<DbRepository>(), context.read<ShellyCloudService>())
            ..add(const MonitorSettingsLoaded())
            ..add(const MonitorStatusChanged())
            ..add(const MonitorConsumptionUpdated()),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: BlocBuilder<MonitorBloc, MonitorState>(
          builder: (context, state) =>
              state.status == MonitorStatus.connected && state.settings != null && state.consumption != null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Power', style: TextStyle(fontSize: 18)),
                        SfRadialGauge(
                          axes: <RadialAxis>[
                            RadialAxis(
                              minimum: 0,
                              maximum: state.settings!.maxValue!,
                              ranges: <GaugeRange>[
                                GaugeRange(
                                  startValue: 0,
                                  endValue: state.settings!.limitValue!,
                                  color: Colors.green,
                                ),
                                GaugeRange(
                                  startValue: state.settings!.limitValue!,
                                  endValue: state.settings!.maxValue!,
                                  color: Colors.red,
                                ),
                              ],
                              pointers: <GaugePointer>[
                                NeedlePointer(value: state.value),
                              ],
                              annotations: <GaugeAnnotation>[
                                GaugeAnnotation(
                                  widget: Text('${state.value} kW',
                                      style: const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                      )),
                                  angle: 90,
                                  positionFactor: 0.5,
                                )
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Theme.of(context).colorScheme.inverseSurface),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Column(children: [
                            const Text(
                              'Consumption',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Row(
                                  children: [
                                    Icon(Icons.electric_bolt),
                                    SizedBox(width: 5),
                                    Text('Today'),
                                  ],
                                ),
                                Text('${state.consumption?.today ?? 0.0} kWh'),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Row(
                                  children: [
                                    Icon(Icons.electric_bolt),
                                    SizedBox(width: 5),
                                    Text('This month'),
                                  ],
                                ),
                                Text('${state.consumption?.thisMonth ?? 0.0} kWh'),
                              ],
                            ),
                          ]),
                        ),
                      ],
                    )
                  : state.status == MonitorStatus.disconnected
                      ? const Center(child: Icon(Icons.signal_wifi_off, size: 60))
                      : const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
