import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'ilkanasayfa_widget.dart' show IlkanasayfaWidget;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class IlkanasayfaModel extends FlutterFlowModel<IlkanasayfaWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for Carousel widget.
  CarouselSliderController? carouselController;
  int carouselCurrentIndex = 1;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
