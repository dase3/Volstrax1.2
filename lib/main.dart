import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Magnetic Field Drone Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ConnectPage(),
    );
  }
}

// Page 1: Connect to ESP32
class ConnectPage extends StatefulWidget {
  const ConnectPage({super.key});

  @override
  _ConnectPageState createState() => _ConnectPageState();
}

class _ConnectPageState extends State<ConnectPage> {
  bool _isConnecting = false;

  Future<void> _connectToESP32() async {
    setState(() {
      _isConnecting = true;
    });

    // Simulate connection process
    await Future.delayed(Duration(seconds: 2));

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ConnectedPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Magnetic Field Drone'),
        backgroundColor: Colors.blueGrey[800],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bluetooth, size: 100, color: Colors.blue),
            SizedBox(height: 30),
            Text(
              'Connect to VolStrax',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'VolStrax_DRONE_MAG_001',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            SizedBox(height: 40),
            _isConnecting
                ? Column(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Connecting...'),
                    ],
                  )
                : ElevatedButton(
                    onPressed: _connectToESP32,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 16,
                      ),
                    ),
                    child: Text('Connect', style: TextStyle(fontSize: 18)),
                  ),
          ],
        ),
      ),
    );
  }
}

// Page 2: Connected to ESP32
class ConnectedPage extends StatelessWidget {
  const ConnectedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Magnetic Field Drone'),
        backgroundColor: Colors.blueGrey[800],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, size: 100, color: Colors.green),
            SizedBox(height: 30),
            Text(
              'Connected to VolStrax',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'VolStrax_DRONE_MAG_001',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green[200]!),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.wifi, color: Colors.green),
                  SizedBox(width: 8),
                  Text('Connection Status: Active'),
                ],
              ),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MeasuringPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              ),
              child: Text('Start Scaning', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}

// Page 3: Measuring Magnetic Field
class MeasuringPage extends StatefulWidget {
  const MeasuringPage({super.key});

  @override
  _MeasuringPageState createState() => _MeasuringPageState();
}

class _MeasuringPageState extends State<MeasuringPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
    _animationController.repeat();

    // After 3 seconds, go to FinishScanPage instead of HeightMapPage
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => FinishScanPage(
            onViewResult: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HeightMapPage()),
              );
            },
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Magnetic Field Drone'),
        backgroundColor: Colors.blueGrey[800],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.blue.withOpacity(_animation.value),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Icon(Icons.radar, size: 80, color: Colors.blue),
                );
              },
            ),
            SizedBox(height: 30),
            Text(
              'Measuring Magnetic Field',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Scanning area...',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            SizedBox(height: 40),
            LinearProgressIndicator(
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
            SizedBox(height: 20),
            Text(
              'Please wait while the drone collects data',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }
}

// Page 4: Height Map
class HeightMapPage extends StatefulWidget {
  const HeightMapPage({super.key});

  @override
  _HeightMapPageState createState() => _HeightMapPageState();
}

class _HeightMapPageState extends State<HeightMapPage> {
  List<List<double>> _heightMap = [];
  final int _gridSize = 20;

  @override
  void initState() {
    super.initState();
    _generateFakeHeightMap();
  }

  void _generateFakeHeightMap() {
    // Generate a radial heightmap: highest in the center and falling off to edges.
    // We use a Gaussian (exp(-r^2 / (2*sigma^2))) falloff and add small noise.
    final random = math.Random();
    final cx = (_gridSize - 1) / 2.0;
    final cy = (_gridSize - 1) / 2.0;
    // sigma controls how quickly values fall off from center (in grid cells)
    final sigma = _gridSize / 4.0;

    _heightMap = List.generate(_gridSize, (i) {
      return List.generate(_gridSize, (j) {
        final dx = i - cx;
        final dy = j - cy;
        final r2 = dx * dx + dy * dy;

        // Gaussian radial falloff (center ~1.0, edges -> 0.0)
        double value = math.exp(-r2 / (2 * sigma * sigma));

        // Optionally boost the center a little and add small noise for realism
        value =
            value * 0.9 + 0.1 * math.exp(-r2 / (2 * (sigma / 2) * (sigma / 2)));
        value += 0.05 * (random.nextDouble() - 0.5);

        return value.clamp(0.0, 1.0);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Magnetic Field Height Map'),
        backgroundColor: Colors.blueGrey[800],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomPaint(
                painter: HeightMapPainter(_heightMap),
                size: Size.infinite,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  'Magnetic Field Height Map',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Red areas indicate stronger magnetic fields',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Map3DPage(_heightMap),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  ),
                  child: Text(
                    'Generate 3D Map',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HeightMapPainter extends CustomPainter {
  final List<List<double>> heightMap;

  HeightMapPainter(this.heightMap);

  @override
  void paint(Canvas canvas, Size size) {
    if (heightMap.isEmpty) return;

    final paint = Paint()..style = PaintingStyle.fill;
    final cellWidth = size.width / heightMap.length;
    final cellHeight = size.height / heightMap[0].length;

    for (int i = 0; i < heightMap.length; i++) {
      for (int j = 0; j < heightMap[i].length; j++) {
        final value = heightMap[i][j];
        paint.color = _getColorForValue(value);

        final rect = Rect.fromLTWH(
          i * cellWidth,
          j * cellHeight,
          cellWidth,
          cellHeight,
        );

        canvas.drawRect(rect, paint);
      }
    }
  }

  Color _getColorForValue(double value) {
    if (value < 0.2) return Colors.blue[900]!;
    if (value < 0.4) return Colors.blue[600]!;
    if (value < 0.6) return Colors.green[600]!;
    if (value < 0.8) return Colors.orange[600]!;
    return Colors.red[600]!;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Page 5: 3D Map
class Map3DPage extends StatefulWidget {
  final List<List<double>> heightMap;

  const Map3DPage(this.heightMap, {super.key});

  @override
  _Map3DPageState createState() => _Map3DPageState();
}

class _Map3DPageState extends State<Map3DPage> {
  double _rotationX = 0.3;
  double _rotationY = 0.0;
  double _zoom = 1.0;
  Offset? _selectedPoint;
  double? _selectedValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('3D Magnetic Field Map'),
        backgroundColor: Colors.blueGrey[800],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              margin: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
                color: Colors.black,
              ),
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    _rotationY += details.delta.dx * 0.01;
                    _rotationX -= details.delta.dy * 0.01; // Invert Y axis
                    _rotationX = _rotationX.clamp(-math.pi / 2, math.pi / 2);
                  });
                },
                onTapDown: (details) {
                  // Handle point selection
                  setState(() {
                    _selectedPoint = details.localPosition;
                    // Calculate selected value based on position
                    _selectedValue = 0.5 + math.Random().nextDouble() * 0.5;
                  });
                },
                child: CustomPaint(
                  painter: Map3DPainter(
                    widget.heightMap,
                    _rotationX,
                    _rotationY,
                    _zoom,
                    _selectedPoint,
                  ),
                  size: Size.infinite,
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                if (_selectedPoint != null && _selectedValue != null)
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue[200]!),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Selected Point Information',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Magnetic Field Strength: ${(_selectedValue! * 100).toStringAsFixed(1)} μT',
                        ),
                        Text(
                          'Position: (${_selectedPoint!.dx.toStringAsFixed(0)}, ${_selectedPoint!.dy.toStringAsFixed(0)})',
                        ),
                        Text(
                          'Intensity Level: ${(_selectedValue! * 100).toStringAsFixed(0)}%',
                        ),
                      ],
                    ),
                  ),
                SizedBox(height: 16),
                Text('Zoom: ${_zoom.toStringAsFixed(1)}x'),
                Slider(
                  value: _zoom,
                  min: 0.5,
                  max: 2.0,
                  onChanged: (value) {
                    setState(() {
                      _zoom = value;
                    });
                  },
                ),
                Text(
                  'Drag to rotate • Tap to select point',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Map3DPainter extends CustomPainter {
  final List<List<double>> heightMap;
  final double rotationX;
  final double rotationY;
  final double zoom;
  final Offset? selectedPoint;

  Map3DPainter(
    this.heightMap,
    this.rotationX,
    this.rotationY,
    this.zoom,
    this.selectedPoint,
  );

  @override
  void paint(Canvas canvas, Size size) {
    if (heightMap.isEmpty) return;

    final center = Offset(size.width / 2, size.height / 2);
    final gridSize = heightMap.length;

    // Draw color scale bar
    _drawColorScale(canvas, size);

    // Draw base grid (flat surface)
    _drawBaseGrid(canvas, size, center, gridSize);

    // Draw surface mesh with triangles
    _drawSurfaceMesh(canvas, size, center, gridSize);

    // Draw measurement points
    _drawMeasurementPoints(canvas, size, center, gridSize);

    // Draw axis labels
    _drawAxisLabels(canvas, size, center);
  }

  void _drawColorScale(Canvas canvas, Size size) {
    final scaleWidth = 20.0;
    final scaleHeight = size.height * 0.6;
    final scaleX = size.width - 60;
    final scaleY = size.height * 0.2;

    // Draw color gradient
    for (int i = 0; i < 100; i++) {
      final value = 1.0 - (i / 100.0);
      final paint = Paint()
        ..color = _getColorForValue(value)
        ..style = PaintingStyle.fill;

      final rect = Rect.fromLTWH(
        scaleX,
        scaleY + (i * scaleHeight / 100),
        scaleWidth,
        scaleHeight / 100,
      );
      canvas.drawRect(rect, paint);
    }

    // Draw scale border
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRect(
      Rect.fromLTWH(scaleX, scaleY, scaleWidth, scaleHeight),
      borderPaint,
    );

    // Draw scale labels
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    // Max value
    textPainter.text = TextSpan(
      text: '0.30 mT',
      style: TextStyle(color: Colors.white, fontSize: 12),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(scaleX + 25, scaleY - 5));

    // Min value
    textPainter.text = TextSpan(
      text: '0.25 mT',
      style: TextStyle(color: Colors.white, fontSize: 12),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(scaleX + 25, scaleY + scaleHeight - 10));

    // Title
    textPainter.text = TextSpan(
      text: 'Scale:',
      style: TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(scaleX - 10, scaleY - 30));
  }

  void _drawBaseGrid(Canvas canvas, Size size, Offset center, int gridSize) {
    final paint = Paint()
      ..color = Colors.grey[600]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Draw grid lines on base plane
    for (int i = 0; i <= gridSize; i += 2) {
      // Horizontal lines
      final start = _getScreenPoint(i, 0, center, size, baseHeight: true);
      final end = _getScreenPoint(
        i,
        gridSize - 1,
        center,
        size,
        baseHeight: true,
      );
      canvas.drawLine(start, end, paint);

      // Vertical lines
      final start2 = _getScreenPoint(0, i, center, size, baseHeight: true);
      final end2 = _getScreenPoint(
        gridSize - 1,
        i,
        center,
        size,
        baseHeight: true,
      );
      canvas.drawLine(start2, end2, paint);
    }
  }

  void _drawSurfaceMesh(Canvas canvas, Size size, Offset center, int gridSize) {
    // Draw surface triangles
    for (int i = 0; i < gridSize - 1; i++) {
      for (int j = 0; j < gridSize - 1; j++) {
        final p1 = _getScreenPoint(i, j, center, size);
        final p2 = _getScreenPoint(i + 1, j, center, size);
        final p3 = _getScreenPoint(i, j + 1, center, size);
        final p4 = _getScreenPoint(i + 1, j + 1, center, size);

        final avgValue =
            (heightMap[i][j] +
                heightMap[i + 1][j] +
                heightMap[i][j + 1] +
                heightMap[i + 1][j + 1]) /
            4;

        final paint = Paint()
          ..color = _getColorForValue(avgValue).withOpacity(0.8)
          ..style = PaintingStyle.fill;

        // Draw two triangles to form a quad
        final path1 = Path()
          ..moveTo(p1.dx, p1.dy)
          ..lineTo(p2.dx, p2.dy)
          ..lineTo(p3.dx, p3.dy)
          ..close();
        canvas.drawPath(path1, paint);

        final path2 = Path()
          ..moveTo(p2.dx, p2.dy)
          ..lineTo(p3.dx, p3.dy)
          ..lineTo(p4.dx, p4.dy)
          ..close();
        canvas.drawPath(path2, paint);

        // Draw wireframe
        final wirePaint = Paint()
          ..color = Colors.black.withOpacity(0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.5;
        canvas.drawPath(path1, wirePaint);
        canvas.drawPath(path2, wirePaint);
      }
    }
  }

  void _drawMeasurementPoints(
    Canvas canvas,
    Size size,
    Offset center,
    int gridSize,
  ) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Draw measurement points as white dots
    for (int i = 0; i < gridSize; i += 3) {
      for (int j = 0; j < gridSize; j += 3) {
        final point = _getScreenPoint(i, j, center, size);
        canvas.drawCircle(point, 3, paint);
      }
    }
  }

  void _drawAxisLabels(Canvas canvas, Size size, Offset center) {
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    // Draw axis numbers
    for (int i = 0; i <= 300; i += 50) {
      textPainter.text = TextSpan(
        text: i.toString(),
        style: TextStyle(color: Colors.white, fontSize: 10),
      );
      textPainter.layout();

      // X-axis labels
      final xPos = center.dx + (i - 150) * zoom * 0.8;
      textPainter.paint(canvas, Offset(xPos, size.height - 30));

      // Y-axis labels
      final yPos = center.dy + (i - 150) * zoom * 0.8;
      textPainter.paint(canvas, Offset(30, yPos));
    }
  }

  Offset _getScreenPoint(
    int i,
    int j,
    Offset center,
    Size size, {
    bool baseHeight = false,
  }) {
    if (i >= heightMap.length || j >= heightMap[0].length) return center;

    final value = baseHeight ? 0.0 : heightMap[i][j];
    final x = (i / heightMap.length - 0.5) * 2;
    final y = (j / heightMap.length - 0.5) * 2;
    final z = value * 0.8; // Increase height scaling

    final rotatedPoint = _rotate3D(x, y, z);

    return Offset(
      center.dx + rotatedPoint.dx * size.width * 0.25 * zoom,
      center.dy + rotatedPoint.dy * size.height * 0.25 * zoom,
    );
  }

  Offset _rotate3D(double x, double y, double z) {
    // Apply rotation around X axis
    final y1 = y * math.cos(rotationX) - z * math.sin(rotationX);
    final z1 = y * math.sin(rotationX) + z * math.cos(rotationX);

    // Apply rotation around Y axis
    final x2 = x * math.cos(rotationY) + z1 * math.sin(rotationY);

    // Simple orthographic projection
    return Offset(x2, y1);
  }

  Color _getColorForValue(double value) {
    // More accurate color mapping similar to the reference image
    if (value < 0.1) return Color(0xFF0000FF); // Deep blue
    if (value < 0.2) return Color(0xFF0080FF); // Blue
    if (value < 0.3) return Color(0xFF00FFFF); // Cyan
    if (value < 0.4) return Color(0xFF00FF80); // Green-cyan
    if (value < 0.5) return Color(0xFF00FF00); // Green
    if (value < 0.6) return Color(0xFF80FF00); // Yellow-green
    if (value < 0.7) return Color(0xFFFFFF00); // Yellow
    if (value < 0.8) return Color(0xFFFF8000); // Orange
    if (value < 0.9) return Color(0xFFFF4000); // Red-orange
    return Color(0xFFFF0000); // Red
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class FinishScanPage extends StatelessWidget {
  final VoidCallback onViewResult;

  const FinishScanPage({super.key, required this.onViewResult});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan Complete'),
        backgroundColor: Colors.blueGrey[800],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, size: 100, color: Colors.green),
            SizedBox(height: 30),
            Text(
              'Scan Complete',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'VolStrax_DRONE_MAG_001',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: onViewResult,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              ),
              child: Text('View Result', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
