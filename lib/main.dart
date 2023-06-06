import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

void main() {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensure proper initialization of bindings.
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: MapWithRadarMarker(),
      ),
    );
  }
}

class MapWithRadarMarker extends StatefulWidget {
  @override
  _MapWithRadarMarkerState createState() => _MapWithRadarMarkerState();
}

class _MapWithRadarMarkerState extends State<MapWithRadarMarker>
    with SingleTickerProviderStateMixin {
  late GoogleMapController mapController;
  WidgetsToImageController wcontroller = WidgetsToImageController();
  Animation<double>? animation;
  AnimationController? controller;
  double maxRadius = 20.0;
  int animationDuration = 2000;
  Set<Marker> d = {};
  GlobalKey globalKey = GlobalKey();
  Timer? _timer;
  bool isReady = false;
  bool isOnTap = false;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    animation = Tween<double>(
      begin: 0.0,
      end: maxRadius,
    ).animate(controller!)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller!.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controller!.forward();
        }
      });
    controller!.forward();
    isReady = true;
  }

  @override
  Widget build(BuildContext context) {
    return isReady
        ? Stack(
            alignment: Alignment.center,
            children: [
              Visibility(
                maintainState: true,
                visible: true,
                child: WidgetsToImage(
                  controller: wcontroller,
                  child: RippleAnimation(
                      color: Colors.purpleAccent.withOpacity(0.3),
                      delay: const Duration(milliseconds: 300),
                      repeat: true,
                      minRadius: 10,
                      ripplesCount: 3,
                      duration: const Duration(milliseconds: 3 * 300),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Material(
                              shape: const CircleBorder(
                                  side: BorderSide(color: Colors.purple)),
                              shadowColor: Colors.purple,
                              elevation: 3,
                              child: Container(
                                height: 15,
                                width: 15,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: const DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                        "https://img.freepik.com/premium-photo/image-colorful-galaxy-sky-generative-ai_791316-9864.jpg",
                                      )),
                                  color: Colors.purpleAccent.withOpacity(0.3),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            )
                          ],
                        ),
                      )),
                ),
              ),
              GoogleMap(
                onTap: (latlng) {
                  d.clear();
                  _timer!.cancel();
                  setState(() {});
                  WidgetsBinding.instance
                      .addPostFrameCallback((timeStamp) async {
                    _timer = Timer.periodic(const Duration(milliseconds: 100),
                        (timer) async {
                      d.add(Marker(
                          markerId: const MarkerId("value"),
                          position: latlng,
                          icon: BitmapDescriptor.fromBytes(
                            (await wcontroller.capture())!,
                          ),
                          onTap: () {}));

                      setState(() {});
                    });
                  });
                },
                onMapCreated: (GoogleMapController controller) async {
                  mapController = controller;
                  WidgetsBinding.instance
                      .addPostFrameCallback((timeStamp) async {
                    _timer = Timer.periodic(const Duration(milliseconds: 50),
                        (timer) async {
                      d.add(Marker(
                          markerId: const MarkerId("value"),
                          position: const LatLng(37.422, -122.084),
                          icon: BitmapDescriptor.fromBytes(
                            (await wcontroller.capture())!,
                          ),
                          onTap: () {}));

                      setState(() {});
                    });
                  });
                },
                markers: d,
                initialCameraPosition: const CameraPosition(
                  target: LatLng(37.422, -122.084),
                  zoom: 14.0,
                ),
              ),
            ],
          )
        : const SizedBox();
  }
}
