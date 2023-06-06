// import 'dart:async';
// import 'dart:ui' as ui;
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class MapSample extends StatefulWidget {
//   const MapSample({super.key});

//   @override
//   State<MapSample> createState() => MapSampleState();
// }

// class MapSampleState extends State<MapSample> {
//   final AnimatedRadarMarker radarMarker = AnimatedRadarMarker();
//   final Completer<GoogleMapController> _controller =
//       Completer<GoogleMapController>();

//   static const CameraPosition _kGooglePlex = CameraPosition(
//     target: LatLng(37.42796133580664, -122.085749655962),
//     zoom: 14.4746,
//   );

//   static const CameraPosition _kLake = CameraPosition(
//       bearing: 192.8334901395799,
//       target: LatLng(37.43296265331129, -122.08832357078792),
//       tilt: 59.440717697143555,
//       zoom: 19.151926040649414);

//   Marker? marker;
//   @override
//   void initState() {
//     super.initState();
//     marker = const Marker(
//         markerId: MarkerId('anything'),
//         position: LatLng(37.43296265331129, -122.08832357078792),
//         icon: BitmapDescriptor.defaultMarker);

//     Future.delayed(Duration(seconds: 5)).then((timeStamp) {
//       setState(() {
//         marker = Marker(
//             markerId: const MarkerId('anything'),
//             position: const LatLng(37.43296265331129, -122.08832357078792),
//             icon: radarMarker.animatedIcon!);
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return marker == null
//         ? const SizedBox()
//         : Scaffold(
//             body: GoogleMap(
//               mapType: MapType.normal,
//               initialCameraPosition: _kGooglePlex,
//               markers: {marker!},
//               onMapCreated: (GoogleMapController controller) {
//                 _controller.complete(controller);
//               },
//             ),
//           );
//   }
// }


// class AnimatedRadarMarker {
//   static const double maxRadius = 48.0;
//   static const int animationDuration = 2000;

//   Animation<double>? animation;
//   AnimationController? controller;
//   late BitmapDescriptor defaultIcon;
//   late BitmapDescriptor animatedIcon;

//   AnimatedRadarMarker() {
//     controller = AnimationController(
//       vsync: TestVSync(),
//       duration: Duration(milliseconds: animationDuration),
//     );

//     animation = Tween<double>(
//       begin: 0.0,
//       end: maxRadius,
//     ).animate(controller!)
//       ..addStatusListener((status) {
//         if (status == AnimationStatus.completed) {
//           controller!.reverse();
//         } else if (status == AnimationStatus.dismissed) {
//           controller!.forward();
//         }
//       });

//     controller!.forward();

//     createIcons();
//   }

//   Future<void> createIcons() async {
//     final Widget defaultIconWidget = Icon(
//       Icons.location_on,
//       color: Colors.red,
//       size: maxRadius,
//     );

//     final Widget animatedIconWidget = AnimatedBuilder(
//       animation: animation!,
//       builder: (context, child) {
//         return CustomPaint(
//           painter: RadarPainter(radius: animation!.value),
//           child: defaultIconWidget,
//         );
//       },
//     );

//     final RenderRepaintBoundary repaintBoundary = RenderRepaintBoundary();
//     final RenderObjectToWidgetAdapter<RenderBox> adapter =
//         RenderObjectToWidgetAdapter<RenderBox>(
//       container: repaintBoundary,
//       child: animatedIconWidget,
//     );
//     final Widget tree = Directionality(
//       textDirection: TextDirection.ltr,
//       child: adapter,
//     );

//     final ui.Image iconImage = await createImageFromWidget(tree);

//     final ByteData? byteData =
//         await iconImage.toByteData(format: ui.ImageByteFormat.png);

//     defaultIcon = BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List());
//     animatedIcon = defaultIcon;
//   }

//   Future<ui.Image> createImageFromWidget(Widget widget) async {
//     final RenderRepaintBoundary boundary = RenderRepaintBoundary();
//     final RenderObjectToWidgetAdapter<RenderBox> adapter =
//         RenderObjectToWidgetAdapter<RenderBox>(
//       container: boundary,
//       child: widget,
//     );
//     adapter.createRenderObject(adapter);

//     adapter.renderObject!.layout(BoxConstraints.tight(adapter.renderObject!.paintBounds.size));
//     final PipelineOwner pipelineOwner = PipelineOwner();
//     final RenderObject? root = adapter.renderObject!..prepareForPaint();
//     root!.paint(PaintingContext(pipelineOwner, Offset.zero & adapter.renderObject!.paintBounds));

//     final ui.Image image = await boundary.toImage();
//     return image;
//   }
// }

// class RadarPainter extends CustomPainter {
//   final double radius;

//   RadarPainter({required this.radius});

//   @override
//   void paint(Canvas canvas, Size size) {
//     final center = Offset(size.width / 2, size.height / 2);
//     final paint = Paint()
//       ..color = Colors.blue.withOpacity(0.3)
//       ..style = PaintingStyle.fill;

//   }
