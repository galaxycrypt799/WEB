import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../operations/views/revenue_bloc.dart';

String formatVnd(int amount) => "${amount.toString()}đ";

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: BlocBuilder<RevenueBloc, RevenueState>(
          builder: (context, state) {
            if (state is RevenueLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is RevenueSuccess) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Tổng quan hệ thống",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      _buildQuickStat(context, "Doanh thu ngày", formatVnd(state.today), Icons.today, Colors.orange),
                      const SizedBox(width: 16),
                      _buildQuickStat(context, "Doanh thu tháng", formatVnd(state.month), Icons.calendar_month, Colors.blue),
                      const SizedBox(width: 16),
                      _buildQuickStat(context, "Đơn thành công", state.completedOrders.toString(), Icons.check_circle, Colors.green),
                    ],
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    "Doanh thu 7 ngày qua",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 300,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
                    ),
                    child: _buildRevenueChart(state.weeklyRevenue),
                  ),
                ],
              );
            }
            return const Center(child: Text("Chào mừng DrinkHub Admin!"));
          },
        ),
      ),
    );
  }

  Widget _buildQuickStat(BuildContext context, String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(color: Colors.grey, fontSize: 14)),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildRevenueChart(List<int> weeklyData) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: (weeklyData.reduce((a, b) => a > b ? a : b) * 1.2).toDouble(),
        barTouchData: BarTouchData(enabled: true),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                const days = ['T-6', 'T-5', 'T-4', 'T-3', 'T-2', 'T-1', 'Nay'];
                return Text(days[value.toInt()], style: const TextStyle(fontSize: 10));
              },
            ),
          ),
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        barGroups: List.generate(weeklyData.length, (i) {
          return BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: weeklyData[i].toDouble(),
                color: Colors.brown,
                width: 16,
                borderRadius: BorderRadius.circular(4),
              )
            ],
          );
        }),
      ),
    );
  }
}
