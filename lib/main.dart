import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/set_locaiton_page/bloc/set_location_bloc.dart';
import 'features/set_locaiton_page/set_location_page.dart';
import 'features/homepage/homepage.dart';
import 'features/share_location/bloc/sharelocation_bloc.dart';
import 'features/share_location/share_location.dart';
import 'features/homepage/bloc/bus_bloc.dart';
import 'features/mainbloc/main_bloc.dart';
import 'features/map_view_page/bloc/mapbloc_bloc.dart';
import 'features/map_view_page/mapviewpage.dart';

void main() {
  runApp(BlocProvider(
    create: (context) => MainBloc(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  PageRouteBuilder _pageTransition({required Widget child}) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case HomePage.routename:
        return _pageTransition(
          child: BlocProvider(
            create: (context) => BusBloc(),
            child: const HomePage(),
          ),
        );
      case MapViewPage.routename:
        return _pageTransition(
          child: BlocProvider(
            create: (context) => MapBloc(),
            child: const MapViewPage(),
          ),
        );
      case ShareLocation.routename:
        return _pageTransition(
          child: BlocProvider(
            create: (context) => SharelocationBloc(),
            child: const ShareLocation(),
          ),
        );
      case SetLocationPage.routename:
        return _pageTransition(
          child: BlocProvider(
            create: (context) => SetLocationBloc(),
            child: const SetLocationPage(),
          ),
        );
    }

    return _pageTransition(
        child: BlocProvider(
      create: (context) => BusBloc(),
      child: const HomePage(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'sist nav connect',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      // onGenerateInitialRoutes: ,
      onGenerateRoute: generateRoute,
    );
  }
}
