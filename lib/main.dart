import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth_provider.dart';
import 'package:shop_app/providers/orders_provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/product_details_screen.dart';
import 'package:shop_app/screens/products_overview_screen.dart';
import 'package:shop_app/screens/splash_screen.dart';
import 'package:shop_app/screens/user_product_screen.dart';
import 'helper/custom_route.dart';
import 'providers/cart_provider.dart';
import 'screens/cart_screen.dart';
import 'screens/edit_product_screen.dart';
import 'screens/orders_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: AuthProvider(),
          ),
          ChangeNotifierProxyProvider<AuthProvider, ProductsProvider>(
              create: (context) => ProductsProvider(null, [], null),
              update: (context, auth, previousProducts) => ProductsProvider(
                  auth.token, previousProducts.showAllItems, auth.userId)),
          ChangeNotifierProvider(
            create: (ctx) => CartProvider(),
          ),
          ChangeNotifierProxyProvider<AuthProvider, OrdersProvider>(
            create: (context) => OrdersProvider([], null, null),
            update: (context, auth, oldOrders) =>
                OrdersProvider(oldOrders.orders, auth.userId, auth.token),
          ),
        ],
        child: Consumer<AuthProvider>(
          builder: (_, auth, child) => MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
                primarySwatch: Colors.purple,
                accentColor: Colors.deepOrange,
                fontFamily: 'Lato',
                pageTransitionsTheme: PageTransitionsTheme(builders: {
                  TargetPlatform.android: CustomPageTransitionBuilder(),
                  TargetPlatform.iOS: CustomPageTransitionBuilder(),
                }) //this will set animation for entire app
                ),
            home: auth.isAuth
                ? ProductsOverviewsScreen()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (ctx, authresultSnapshot) =>
                        authresultSnapshot.connectionState ==
                                ConnectionState.waiting
                            ? SplashScreen()
                            : AuthScreen()),
            //home: TextFieldAutoComplete(),
            routes: {
              ProductDetailsScreen.routeName: (ctx) => ProductDetailsScreen(),
              CartScreen.routeName: (ctx) => CartScreen(),
              OrdersScreen.routeName: (ctx) => OrdersScreen(),
              UserProductScreen.routeName: (ctx) => UserProductScreen(),
              EditProductScreen.routeName: (ctx) => EditProductScreen(),
            },
          ),
        ));
  }
}
