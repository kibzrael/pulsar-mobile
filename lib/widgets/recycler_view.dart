import 'package:flutter/material.dart';

class RecyclerView extends StatefulWidget {
  final RecyclerBuilder itemBuilder;
  // final ScrollController scrollController;

  final Future<List<Map<String, dynamic>>?> Function(int index) target;

  final bool reversed;
  final int dataLength;
  final int bufferExtent;
  RecyclerView(
      {required this.itemBuilder,
      // required this.scrollController,
      required this.target,
      this.reversed = false,
      this.dataLength = 10,
      this.bufferExtent = 1});
  @override
  _RecyclerViewState createState() => _RecyclerViewState();
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

  int index = 0;

  late Snapshot snapshot;

  @override
  void initState() {
    super.initState();
    snapshot = Snapshot(onRetry: onRetry, refreshCallback: refreshCallback);
    // scrollController = widget.scrollController;
    // scrollController.addListener(scrollListener);
    fetchData();
  }

  fetchData() async {
    if (canBuffer && (!fetchedInitial || isBuffering || isRefreshing)) {
      List<Map<String, dynamic>>? data;

      try {
        data = await widget
            .target(isRefreshing ? 0 : index)
            .timeout(Duration(seconds: 15), onTimeout: () {
          return null;
        });
      } catch (e) {
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
    await fetchData();
    return true;
  }

  void refreshState() {
    index = 0;
    isRefreshing = false;
  }

  void onRetry() {
    if (!fetchedInitial)
      refreshCallback();
    else
      isBuffering = true;
    snapshot.isLoading = true;

    fetchData();
    if (mounted) setState(() {});
  }

  // scrollListener() {
  //   listener(scrollController.position.maxScrollExtent -
  //       scrollController.position.pixels);
  // }

  bool notificationListener(ScrollNotification notification) {
    listener(
        notification.metrics.maxScrollExtent - notification.metrics.pixels);
    return true;
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
  List<Map<String, dynamic>> data = [];
  bool? isLoading;
  ApiError? error;

  Function onRetry;
  Future<bool> Function() refreshCallback;

  Snapshot({required this.onRetry, required this.refreshCallback});

  bool get errorLoading => !(isLoading ?? true);

  bool get errorLoadingMore => data.length > 0 && error != null;

  bool get noData => error == ApiError.noData;

  bool get isLoadingMore =>
      data.isNotEmpty && (isLoading ?? false) && error == null;
}

enum ApiError { connection, noData }
