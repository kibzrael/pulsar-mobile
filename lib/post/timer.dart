import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:pulsar/widgets/bottom_sheet.dart';

class CaptureTimer extends StatefulWidget {
  final double initial;
  final Function(int index) onPressed;

  const CaptureTimer({Key? key, required this.initial, required this.onPressed})
      : super(key: key);

  @override
  _CaptureTimerState createState() => _CaptureTimerState();
}

class _CaptureTimerState extends State<CaptureTimer> {
  late CarouselController controller;

  int timer = 1;

  @override
  void initState() {
    super.initState();
    controller = CarouselController();
  }

  @override
  Widget build(BuildContext context) {
    Widget timerWidget(int index, int timer) {
      return InkWell(
          onTap: () {
            controller.animateToPage(index,
                duration: const Duration(milliseconds: 300));
          },
          child: Center(child: Text('${timer.toString()}s')));
    }

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: kToolbarHeight,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Positioned(
                bottom: 9.5,
                left: (MediaQuery.of(context).size.width - 44) / 2,
                child: Container(
                  width: 44,
                  height: 25,
                  decoration: BoxDecoration(
                      color: Colors.white12,
                      borderRadius: BorderRadius.circular(15)),
                ),
              ),
              CarouselSlider(
                carouselController: controller,
                items: [
                  timerWidget(0, 30),
                  timerWidget(1, 60),
                  timerWidget(2, 90),
                ],
                options: CarouselOptions(
                    height: 44,
                    viewportFraction: 0.15,
                    enlargeCenterPage: true,
                    enlargeStrategy: CenterPageEnlargeStrategy.height,
                    initialPage: timer,
                    enableInfiniteScroll: false,
                    onPageChanged: (index, _) {
                      widget.onPressed(index == 0
                          ? 30
                          : index == 1
                              ? 60
                              : 90);
                    }),
              ),
            ],
          ),
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(bottom: 6),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.primary),
          )
        ],
      ),
    );
  }
}

class FineGrainTimer extends StatefulWidget {
  const FineGrainTimer({Key? key}) : super(key: key);

  @override
  State<FineGrainTimer> createState() => _FineGrainTimerState();
}

class _FineGrainTimerState extends State<FineGrainTimer> {
  @override
  Widget build(BuildContext context) {
    // TODO: Implement timer
    return const MyBottomSheet(
      child: SizedBox(height: 250),
    );
  }
}
