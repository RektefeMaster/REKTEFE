import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../models/review_stats_model.dart';

class ReviewStatsScreen extends StatefulWidget {
  final String targetId;
  final String targetType;

  const ReviewStatsScreen({
    Key? key,
    required this.targetId,
    required this.targetType,
  }) : super(key: key);

  @override
  _ReviewStatsScreenState createState() => _ReviewStatsScreenState();
}

class _ReviewStatsScreenState extends State<ReviewStatsScreen> {
  DateTime _startDate = DateTime.now().subtract(Duration(days: 30));
  DateTime _endDate = DateTime.now();
  bool _isLoading = false;
  Map<String, dynamic>? _monthlyStats;

  @override
  void initState() {
    super.initState();
    _loadMonthlyStats();
  }

  Future<void> _loadMonthlyStats() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final stats = await ReviewStatsService.getMonthlyStats(
        targetId: widget.targetId,
        targetType: widget.targetType,
        startDate: _startDate,
        endDate: _endDate,
      );

      setState(() {
        _monthlyStats = stats;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('İstatistikler yüklenirken bir hata oluştu')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Değerlendirme İstatistikleri'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StreamBuilder<ReviewStats?>(
                    stream: ReviewStatsService.getStats(
                      targetId: widget.targetId,
                      targetType: widget.targetType,
                    ),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }

                      final stats = snapshot.data!;
                      return Column(
                        children: [
                          _buildOverallStats(stats),
                          SizedBox(height: 24),
                          _buildRatingDistribution(stats),
                        ],
                      );
                    },
                  ),
                  SizedBox(height: 24),
                  _buildDateRangePicker(),
                  SizedBox(height: 24),
                  if (_monthlyStats != null) ...[
                    _buildReviewTrend(),
                    SizedBox(height: 24),
                    _buildRatingTrend(),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _buildOverallStats(ReviewStats stats) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Genel İstatistikler',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  'Ortalama Puan',
                  stats.averageRating.toStringAsFixed(1),
                  Icons.star,
                  Colors.amber,
                ),
                _buildStatItem(
                  'Toplam Değerlendirme',
                  stats.totalReviews.toString(),
                  Icons.rate_review,
                  Colors.blue,
                ),
                _buildStatItem(
                  'Doğrulanmış',
                  stats.verifiedReviews.toString(),
                  Icons.verified,
                  Colors.green,
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  'Fotoğraf Sayısı',
                  stats.photosCount.toString(),
                  Icons.photo_library,
                  Colors.purple,
                ),
                _buildStatItem(
                  'Toplam Beğeni',
                  stats.totalLikes.toString(),
                  Icons.favorite,
                  Colors.red,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildRatingDistribution(ReviewStats stats) {
    final maxCount = stats.ratingDistribution.values
        .reduce((a, b) => a > b ? a : b)
        .toDouble();

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Puan Dağılımı',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            ...List.generate(5, (index) {
              final rating = 5 - index;
              final count = stats.ratingDistribution[rating] ?? 0;
              final percentage = maxCount > 0 
                  ? (count / maxCount) * 100 
                  : 0.0;

              return Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Text(
                      '$rating',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(Icons.star, color: Colors.amber, size: 16),
                    SizedBox(width: 8),
                    Expanded(
                      child: LinearProgressIndicator(
                        value: percentage / 100,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      count.toString(),
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildDateRangePicker() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tarih Aralığı',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextButton.icon(
                    icon: Icon(Icons.calendar_today),
                    label: Text(
                      '${_startDate.day}/${_startDate.month}/${_startDate.year}',
                    ),
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _startDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                      );
                      if (date != null) {
                        setState(() {
                          _startDate = date;
                        });
                        _loadMonthlyStats();
                      }
                    },
                  ),
                ),
                Text(' - '),
                Expanded(
                  child: TextButton.icon(
                    icon: Icon(Icons.calendar_today),
                    label: Text(
                      '${_endDate.day}/${_endDate.month}/${_endDate.year}',
                    ),
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _endDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                      );
                      if (date != null) {
                        setState(() {
                          _endDate = date;
                        });
                        _loadMonthlyStats();
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewTrend() {
    final reviewsByDay = _monthlyStats!['reviewsByDay'] as Map<String, dynamic>;
    if (reviewsByDay.isEmpty) return SizedBox();

    final spots = reviewsByDay.entries.map((entry) {
      final date = entry.key.split('-');
      final x = DateTime(
        int.parse(date[0]),
        int.parse(date[1]),
        int.parse(date[2]),
      ).millisecondsSinceEpoch.toDouble();
      return FlSpot(x, entry.value.toDouble());
    }).toList();

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Değerlendirme Trendi',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Container(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: SideTitles(showTitles: true),
                    bottomTitles: SideTitles(
                      showTitles: true,
                      getTitles: (value) {
                        final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                        return '${date.day}/${date.month}';
                      },
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      colors: [Colors.blue],
                      barWidth: 3,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        colors: [Colors.blue.withOpacity(0.2)],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingTrend() {
    final ratingsByDay = _monthlyStats!['ratingsByDay'] as Map<String, dynamic>;
    if (ratingsByDay.isEmpty) return SizedBox();

    final spots = ratingsByDay.entries.map((entry) {
      final date = entry.key.split('-');
      final x = DateTime(
        int.parse(date[0]),
        int.parse(date[1]),
        int.parse(date[2]),
      ).millisecondsSinceEpoch.toDouble();
      return FlSpot(x, entry.value.toDouble());
    }).toList();

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Puan Trendi',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Container(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: SideTitles(
                      showTitles: true,
                      getTitles: (value) => value.toStringAsFixed(1),
                    ),
                    bottomTitles: SideTitles(
                      showTitles: true,
                      getTitles: (value) {
                        final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                        return '${date.day}/${date.month}';
                      },
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  minY: 1,
                  maxY: 5,
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      colors: [Colors.amber],
                      barWidth: 3,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        colors: [Colors.amber.withOpacity(0.2)],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 