import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:future_functions/core/storage/day_night_theme_cubit.dart';
import 'package:future_functions/features/apod/cubit/apod_cubit.dart';
import 'package:pinch_zoom_release_unzoom/pinch_zoom_release_unzoom.dart';

import 'core/theme.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DayNightThemeCubit dayNightThemeCubit = DayNightThemeCubit();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DayNightThemeCubit, DayNightThemeState>(
      bloc: dayNightThemeCubit,
      builder: (context, state) {
        if (state is DayNightThemeChanged) {
          return MaterialApp(
            theme: ThemeData(
              colorScheme: state.isDarkTheme
                  ? MaterialTheme.darkScheme().toColorScheme()
                  : MaterialTheme.lightScheme().toColorScheme(),
              useMaterial3: true,
            ),
            home: MyHomePage(
              dayNightThemeCubit: dayNightThemeCubit,
            ),
          );
        } else {
          return MaterialApp(
            title: 'Futures',
            theme: ThemeData(
              colorScheme: MaterialTheme.lightScheme().toColorScheme(),
              useMaterial3: true,
            ),
            home: MyHomePage(
              dayNightThemeCubit: dayNightThemeCubit,
            ),
          );
        }
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.dayNightThemeCubit});

  final DayNightThemeCubit dayNightThemeCubit;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ApodCubit apodCubit = ApodCubit();
  bool blockScroll = false;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 4)).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Welcome to the Astronomy Picture of the Day!'),
        ),
      );
    });
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Astronomy picture of the day'),
      ),
      body: BlocBuilder(
        bloc: apodCubit,
        builder: (context, state) {
          if (state is ApodLoaded) {
            return SingleChildScrollView(
              controller: scrollController,
              physics: blockScroll ? const NeverScrollableScrollPhysics() : const ScrollPhysics(),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.tertiaryContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    PinchZoomReleaseUnzoomWidget(
                        twoFingersOn: () => setState(() => blockScroll = true),
                        twoFingersOff: () => Future.delayed(
                            PinchZoomReleaseUnzoomWidget.defaultResetDuration,
                            () => setState(() => blockScroll = false)),
                        child: CachedNetworkImage(imageUrl: state.apod.imageUrl)),
                    const SizedBox(height: 16),
                    Text(
                      state.apod.title,
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onTertiaryContainer),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(state.apod.explanation,
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.onTertiaryContainer)),
                  ],
                ),
              ),
            );
          } else if (state is ApodError) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Text(
                'NASA Staff',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Change Theme'),
              leading: Icon(
                Icons.brightness_4,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              onTap: () {
                widget.dayNightThemeCubit.toggleTheme();
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Go back day by day'),
              onTap: () {
                apodCubit.getApodByDate();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
