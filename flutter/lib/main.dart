import 'dart:async';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:yes_order/abstracts/module/yes_module.dart';
import 'package:yes_order/module_about/about_module.dart';
import 'package:yes_order/module_chat/chat_module.dart';
import 'package:yes_order/module_init/init_account_module.dart';
import 'package:yes_order/module_localization/service/localization_service/localization_service.dart';
import 'package:yes_order/module_notifications/service/fire_notification_service/fire_notification_service.dart';
import 'package:yes_order/module_orders/orders_module.dart';
import 'package:yes_order/module_profile/module_profile.dart';
import 'package:yes_order/module_splash/splash_module.dart';
import 'package:yes_order/module_theme/pressistance/theme_preferences_helper.dart';
import 'package:yes_order/module_theme/service/theme_service/theme_service.dart';
import 'package:yes_order/utils/logger/logger.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:inject/inject.dart';

import 'di/components/app.component.dart';
import 'generated/l10n.dart';
import 'module_auth/authoriazation_module.dart';
import 'module_settings/settings_module.dart';
import 'module_splash/splash_routes.dart';

import 'package:timeago/timeago.dart' as timeago;

bool system;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await timeago.setLocaleMessages('ar', timeago.ArMessages());
  await timeago.setLocaleMessages('en', timeago.EnMessages());
  await Firebase.initializeApp();
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  FlutterError.onError = (FlutterErrorDetails details) {
    FirebaseCrashlytics.instance.recordFlutterError(details);
  };
  ThemePreferencesHelper themePreferencesHelper = ThemePreferencesHelper();
  system = await themePreferencesHelper.isEmpty();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) async {
    final container = await AppComponent.create();
    FlutterError.onError = (FlutterErrorDetails details) async {
      new Logger().error('Main', details.toString(), StackTrace.current);
    };
    await runZoned<Future<void>>(() async {
      // Your App Here
      runApp(container.app);
    }, onError: (error, stackTrace) {
      new Logger().error(
          'Main', error.toString() + stackTrace.toString(), StackTrace.current);
    });
  });
}

@provide
class MyApp extends StatefulWidget {
  final AppThemeDataService _themeDataService;
  final LocalizationService _localizationService;
  final OrdersModule _ordersModule;
  final ChatModule _chatModule;
  final InitAccountModule _initAccountModule;
  final SettingsModule _settingsModule;
  final AuthorizationModule _authorizationModule;
  final SplashModule _splashModule;
  final ProfileModule _profileModule;
  final AboutModule _aboutModule;
  final FireNotificationService _fireNotificationService;

  MyApp(
    this._themeDataService,
    this._localizationService,
    this._ordersModule,
    this._chatModule,
    this._aboutModule,
    this._splashModule,
    this._fireNotificationService,
    this._initAccountModule,
    this._settingsModule,
    this._authorizationModule,
    this._profileModule,
  );

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  String lang;
  ThemeData activeTheme;
  bool authorized = false;
  var mySystemTheme = SystemUiOverlayStyle.light.copyWith(
      statusBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.grey[50]);
  var brightness = SchedulerBinding.instance.window.platformBrightness;

  @override
  void initState() {
    super.initState();
    if (system) {
      if (brightness != Brightness.dark) {
        mySystemTheme = SystemUiOverlayStyle.light.copyWith(
            statusBarIconBrightness: Brightness.dark,
            statusBarColor: Colors.grey[50]);
        widget._themeDataService.switchDarkMode(false);
      } else {
        mySystemTheme = SystemUiOverlayStyle.dark.copyWith(
            statusBarIconBrightness: Brightness.light,
            statusBarColor: Colors.grey[50]);
        widget._themeDataService.switchDarkMode(true);
      }
    } else {
      if (brightness != Brightness.dark) {
        mySystemTheme = SystemUiOverlayStyle.light.copyWith(
            statusBarIconBrightness: Brightness.dark,
            statusBarColor: Colors.grey[50]);
      } else {
        mySystemTheme = SystemUiOverlayStyle.dark.copyWith(
            statusBarIconBrightness: Brightness.light,
            statusBarColor: Colors.grey[50]);
      }
    }
    widget._fireNotificationService.init();
    widget._localizationService.localizationStream.listen((event) {
      timeago.setDefaultLocale(event);
      setState(() {});
    });

    widget._themeDataService.darkModeStream.listen((event) {
      activeTheme = event;
      if (activeTheme.brightness == Brightness.dark) {
        mySystemTheme = SystemUiOverlayStyle.light.copyWith(
            statusBarIconBrightness: Brightness.dark,
            statusBarColor: Colors.grey[50]);
      } else {
        mySystemTheme = SystemUiOverlayStyle.light.copyWith(
            statusBarIconBrightness: Brightness.light,
            statusBarColor: Colors.grey[50]);
      }
      setState(() {});
    });
  }

//AnnotatedRegion
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      initialData:
          brightness != Brightness.dark ? ThemeData.light() : ThemeData.dark(),
      future: widget._themeDataService.getActiveTheme(),
      builder: (BuildContext context, AsyncSnapshot<ThemeData> themeSnapshot) {
        return FutureBuilder(
            initialData: 'en',
            future: widget._localizationService.getLanguage(),
            builder:
                (BuildContext context, AsyncSnapshot<String> langSnapshot) {
              return getConfiguratedApp(
                YesModule.RoutesMap,
                themeSnapshot.data,
                langSnapshot.data,
              );
            });
      },
    );
  }

  Widget getConfiguratedApp(
    Map<String, WidgetBuilder> fullRoutesList,
    ThemeData theme,
    String activeLanguage,
  ) {
    return FeatureDiscovery(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorObservers: <NavigatorObserver>[observer],
        locale: activeLanguage != null
            ? Locale.fromSubtags(
                languageCode: activeLanguage,
              )
            : null,
        localizationsDelegates: [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        theme: theme,
        supportedLocales: S.delegate.supportedLocales,
        title: 'Yes توصيل',
        routes: fullRoutesList,
        initialRoute: SplashRoutes.SPLASH_SCREEN,
      ),
    );
  }
}
