import 'package:blrber/models/chat_detail.dart';
import 'package:blrber/models/company_detail.dart';
import 'package:blrber/models/message.dart';
import 'package:blrber/provider/motor_form_sqldb_provider.dart';
import 'package:blrber/provider/prod_images_sqldb_provider.dart';
import 'package:blrber/provider/user_details_provider.dart';
import 'package:blrber/screens/search_results.dart';
import 'package:blrber/screens/settings_screen.dart';
import 'package:blrber/screens/view_full_specs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

// Imports for Services
import './services/database.dart';
import './services/foundation.dart';

// Imports for Screens
import './screens/tabs_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/get_location.dart';
import './screens/user_chat_page.dart';

// Imports for Models
import './models/category.dart';
import './models/product.dart';
import './models/user_detail.dart';

// Imports for Providers
import './provider/get_current_location.dart';
import './provider/google_sign_in.dart';

// change1
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static const String _title = 'BLRBER';
  static const String _initialRoute = '/';
  final _routes = {
    '/': (ctx) => TabsScreen(),
    UserChatPage.routeName: (ctx) => UserChatPage(),
    ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
    GetLocation.routeName: (ctx) => GetLocation(),
    SearchResults.routeName: (ctx) => SearchResults(),
    ViewFullSpecs.routeName: (ctx) => ViewFullSpecs(),
    SettingsScreen.routeName: (ctx) => SettingsScreen(),
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
        StreamProvider<List<ForSaleBy>>.value(
          value: Database().forSaleBys,
          initialData: [],
        ),
        StreamProvider<List<FuelType>>.value(
          value: Database().fuelTypes,
          initialData: [],
        ),
        StreamProvider<List<Year>>.value(
          value: Database().years,
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
        StreamProvider<List<TempProd>>.value(
          value: Database().tempProd,
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
        StreamProvider<UserDetail>.value(
          value: Database().userDetailSpecific,
          initialData: UserDetail(),
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
              color: Colors.white,
              debugShowCheckedModeBanner: _debugShowCheckedModeBanner,
            )
          : MaterialApp(
              title: _title,
              theme: ThemeData(
                primaryColor: Colors.orange[800],
                backgroundColor: Colors.white,
                disabledColor: Colors.grey[700],
                scaffoldBackgroundColor: Colors.grey[300],
              ),
              initialRoute: _initialRoute,
              routes: _routes,
              debugShowCheckedModeBanner: _debugShowCheckedModeBanner,
            ),
    );
  }
}
