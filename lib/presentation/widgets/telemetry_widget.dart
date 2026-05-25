import 'package:flutter/material.dart';
import 'package:luxelaptops/core/constants/colors.dart';
import 'package:luxelaptops/data/models/product_model.dart';
import 'package:luxelaptops/presentation/widgets/glass_container.dart';

/// Live-style hardware telemetry bars for the Lab screen.
class TelemetryBar extends StatelessWidget {
  const TelemetryBar({
    super.key,
    required this.label,
    required this.value,
    required this.unit,
    this.icon,
    this.accentColor = AppColors.primary,
  });

  final String label;
  final double value;
  final String unit;
  final IconData? icon;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final percent = value.clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16, color: accentColor),
              const SizedBox(width: 8),
            ],
            Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
            const Spacer(),
            Text(
              unit,
              style: TextStyle(fontSize: 12, color: accentColor, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: percent),
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOutCubic,
            builder: (context, animValue, _) {
              return Stack(
                children: [
                  Container(
                    height: 8,
                    color: AppColors.border,
                  ),
                  FractionallySizedBox(
                    widthFactor: animValue,
                    child: Container(
                      height: 8,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [accentColor, accentColor.withValues(alpha: 0.5)],
                        ),
                        boxShadow: AppColors.neonGlow(accentColor, blur: 8),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Full telemetry panel for a product.
class TelemetryPanel extends StatelessWidget {
  const TelemetryPanel({super.key, required this.telemetry});

  final ProductTelemetry telemetry;

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      glowColor: AppColors.secondary.withValues(alpha: 0.4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.monitor_heart_outlined, color: AppColors.secondary, size: 20),
              const SizedBox(width: 8),
              Text(
                'Live Telemetry',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const Spacer(),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.success,
                  boxShadow: AppColors.neonGlow(AppColors.success, blur: 6),
                ),
              ),
              const SizedBox(width: 6),
              const Text('LIVE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 20),
          TelemetryBar(
            label: 'CPU Load',
            value: telemetry.cpuLoad,
            unit: '${(telemetry.cpuLoad * 100).round()}%',
            icon: Icons.memory_rounded,
          ),
          const SizedBox(height: 14),
          TelemetryBar(
            label: 'GPU Load',
            value: telemetry.gpuLoad,
            unit: '${(telemetry.gpuLoad * 100).round()}%',
            icon: Icons.videogame_asset_outlined,
            accentColor: AppColors.secondary,
          ),
          const SizedBox(height: 14),
          TelemetryBar(
            label: 'RAM Usage',
            value: telemetry.ramUsage,
            unit: '${(telemetry.ramUsage * 100).round()}%',
            icon: Icons.sd_storage_rounded,
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _StatTile(
                  label: 'Temp',
                  value: '${telemetry.tempCelsius.round()}°C',
                  icon: Icons.thermostat_rounded,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatTile(
                  label: 'Battery',
                  value: '${(telemetry.batteryHealth * 100).round()}%',
                  icon: Icons.battery_charging_full_rounded,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatTile(
                  label: 'Fan',
                  value: '${telemetry.fanRpm} RPM',
                  icon: Icons.air_rounded,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardElevated,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(height: 6),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
          Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
