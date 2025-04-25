import 'dart:math';
import 'dart:async';
import 'package:azkary/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vector_math/vector_math.dart' as vmath;
import 'package:google_mobile_ads/google_mobile_ads.dart';

class QiblaCompass extends StatefulWidget {
  const QiblaCompass({Key? key}) : super(key: key);

  @override
  _QiblaCompassState createState() => _QiblaCompassState();
}

class _QiblaCompassState extends State<QiblaCompass> {
  double? _heading;
  double? _qiblaDirection;
  Position? _currentPosition;
  bool _hasPermissions = false;
  bool _isLoading = true;
  
  // Ad related variables
  NativeAd? _nativeAd;
  bool _isAdLoaded = false;
  
  // Stream subscription for compass events
  StreamSubscription<CompassEvent>? _compassSubscription;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
    _loadNativeAd();
  }
  
  @override
  void dispose() {
    _nativeAd?.dispose();
    // Cancel the compass subscription to prevent setState after dispose
    _compassSubscription?.cancel();
    super.dispose();
  }
  
  void _loadNativeAd() {
    _nativeAd = NativeAd(
      adUnitId: 'ca-app-pub-3940256099942544/2247696110', // Replace with your ad unit ID, using test ID for now
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          print('Native ad failed to load: ${error.message}');
        },
      ),
      request: const AdRequest(),
      // Specify a template
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: TemplateType.medium,
        mainBackgroundColor: Colors.white12,
        callToActionTextStyle: NativeTemplateTextStyle(
          textColor: Colors.white,
          backgroundColor: Colors.blue,
          style: NativeTemplateFontStyle.bold,
          size: 16,
        ),
        primaryTextStyle: NativeTemplateTextStyle(
          textColor: Colors.black87,
          backgroundColor: Colors.transparent,
          style: NativeTemplateFontStyle.bold,
          size: 16,
        ),
        secondaryTextStyle: NativeTemplateTextStyle(
          textColor: Colors.black54,
          backgroundColor: Colors.transparent,
          style: NativeTemplateFontStyle.normal,
          size: 14,
        ),
        tertiaryTextStyle: NativeTemplateTextStyle(
          textColor: Colors.black54,
          backgroundColor: Colors.transparent,
          style: NativeTemplateFontStyle.normal,
          size: 12,
        ),
      ),
    );

    _nativeAd?.load();
  }

  Future<void> _checkPermissions() async {
    final locationStatus = await Permission.location.request();
    final locationWhenInUseStatus =
        await Permission.locationWhenInUse.request();

    if (locationStatus.isGranted || locationWhenInUseStatus.isGranted) {
      setState(() => _hasPermissions = true);
      _initCompass();
      _getCurrentLocation();
    } else {
      setState(() => _hasPermissions = false);
      _isLoading = false;
    }
  }

  void _initCompass() {
    _compassSubscription = FlutterCompass.events?.listen((event) {
      if (mounted) {  // Check if widget is still mounted before calling setState
        setState(() {
          _heading = event.heading;
        });
      }
    });
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = position;
        _qiblaDirection = calculateQiblaDirection(
          position.latitude,
          position.longitude,
        );
        _isLoading = false;
      });
    } catch (e) {
      print("Error getting location: $e");
      setState(() => _isLoading = false);
    }
  }

  double calculateQiblaDirection(double latitude, double longitude) {
    // Kaaba coordinates
    const kaabaLat = 21.3891;
    const kaabaLon = 39.8579;

    // Convert to radians
    double lat1 = vmath.radians(latitude);
    double lon1 = vmath.radians(longitude);
    double lat2 = vmath.radians(kaabaLat);
    double lon2 = vmath.radians(kaabaLon);

    // Calculate the difference in longitudes
    double dLon = lon2 - lon1;

    // Calculate the bearing
    double y = sin(dLon) * cos(lat2);
    double x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);
    double bearing = atan2(y, x);

    // Convert bearing from radians to degrees and normalize
    bearing = vmath.degrees(bearing);
    bearing = (bearing + 360) % 360;

    return bearing;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!_hasPermissions) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Location permissions are required'),
            ElevatedButton(
              onPressed: _checkPermissions,
              child: const Text('Request Permissions'),
            ),
          ],
        ),
      );
    }

    if (_currentPosition == null || _qiblaDirection == null) {
      return const Center(child: Text('Could not determine Qibla direction'));
    }

    // Calculate the difference between current heading and qibla direction
    double angleDifference = ((_qiblaDirection! - (_heading ?? 0) + 360) % 360);
    // Check if the device is pointing towards Qibla (within 5 degrees)
    bool isPointingToQibla = angleDifference < 5 || angleDifference > 355;

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).qiblaCompass),
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${S.of(context).qiblaDirection}: ${_qiblaDirection!.toStringAsFixed(2)}°',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '${S.of(context).yourLocation}: ${_currentPosition!.latitude.toStringAsFixed(4)}, '
                    '${_currentPosition!.longitude.toStringAsFixed(4)}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: 300,
                    height: 300,
                    child: Container(
                      width: 300,
                      height: 300,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isPointingToQibla ? Colors.green : Colors.blue,
                          width: isPointingToQibla ? 4 : 2,
                        ),
                        boxShadow: isPointingToQibla
                            ? [
                                BoxShadow(
                                  color: Colors.green.withOpacity(0.5),
                                  blurRadius: 15,
                                  spreadRadius: 5,
                                )
                              ]
                            : null,
                      ),
                      child: Transform.rotate(
                        angle: (_heading ?? 0) * (pi / 180) * -1,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Background with Mosque Silhouette
                            Container(
                              width: 280,
                              height: 280,
                              decoration:  BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.blue.shade100,
                              ),
                              child: const Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Mosque silhouette background (light blue)
                                
                                ],
                              ),
                            ),
                            
                            // Outer blue circle with degree markings
                            CustomPaint(
                              size: const Size(280, 280),
                              painter: CompassCirclePainter(
                                markingsColor: Colors.blue,
                              ),
                            ),
                            
                            // Cardinal directions
                            const Positioned(
                              top: 20,
                              child: Text(
                                'N',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            const Positioned(
                              bottom: 25,
                              child: Text(
                                'S',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            const Positioned(
                              right: 25,
                              child: Text(
                                'E',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            const Positioned( 
                              left: 25,
                              child: Text(
                                'W',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            
                            // Compass needle
                            Transform.rotate(
                              angle: _qiblaDirection! * (pi / 180),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Dual-colored needle
                                  CustomPaint(
                                    size: const Size(220, 220),
                                    painter: CompassNeedlePainter(),
                                  ),
                                  
                                  // Kaaba icon at the needle point
                                  Positioned(
                                    top: 0,
                                    child: Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(2),
                                       
                                      ),

                                      child: Image.asset(
                                    'assets/images/kaaba.png',
                                    width: 70,
                                    height: 70,
                                  ),
                                    ),
                                  ),
                                  
                                  // Center circle
                                  Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey.shade300,
                                      border: Border.all(
                                        color: Colors.grey.shade600,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isPointingToQibla ? Colors.green : Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Text(
                          isPointingToQibla 
                              ? '${S.of(context).youAreFacingQiblaDirection}' 
                              : '${S.of(context).turnToFindQiblaDirection}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '${S.of(context).currentHeading}: ${_heading?.toStringAsFixed(2) ?? 'N/A'}°',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Native Ad Container at bottom
          if (_isAdLoaded && _nativeAd != null)
            Container(
              height: 80,
              margin: const EdgeInsets.only(top: 20, bottom: 10, left: 10, right: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: AdWidget(ad: _nativeAd!),
            )
          else
            Container(
              height: 80,
              margin: const EdgeInsets.only(top: 20, bottom: 10),
              child: const Center(
                child: Text('Ad loading...'),
              ),
            ),
        ],
      ),
    );
  }
}

class MosquePainter extends CustomPainter {
  final Color color;

  MosquePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Create a path for the mosque silhouette
    final Path path = Path();
    
    // Base
    path.moveTo(0, size.height);
    path.lineTo(size.width, size.height);
    
    // Right wall
    path.lineTo(size.width, size.height * 0.6);
    
    // Small dome
    path.quadraticBezierTo(
      size.width * 0.85, size.height * 0.45,
      size.width * 0.7, size.height * 0.5,
    );
    
    // Center dome
    path.quadraticBezierTo(
      size.width * 0.5, size.height * 0.25,
      size.width * 0.3, size.height * 0.5,
    );
    
    // Left minaret
    path.lineTo(size.width * 0.2, size.height * 0.5);
    path.lineTo(size.width * 0.2, size.height * 0.3);
    path.lineTo(size.width * 0.15, size.height * 0.2);
    path.lineTo(size.width * 0.1, size.height * 0.3);
    path.lineTo(size.width * 0.1, size.height * 0.55);
    path.lineTo(0, size.height * 0.6);
    
    path.close();
    
    // Add a subtle glow
    final Paint shadowPaint = Paint()
      ..color = color.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 3);
    
    canvas.drawPath(path, shadowPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class CompassCirclePainter extends CustomPainter {
  final Color markingsColor;

  CompassCirclePainter({required this.markingsColor});

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = size.width / 2;
    final Offset center = Offset(size.width / 2, size.height / 2);
    
    // Draw blue outer circle
    final Paint circlePaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20;
      
    canvas.drawCircle(center, radius - 10, circlePaint);
    
    // Draw degree markings
    final TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    
    for (int i = 0; i < 360; i += 30) {
      final double markingRadius = radius - 5;
      final double angle = i * (pi / 180);
      final Offset markingPosition = Offset(
        center.dx + markingRadius * cos(angle),
        center.dy + markingRadius * sin(angle),
      );
      
      // Draw text for degree markings
      String text = '$i';
      textPainter.text = TextSpan(
        text: text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      );
      
      textPainter.layout();
      
      // Position the text
      final Offset textPosition = Offset(
        markingPosition.dx - textPainter.width / 2,
        markingPosition.dy - textPainter.height / 2,
      );
      
      textPainter.paint(canvas, textPosition);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class CompassNeedlePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;
    final Offset center = Offset(width / 2, height / 2);
    
    // Create needle path
    final Path needlePath = Path();
    
    // North/red half of the needle
    final Paint redPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;
      
    needlePath.moveTo(center.dx - 8, center.dy);
    needlePath.lineTo(center.dx + 8, center.dy);
    needlePath.lineTo(center.dx, center.dy - height / 2 + 20);
    needlePath.close();
    
    canvas.drawPath(needlePath, redPaint);
    
    // South/blue half of the needle
    final Paint bluePaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;
      
    final Path southPath = Path();
    southPath.moveTo(center.dx - 8, center.dy);
    southPath.lineTo(center.dx + 8, center.dy);
    southPath.lineTo(center.dx, center.dy + height / 3);
    southPath.close();
    
    canvas.drawPath(southPath, bluePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
