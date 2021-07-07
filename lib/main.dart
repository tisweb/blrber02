import 'package:blrber/models/chat_detail.dart';
import 'package:blrber/models/company_detail.dart';
import 'package:blrber/models/message.dart';
import 'package:blrber/provider/motor_form_sqldb_provider.dart';
import 'package:blrber/provider/prod_images_sqldb_provider.dart';
import 'package:blrber/provider/user_details_provider.dart';
import 'package:blrber/screens/dynamic_link_screen.dart';
import 'package:blrber/screens/search_results.dart';
import 'package:blrber/screens/settings_screen.dart';
import 'package:blrber/screens/user_chat_screen.dart';
import 'package:blrber/screens/view_full_specs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

// Imports for Services
import './services/database.dart';
import './services/foundation.dart';

// Imports for Screens
import './screens/tabs_screen.dart';
import './screens/product_detail_screen.dart';

// Imports for Models
import './models/category.dart';
import './models/product.dart';
import './models/user_detail.dart';

// Imports for Providers
import './provider/get_current_location.dart';
import './provider/google_sign_in.dart';
import 'constants.dart';

// change1
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static const String _title = 'BLRBER';
  static const String _initialRoute = '/';
  final _routes = {
    '/': (ctx) => TabsScreen(),
    UserChatScreen.routeName: (ctx) => UserChatScreen(),
    ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
    SearchResults.routeName: (ctx) => SearchResults(),
    ViewFullSpecs.routeName: (ctx) => ViewFullSpecs(),
    SettingsScreen.routeName: (ctx) => SettingsScreen(),
    '/helloworld': (BuildContext context) => DynamicLinkScreen(),
  };
  static const bool _debugShowCheckedModeBanner = false;
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => GoogleSignInProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ProdImagesSqlDbProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => MotorFormSqlDbProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserDetailsProvider(),
        ),
        StreamProvider<List<Product>>.value(
          value: Database().products,
          initialData: [],
        ),
        StreamProvider<List<CtmSpecialInfo>>.value(
          value: Database().ctmSpecialInfos,
          initialData: [],
        ),
        StreamProvider<List<ProdImages>>.value(
          value: Database().prodImages,
          initialData: [],
        ),
        StreamProvider<List<ProductCondition>>.value(
          value: Database().productConditions,
          initialData: [],
        ),
        StreamProvider<List<DeliveryInfo>>.value(
          value: Database().deliveryinfos,
          initialData: [],
        ),
        StreamProvider<List<TypeOfAd>>.value(
          value: Database().typeOfAds,
          initialData: [],
        ),
        StreamProvider<List<ForSaleBy>>.value(
          value: Database().forSaleBys,
          initialData: [],
        ),
        StreamProvider<List<FuelType>>.value(
          value: Database().fuelTypes,
          initialData: [],
        ),
        StreamProvider<List<Make>>.value(
          value: Database().makes,
          initialData: [],
        ),
        StreamProvider<List<Model>>.value(
          value: Database().models,
          initialData: [],
        ),
        StreamProvider<List<VehicleType>>.value(
          value: Database().vehicleTypes,
          initialData: [],
        ),
        StreamProvider<List<SubModel>>.value(
          value: Database().subModels,
          initialData: [],
        ),
        StreamProvider<List<DriveType>>.value(
          value: Database().driveTypes,
          initialData: [],
        ),
        StreamProvider<List<BodyType>>.value(
          value: Database().bodyTypes,
          initialData: [],
        ),
        StreamProvider<List<Transmission>>.value(
          value: Database().transmissions,
          initialData: [],
        ),
        StreamProvider<List<FavoriteProd>>.value(
          value: Database().favoriteProd,
          initialData: [],
        ),
        StreamProvider<List<Category>>.value(
          value: Database().categories,
          initialData: [],
        ),
        StreamProvider<List<SubCategory>>.value(
          value: Database().subCategories,
          initialData: [],
        ),
        StreamProvider<List<UserDetail>>.value(
          value: Database().userDetails,
          initialData: [],
        ),
        StreamProvider<List<AdminUser>>.value(
          value: Database().adminUsers,
          initialData: [],
        ),
        StreamProvider<List<CompanyDetail>>.value(
          value: Database().companyDetails,
          initialData: [],
        ),
        StreamProvider<List<UserType>>.value(
          value: Database().userTypes,
          initialData: [],
        ),
        StreamProvider<List<ChatDetail>>.value(
          value: Database().chatDetails,
          initialData: [],
        ),
        StreamProvider<List<ReceivedMsgCount>>.value(
          value: Database().receivedMsgCounts,
          initialData: [],
        ),
        ChangeNotifierProvider(
          create: (context) => GetCurrentLocation(),
        ),
      ],
      child: isIos
          ? CupertinoApp(
              localizationsDelegates: <LocalizationsDelegate<dynamic>>[
                DefaultMaterialLocalizations.delegate,
                DefaultWidgetsLocalizations.delegate,
                DefaultCupertinoLocalizations.delegate,
              ],
              title: _title,
              initialRoute: _initialRoute,
              routes: _routes,
              color: bBackgroundColor,
              debugShowCheckedModeBanner: _debugShowCheckedModeBanner,
            )
          : MaterialApp(
              title: _title,
              theme: ThemeData(
                  primaryColor: bPrimaryColor,
                  backgroundColor: bBackgroundColor,
                  disabledColor: bDisabledColor,
                  scaffoldBackgroundColor: bScaffoldBackgroundColor,
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                  fontFamily: bFontFamily),
              initialRoute: _initialRoute,
              routes: _routes,
              debugShowCheckedModeBanner: _debugShowCheckedModeBanner,
            ),
    );
  }
}
