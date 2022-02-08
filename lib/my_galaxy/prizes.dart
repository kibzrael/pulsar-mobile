import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

// class ChallengePrizes extends StatefulWidget {
//   @override
//   _ChallengePrizesState createState() => _ChallengePrizesState();
// }

// class _ChallengePrizesState extends State<ChallengePrizes> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Prizes'),
//       ),
//     );
//   }
// }

class ChallengePrizes extends StatefulWidget {
  @override
  _ChallengePrizesState createState() => _ChallengePrizesState();
}

class _ChallengePrizesState extends State<ChallengePrizes> {
  late PageController _pageController;
  late ScrollController _listScrollController;
  late ScrollController _activeScrollController;
  Drag? _drag;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _listScrollController = ScrollController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _listScrollController.dispose();
    super.dispose();
  }

  void _handleDragStart(DragStartDetails details) {
    if (_listScrollController.hasClients) {
      final RenderBox renderBox = _listScrollController
          .position.context.storageContext
          .findRenderObject() as RenderBox;
      if (renderBox.paintBounds
          .shift(renderBox.localToGlobal(Offset.zero))
          .contains(details.globalPosition)) {
        _activeScrollController = _listScrollController;
        _drag = _activeScrollController.position.drag(details, _disposeDrag);
        return;
      }
    }
    _activeScrollController = _pageController;
    _drag = _pageController.position.drag(details, _disposeDrag);
  }

  /*
   * If the listView is on Page 1, then change the condition as "details.primaryDelta < 0" and
   * "_activeScrollController.position.pixels ==  _activeScrollController.position.maxScrollExtent"
   */
  void _handleDragUpdate(DragUpdateDetails details) {
    if (_activeScrollController == _listScrollController &&
        (details.primaryDelta ?? 0) > 0 &&
        _activeScrollController.position.pixels ==
            _activeScrollController.position.minScrollExtent) {
      _activeScrollController = _pageController;
      _drag?.cancel();
      _drag = _pageController.position.drag(
          DragStartDetails(
              globalPosition: details.globalPosition,
              localPosition: details.localPosition),
          _disposeDrag);
    }
    _drag?.update(details);
  }

  void _handleDragEnd(DragEndDetails details) {
    _drag?.end(details);
  }

  void _handleDragCancel() {
    _drag?.cancel();
  }

  void _disposeDrag() {
    _drag = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Prizes'),
      ),
      body: RawGestureDetector(
        gestures: <Type, GestureRecognizerFactory>{
          VerticalDragGestureRecognizer: GestureRecognizerFactoryWithHandlers<
                  VerticalDragGestureRecognizer>(
              () => VerticalDragGestureRecognizer(),
              (VerticalDragGestureRecognizer instance) {
            instance
              ..onStart = _handleDragStart
              ..onUpdate = _handleDragUpdate
              ..onEnd = _handleDragEnd
              ..onCancel = _handleDragCancel;
          })
        },
        behavior: HitTestBehavior.opaque,
        child: PageView(
          controller: _pageController,
          scrollDirection: Axis.vertical,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Center(child: Text('Page 1')),
            ListView(
              controller: _listScrollController,
              physics: const NeverScrollableScrollPhysics(),
              children: List.generate(
                20,
                (int index) {
                  return ListTile(title: Text('Item $index'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// const _persistantBottomSheetHeaderHeight = 30.0;

// class ChallengePrizes extends StatefulWidget {
//   @override
//   _ChallengePrizesState createState() => _ChallengePrizesState();
// }

// class _ChallengePrizesState extends State<ChallengePrizes> {
//   @override
//   Widget build(BuildContext context) {
//     double fullSizeHeight = MediaQuery.of(context).size.height;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Prizes'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               'Pull bottom sheet',
//             ),
//           ],
//         ),
//       ),
//       bottomSheet: BottomWidget(fullSizeHeight: fullSizeHeight),
//     );
//   }
// }

// class BottomWidget extends StatefulWidget {
//   final double fullSizeHeight;

//   BottomWidget({required this.fullSizeHeight});

//   @override
//   BottomWidgetState createState() => BottomWidgetState();
// }

// class BottomWidgetState extends State<BottomWidget> {
//   //start drag position of widget's gesture detector
//   Offset? startPosition;

//   //offset from startPosition within drag event of widget's gesture detector
//   late double dyOffset;

//   //boundaries for height of widget (bottom sheet)
//   late List<double> heights;

//   //current height of widget (bottom sheet)
//   late double height;

//   //ScrollController for inner ListView
//   late ScrollController innerListScrollController;

//   //is user scrolling down inner ListView
//   late bool isInnerScrollDoingDown;

//   @override
//   void initState() {
//     super.initState();

//     heights = [
//       _persistantBottomSheetHeaderHeight,
//       widget.fullSizeHeight / 2,
//       widget.fullSizeHeight
//     ];
//     height = heights[0];

//     //initialize inner list's scroll controller and listen to its changes
//     innerListScrollController = ScrollController();
//     innerListScrollController.addListener(_scrollOffsetChanged);
//     isInnerScrollDoingDown = false;

//     dyOffset = 0.0;
//   }

//   @override
//   Widget build(BuildContext context) {
//     //GestureDetector can catch drag events only if inner ListView isn't scrollable (only if _getScrollEnabled() returns false)
//     return GestureDetector(
//       onVerticalDragUpdate: (DragUpdateDetails dragDetails) =>
//           dyOffset += dragDetails.delta.dy,
//       onVerticalDragStart: (DragStartDetails dragDetails) {
//         startPosition = dragDetails.globalPosition;
//         dyOffset = 0;
//       },
//       onVerticalDragEnd: (DragEndDetails dragDetails) => _changeHeight(),
//       child: Container(
//         height: height,
//         color: Colors.deepOrange,
//         child: InnerList(
//           scrollEnabled: _getInnerScrollEnabled(),
//           listViewScrollController: innerListScrollController,
//         ),
//       ),
//     );
//   }

//   //returns if inner ListView scroll is enabled
//   //true if:
//   // 1) container's height is height of entire screen
//   // 2) inner ListView has not been scrolled down from first element
//   bool _getInnerScrollEnabled() {
//     bool isFullSize = heights.last == height;
//     bool isScrollZeroOffset = innerListScrollController.hasClients
//         ? innerListScrollController.offset == 0.0 && isInnerScrollDoingDown
//         : false;
//     bool result = isFullSize && !isScrollZeroOffset;

//     //reset isInnerScrollDoingDown
//     if (!result) isInnerScrollDoingDown = false;
//     return result;
//   }

//   void _scrollOffsetChanged() {
//     if (innerListScrollController.offset < 0.0) {
//       isInnerScrollDoingDown = true;
//     } else if (innerListScrollController.offset > 0.0) {
//       isInnerScrollDoingDown = false;
//     }

//     if (innerListScrollController.offset <= 0.0) {
//       setState(() {});
//     }
//   }

//   void _changeHeight() {
//     if (dyOffset < 0) {
//       setState(() {
//         int curIndex = heights.indexOf(height);
//         int newIndex = curIndex + 1;
//         height =
//             newIndex >= heights.length ? heights[curIndex] : heights[newIndex];
//       });
//     } else if (dyOffset > 0) {
//       setState(() {
//         int curIndex = heights.indexOf(height);
//         int newIndex = curIndex - 1;
//         height = newIndex < 0 ? heights[curIndex] : heights[newIndex];
//       });
//     }
//   }

//   @override
//   void dispose() {
//     innerListScrollController.removeListener(_scrollOffsetChanged);

//     super.dispose();
//   }
// }

// class InnerList extends StatelessWidget {
//   final bool scrollEnabled;
//   final ScrollController listViewScrollController;

//   InnerList(
//       {required this.scrollEnabled, required this.listViewScrollController});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: <Widget>[
//         Text("persistant text"),
//         Expanded(
//           child: ListView.builder(
//               controller: listViewScrollController,
//               physics: scrollEnabled
//                   ? AlwaysScrollableScrollPhysics()
//                   : NeverScrollableScrollPhysics(),
//               itemBuilder: (BuildContext context, int index) => Card(
//                     child: Center(
//                       child: Text(index.toString()),
//                     ),
//                   )),
//         )
//       ],
//     );
//   }
// }
