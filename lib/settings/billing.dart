import 'package:flutter/material.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/classes/info.dart';
import 'package:pulsar/functions/bottom_sheet.dart';
import 'package:pulsar/info/info.dart';
import 'package:pulsar/placeholders/not_implemented.dart';

class Billing extends StatefulWidget {
  const Billing({Key? key}) : super(key: key);

  @override
  State<Billing> createState() => _BillingState();
}

class _BillingState extends State<Billing> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Billing'),
          actions: [
            IconButton(
                icon: Icon(MyIcons.info),
                onPressed: () {
                  openBottomSheet(
                      context,
                      (context) => InfoSheet(Info(
                          [InfoSection(title: "Billing", description: "")])));
                })
          ],
        ),
        body: const NotImplementedError()
        // SingleChildScrollView(
        //   child: Column(children: [
        //     Card(
        //       elevation: 4,
        //       shape: const CircleBorder(),
        //       child: Container(
        //         height: 120,
        //         width: 120,
        //         alignment: Alignment.center,
        //         child: Column(
        //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //             children: [
        //               Text(
        //                 '\$',
        //                 style: Theme.of(context)
        //                     .textTheme
        //                     .titleSmall!
        //                     .copyWith(fontSize: 16.5),
        //               ),
        //               Text(
        //                 '25.7K',
        //                 style: Theme.of(context)
        //                     .textTheme
        //                     .titleLarge!
        //                     .copyWith(fontSize: 24),
        //               ),
        //               Text(
        //                 'Points',
        //                 style: Theme.of(context)
        //                     .textTheme
        //                     .titleSmall!
        //                     .copyWith(fontSize: 16.5),
        //               )
        //             ]),
        //       ),
        //     ),
        //     Container(
        //       height: 65,
        //       margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        //       child: Row(
        //           mainAxisAlignment: MainAxisAlignment.spaceAround,
        //           children: [
        //             Column(
        //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //               children: <Widget>[
        //                 Text('24.3K',
        //                     style: Theme.of(context)
        //                         .textTheme
        //                         .titleLarge!
        //                         .copyWith(fontSize: 21)),
        //                 Text('Spent',
        //                     overflow: TextOverflow.ellipsis,
        //                     style: Theme.of(context)
        //                         .textTheme
        //                         .titleSmall!
        //                         .copyWith(fontSize: 16.5))
        //               ],
        //             ),
        //             Column(
        //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //               children: <Widget>[
        //                 Text('41.6K',
        //                     style: Theme.of(context)
        //                         .textTheme
        //                         .titleLarge!
        //                         .copyWith(fontSize: 21)),
        //                 Text('Earned',
        //                     overflow: TextOverflow.ellipsis,
        //                     style: Theme.of(context)
        //                         .textTheme
        //                         .titleSmall!
        //                         .copyWith(fontSize: 16.5))
        //               ],
        //             ),
        //           ]),
        //     ),
        //     Container(
        //       margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
        //       child: Row(
        //         children: [
        //           Flexible(
        //             child: ActionButton(
        //               title: 'Deposit',
        //               height: 42,
        //               backgroundColor: Theme.of(context).disabledColor,
        //               titleColor: Theme.of(context).textTheme.bodyMedium?.color,
        //             ),
        //           ),
        //           const SizedBox(width: 15),
        //           const Flexible(
        //             child: ActionButton(
        //               title: 'Withdraw',
        //               height: 42,
        //             ),
        //           )
        //         ],
        //       ),
        //     ),
        //     const SizedBox(
        //       height: 15,
        //     ),
        //     Section(
        //       title: 'Promotions',
        //       child: SizedBox(
        //         height: 125,
        //         child: ListView.separated(
        //             itemCount: 5,
        //             scrollDirection: Axis.horizontal,
        //             physics: const BouncingScrollPhysics(),
        //             padding: const EdgeInsets.symmetric(horizontal: 10),
        //             separatorBuilder: (BuildContext context, int index) {
        //               return const SizedBox(
        //                 width: 15,
        //               );
        //             },
        //             itemBuilder: (context, index) {
        //               return Padding(
        //                 padding: const EdgeInsets.only(left: 5),
        //                 child: InkWell(
        //                   onTap: () {},
        //                   child: ClipRRect(
        //                     borderRadius: const BorderRadius.all(
        //                       Radius.circular(
        //                         21,
        //                       ),
        //                     ),
        //                     child: Stack(
        //                       alignment: Alignment.bottomCenter,
        //                       children: <Widget>[
        //                         Container(
        //                             height: 125,
        //                             width: 175,
        //                             color: Theme.of(context)
        //                                 .inputDecorationTheme
        //                                 .fillColor
        //                             // child: Image.asset(images[index],
        //                             //     height: double.infinity,
        //                             //     width: double.infinity,
        //                             //     fit: BoxFit.cover),
        //                             ),
        //                       ],
        //                     ),
        //                   ),
        //                 ),
        //               );
        //             }),
        //       ),
        //     ),
        //     const SizedBox(
        //       height: 15,
        //     ),
        //     Section(
        //       title: 'Transactions',
        //       child: ListView.builder(
        //           itemCount: 7,
        //           physics: const NeverScrollableScrollPhysics(),
        //           shrinkWrap: true,
        //           itemBuilder: (context, index) {
        //             return MyListTile(
        //               title: 'Name',
        //               subtitle: 'Trans Date',
        //               trailingText: '\$2.1K',
        //               trailingArrow: false,
        //               flexRatio: const [3, 1],
        //               leading: Container(
        //                 height: 60,
        //                 width: 60,
        //                 decoration: BoxDecoration(
        //                     color: Theme.of(context).dividerColor,
        //                     borderRadius: BorderRadius.circular(12)),
        //               ),
        //             );
        //           }),
        //     )
        //   ]),
        // ),: SingleChildScrollView(
        //   child: Column(children: [
        //     Card(
        //       elevation: 4,
        //       shape: const CircleBorder(),
        //       child: Container(
        //         height: 120,
        //         width: 120,
        //         alignment: Alignment.center,
        //         child: Column(
        //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //             children: [
        //               Text(
        //                 '\$',
        //                 style: Theme.of(context)
        //                     .textTheme
        //                     .titleSmall!
        //                     .copyWith(fontSize: 16.5),
        //               ),
        //               Text(
        //                 '25.7K',
        //                 style: Theme.of(context)
        //                     .textTheme
        //                     .titleLarge!
        //                     .copyWith(fontSize: 24),
        //               ),
        //               Text(
        //                 'Points',
        //                 style: Theme.of(context)
        //                     .textTheme
        //                     .titleSmall!
        //                     .copyWith(fontSize: 16.5),
        //               )
        //             ]),
        //       ),
        //     ),
        //     Container(
        //       height: 65,
        //       margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        //       child: Row(
        //           mainAxisAlignment: MainAxisAlignment.spaceAround,
        //           children: [
        //             Column(
        //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //               children: <Widget>[
        //                 Text('24.3K',
        //                     style: Theme.of(context)
        //                         .textTheme
        //                         .titleLarge!
        //                         .copyWith(fontSize: 21)),
        //                 Text('Spent',
        //                     overflow: TextOverflow.ellipsis,
        //                     style: Theme.of(context)
        //                         .textTheme
        //                         .titleSmall!
        //                         .copyWith(fontSize: 16.5))
        //               ],
        //             ),
        //             Column(
        //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //               children: <Widget>[
        //                 Text('41.6K',
        //                     style: Theme.of(context)
        //                         .textTheme
        //                         .titleLarge!
        //                         .copyWith(fontSize: 21)),
        //                 Text('Earned',
        //                     overflow: TextOverflow.ellipsis,
        //                     style: Theme.of(context)
        //                         .textTheme
        //                         .titleSmall!
        //                         .copyWith(fontSize: 16.5))
        //               ],
        //             ),
        //           ]),
        //     ),
        //     Container(
        //       margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
        //       child: Row(
        //         children: [
        //           Flexible(
        //             child: ActionButton(
        //               title: 'Deposit',
        //               height: 42,
        //               backgroundColor: Theme.of(context).disabledColor,
        //               titleColor: Theme.of(context).textTheme.bodyMedium?.color,
        //             ),
        //           ),
        //           const SizedBox(width: 15),
        //           const Flexible(
        //             child: ActionButton(
        //               title: 'Withdraw',
        //               height: 42,
        //             ),
        //           )
        //         ],
        //       ),
        //     ),
        //     const SizedBox(
        //       height: 15,
        //     ),
        //     Section(
        //       title: 'Promotions',
        //       child: SizedBox(
        //         height: 125,
        //         child: ListView.separated(
        //             itemCount: 5,
        //             scrollDirection: Axis.horizontal,
        //             physics: const BouncingScrollPhysics(),
        //             padding: const EdgeInsets.symmetric(horizontal: 10),
        //             separatorBuilder: (BuildContext context, int index) {
        //               return const SizedBox(
        //                 width: 15,
        //               );
        //             },
        //             itemBuilder: (context, index) {
        //               return Padding(
        //                 padding: const EdgeInsets.only(left: 5),
        //                 child: InkWell(
        //                   onTap: () {},
        //                   child: ClipRRect(
        //                     borderRadius: const BorderRadius.all(
        //                       Radius.circular(
        //                         21,
        //                       ),
        //                     ),
        //                     child: Stack(
        //                       alignment: Alignment.bottomCenter,
        //                       children: <Widget>[
        //                         Container(
        //                             height: 125,
        //                             width: 175,
        //                             color: Theme.of(context)
        //                                 .inputDecorationTheme
        //                                 .fillColor
        //                             // child: Image.asset(images[index],
        //                             //     height: double.infinity,
        //                             //     width: double.infinity,
        //                             //     fit: BoxFit.cover),
        //                             ),
        //                       ],
        //                     ),
        //                   ),
        //                 ),
        //               );
        //             }),
        //       ),
        //     ),
        //     const SizedBox(
        //       height: 15,
        //     ),
        //     Section(
        //       title: 'Transactions',
        //       child: ListView.builder(
        //           itemCount: 7,
        //           physics: const NeverScrollableScrollPhysics(),
        //           shrinkWrap: true,
        //           itemBuilder: (context, index) {
        //             return MyListTile(
        //               title: 'Name',
        //               subtitle: 'Trans Date',
        //               trailingText: '\$2.1K',
        //               trailingArrow: false,
        //               flexRatio: const [3, 1],
        //               leading: Container(
        //                 height: 60,
        //                 width: 60,
        //                 decoration: BoxDecoration(
        //                     color: Theme.of(context).dividerColor,
        //                     borderRadius: BorderRadius.circular(12)),
        //               ),
        //             );
        //           }),
        //     )
        //   ]),
        // ),
        );
  }
}
