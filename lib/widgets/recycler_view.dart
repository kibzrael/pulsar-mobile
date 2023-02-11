import 'package:flutter/material.dart';

class RecyclerView extends StatefulWidget {
  final RecyclerBuilder itemBuilder;
  // final ScrollController scrollController;

  final Future<List<Map<String, dynamic>>?> Function(int index) target;

  final List<Map<String, dynamic>>? initialData;
  final int initialIndex;

  final bool reversed;
  final int dataLength;
  final double bufferExtent;
  const RecyclerView({
    Key? key,
    // required this.scrollController,
    required this.target,
    required this.itemBuilder,
    this.reversed = false,
    this.dataLength = 10,
    this.bufferExtent = 1,
    this.initialData,
    this.initialIndex = 0,
  }) : super(key: key);
  @override
  State<RecyclerView> createState() => _RecyclerViewState();
}

class _RecyclerViewState extends State<RecyclerView> {
  // late ScrollController scrollController;

  bool maxScrollExtent = false;

  bool isLoading = true;

  bool fetchedInitial = false;

  bool isBuffering = false;

  bool canBuffer = true;

  bool errorLoading = false;

  bool isRefreshing = false;

  late int index;

  late Snapshot snapshot;

  @override
  void initState() {
    super.initState();
    index = widget.initialIndex;
    snapshot = Snapshot(
        onRetry: onRetry,
        refreshCallback: refreshCallback,
        onPageChanged: carouselListener,
        data: widget.initialData ?? []);
    // scrollController = widget.scrollController;
    // scrollController.addListener(scrollListener);
    if (widget.initialData == null || (widget.initialData?.isEmpty ?? true)) {
      fetchData();
    } else {
      success();
    }
  }

  fetchData() async {
    if (canBuffer && (!fetchedInitial || isBuffering || isRefreshing)) {
      List<Map<String, dynamic>>? data;

      try {
        data = await widget
            .target(isRefreshing ? 0 : index)
            .timeout(const Duration(seconds: 15), onTimeout: () async {
          // timeout (Raise an error)
          return [];
        });
      } catch (e) {
        debugPrint("Recycler view: $e");
        connectionError();
        return;
      }

      if (data == null) {
        connectionError();
        return;
      }

      if (data.isEmpty && !fetchedInitial) {
        noDataError();
        return;
      }

      if (isRefreshing) {
        refreshState();
        snapshot.data.clear();
      }

      if (data.length < widget.dataLength) canBuffer = false;

      snapshot.data = [...snapshot.data, ...data];

      index++;
      snapshot.index = index;

      success();
    }
  }

  success() {
    fetchedInitial = true;
    isLoading = false;
    isBuffering = false;
    isRefreshing = false;
    snapshot.isLoading = false;
    snapshot.error = null;
    if (mounted) setState(() {});
  }

  connectionError() {
    isLoading = false;
    isBuffering = false;
    canBuffer = !fetchedInitial;
    isRefreshing = false;
    errorLoading = true;
    snapshot.isLoading = false;
    snapshot.error = ApiError.connection;
    if (mounted) setState(() {});
  }

  noDataError() {
    snapshot.isLoading = false;
    snapshot.error = ApiError.noData;
    if (mounted) setState(() {});
  }

  Future<bool> refreshCallback() async {
    isRefreshing = true;
    canBuffer = true;
    snapshot.isLoading = true;
    snapshot.error = null;
    if (mounted) setState(() {});
    await fetchData();
    return true;
  }

  void refreshState() {
    index = 0;
    snapshot.index = index;
    isRefreshing = false;
  }

  void onRetry() {
    if (!fetchedInitial) {
      refreshCallback();
    } else {
      isBuffering = true;
    }
    snapshot.isLoading = true;

    fetchData();
    if (mounted) setState(() {});
  }

  // scrollListener() {
  //   listener(scrollController.position.maxScrollExtent -
  //       scrollController.position.pixels);
  // }
  carouselListener(int remaining) {
    if (remaining < widget.dataLength / 2) {
      maxScrollExtent = true;
      if ((!isBuffering) && canBuffer) {
        buffer();
        fetchData();
      }
    } else {
      maxScrollExtent = false;
    }
  }

  bool notificationListener(ScrollNotification notification) {
    listener(
        notification.metrics.maxScrollExtent - notification.metrics.pixels);
    return false;
  }

  listener(double scrollExtent) {
    if (scrollExtent <
        (MediaQuery.of(context).size.height * widget.bufferExtent)) {
      maxScrollExtent = true;
      if ((!isBuffering) && canBuffer) {
        buffer();
        fetchData();
      }
    } else {
      maxScrollExtent = false;
    }
  }

  buffer() {
    isBuffering = true;
    snapshot.isLoading = true;
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    // scrollController.removeListener(scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
        onNotification: notificationListener,
        child: widget.itemBuilder(context, snapshot));
  }
}

typedef RecyclerBuilder = Widget Function(
    BuildContext context, Snapshot snapshot);

class Snapshot {
  List<Map<String, dynamic>> data;
  bool? isLoading;
  ApiError? error;

  int index = 0;

  Function onRetry;
  Future<bool> Function() refreshCallback;

  Function(int remaining) onPageChanged;

  Snapshot(
      {required this.onRetry,
      required this.refreshCallback,
      required this.onPageChanged,
      this.data = const []});

  bool get errorLoading => !(isLoading ?? true);

  bool get errorLoadingMore => data.isNotEmpty && error != null;

  bool get noData => error == ApiError.noData;

  bool get isLoadingMore =>
      data.isNotEmpty && (isLoading ?? false) && error == null;
}

enum ApiError { connection, noData }
