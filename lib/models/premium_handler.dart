import 'package:in_app_purchase/billing_client_wrappers.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'dart:async';

class PremiumHandler {

  StreamSubscription<List<PurchaseDetails>> getPurchaseSubscription() {
    final Stream purchaseUpdates =
        InAppPurchaseConnection.instance.purchaseUpdatedStream;
    return purchaseUpdates.listen((purchases) {
      if (purchases.length > 0) {
        if (purchases[0].productID == "com.sandoche.infinideas.premium" &&
            purchases[0].status == PurchaseStatus.purchased) {
          if (Platform.isIOS) {
            InAppPurchaseConnection.instance.completePurchase(purchases[0]);
          }
          this.savePremiumUnlocked();
        }
      }
    });
  }

  Future<bool> isPremiumUnlocked() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool isDarkThemeUnlocked = sharedPreferences.getBool("premiumUnlocked");
    return isDarkThemeUnlocked == null ? false : isDarkThemeUnlocked;
  }

  void savePremiumUnlocked() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool("premiumUnlocked", true);
  }

  retrieveProducts() async {
    final bool available = await InAppPurchaseConnection.instance.isAvailable();
    if (available) {
      bool isDarkThemeUnlocked = await this.isPremiumUnlocked();
      if (!isDarkThemeUnlocked) {
        final QueryPurchaseDetailsResponse response =
        await InAppPurchaseConnection.instance.queryPastPurchases();
        if (response.error == null && response.pastPurchases.length > 0) {
          for (var pastPurchase in response.pastPurchases) {
            if (pastPurchase.productID == "com.sandoche.infinideas.premium") {
              savePremiumUnlocked();
              if (Platform.isIOS &&
                  pastPurchase.status == PurchaseStatus.purchased) {
                InAppPurchaseConnection.instance.completePurchase(pastPurchase);
              }
            }
          }
        }
      }
    }
  }

  Future purchaseItem() async {
    final bool available = await InAppPurchaseConnection.instance.isAvailable();
    if (available) {
      ProductDetails productDetails;
      Set<String> productsIds = <String>['com.sandoche.infinideas.premium'].toSet();
      final ProductDetailsResponse response = await InAppPurchaseConnection
          .instance
          .queryProductDetails(productsIds);
      if (response.notFoundIDs.isNotEmpty) {}
      productDetails = response.productDetails[0];
      final PurchaseParam purchaseParam =
      PurchaseParam(productDetails: productDetails);
      if ((Platform.isIOS &&
          productDetails.skProduct.subscriptionPeriod == null) ||
          (Platform.isAndroid &&
              productDetails.skuDetail.type == SkuType.subs)) {
        InAppPurchaseConnection.instance
            .buyConsumable(purchaseParam: purchaseParam);
      } else {
        InAppPurchaseConnection.instance
            .buyNonConsumable(purchaseParam: purchaseParam);
      }
    }
  }
}