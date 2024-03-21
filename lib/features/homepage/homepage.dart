import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sist_nav_connect/data/model/bus.dart';
import 'package:sist_nav_connect/features/homepage/bloc/bus_bloc.dart';
import 'package:sist_nav_connect/features/set_locaiton_page/set_location_page.dart';
import 'package:sist_nav_connect/features/share_location/share_location.dart';
import 'package:sist_nav_connect/utils/helpers.dart';

import '../../utils/storage_acess.dart';
import '../map_view_page/mapviewpage.dart';

class HomePage extends StatefulWidget {
  static const routename = "/";
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void CheckDefaultLocationSet() async {
    if (await StorageAcess().getPickupLocation() == null) {
      if (mounted) Navigator.of(context).pushNamed(SetLocationPage.routename);
    }
  }

  @override
  void initState() {
    CheckDefaultLocationSet();
    context.read<BusBloc>().add(GetBusesEvent());
    super.initState();
  }

  List<Bus> buses = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<BusBloc, BusState>(
        listener: (context, state) {
          if (state is BusDetailsState) {
            setState(() {
              buses = state.buses;
            });
          }
        },
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.only(
              top: 20,
              left: 10,
              right: 10,
            ),
            child: Stack(
              children: [
                if (buses.isEmpty)
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Buses",
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context)
                                      .pushNamed(ShareLocation.routename);
                                },
                                child: const Card(
                                  color: Color.fromARGB(255, 170, 190, 255),
                                  margin: EdgeInsets.all(10),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 10,
                                    ),
                                    child: Text(
                                      "share",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                    SetLocationPage.routename,
                                  );
                                },
                                child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    child: Icon(
                                      Icons.settings,
                                      size: 30,
                                    )),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.search,
                            size: 30,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(width: 1),
                          ),
                          hintText: "Search Destination",
                        ),
                      ),
                    ),
                    if (buses.isNotEmpty)
                      Expanded(
                        child: ListView.builder(
                          itemCount: buses.length,
                          itemBuilder: (_, index) => BusInfoCard(buses[index]),
                        ),
                      )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget BusInfoCard(Bus bus) {
    var places = [
      "Seenarikuppam",
      "ACS College",
      "Nerkundram",
      "Maduravoyul",
      "Koyambedu",
      "Vadapalani",
      "Velacherry",
      "Bye pass"
    ];

    var viaPlacesText = "";

    for (var p in places) {
      viaPlacesText += "$p>";
    }
    var randHr = nextRandomInt(7, 9);
    var randMin = nextRandomInt(0, 59);
    var randMinText = randMin > 9 ? randMin.toString() : "0$randMin";

    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(MapViewPage.routename, arguments: bus);
      },
      child: Card(
        color: const Color.fromARGB(255, 245, 248, 255),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Container(
                height: 60,
                width: 60,
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 170, 190, 255),
                  borderRadius: BorderRadius.circular(200),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    bus.busNo.toString(),
                    style: const TextStyle(
                      fontSize: 30,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SizedBox(
                  // color: Colors.amber,
                  width: double.maxFinite,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bus.routes[0].routename,
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      // RichText(
                      //   maxLines: 1,
                      //   softWrap: true,
                      //   overflow: TextOverflow.ellipsis,
                      //   text: TextSpan(
                      //     style: const TextStyle(
                      //       fontSize: 16,
                      //       color: Colors.black,
                      //     ),
                      //     children: <TextSpan>[
                      //       const TextSpan(
                      //         text: 'via: ',
                      //         style: TextStyle(fontWeight: FontWeight.bold),
                      //       ),
                      //       TextSpan(text: viaPlacesText, style: TextStyle()),
                      //     ],
                      //   ),
                      // ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text("arival time : $randHr:$randMinText AM"),
                    ],
                  ),
                ),
              ),
              // Expanded(
              //   child: Container(
              //     width: 100,
              //     color: Colors.black,
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }

  Widget busContainer() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(MapViewPage.routename);
      },
      child: const SizedBox(
        width: double.infinity,
        height: 100,
        child: Card(
          color: Color.fromARGB(255, 238, 239, 255),
          child: Row(children: []),
        ),
      ),
    );
  }
}
