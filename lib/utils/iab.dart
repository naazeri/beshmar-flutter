import 'package:flutter/material.dart';
import 'package:flutter_poolakey/flutter_poolakey.dart';
import '../data/app_config.dart';

class Iab {
  static bool initialized = false;

  static const String _bazaarRsa =
      'MIHNMA0GCSqGSIb3DQEBAQUAA4G7ADCBtwKBrwCzhP2qtJJlGv4K9UPDItHzAvHb2UAn6nG7CdheRqrwOm5xXrC6bALsCa1FC0vbNY4rij8jTQJev9SGnkKMvWxMwRaSDmsWZvz0ZYLQRNxeMWWRPD/wVBQtOPA/SeiC3/X7IeI/F4+UFgzvOAyf9G/GPjAXX30YN1F++D3T0UF/QD1sVrR+EkFY8z0gAianO98fxcdsUe9loMIeZrhhKIUIgnDwB34zSuwGn8RkPIECAwEAAQ==';
  static const String _bazaarProductIdFullVersion = 'fullVersion';
  static const String _payload = 'fullVersionPaymentSucceed';

  static Future<void> init() async {
    if (AppConfig.isBazaarVersion) {
      initialized = await FlutterPoolakey.connect(
        _bazaarRsa,
        onDisconnected: () async {
          /*reconnect here*/
          debugPrint('*** Disconnected');
        },
      );

      debugPrint('*** Init: $initialized');
    } else {
      // final IabResult? myketIabResult = await MyketIAP.init(
      //   rsaKey: _myketRsa,
      //   enableDebugLogging: true,
      // );

      // initialized = true;

      // debugPrint('*** Init Response: ${myketIabResult?.mResponse}');
      // debugPrint('*** Init Message: ${myketIabResult?.mMessage}');
    }
  }

  static Future<bool> buyFullVersion() async {
    if (!initialized) {
      return false;
    }

    if (AppConfig.isBazaarVersion) {
      try {
        PurchaseInfo purchaseInfo = await FlutterPoolakey.purchase(
            _bazaarProductIdFullVersion,
            payload: _payload);

        if (purchaseInfo.productId == _bazaarProductIdFullVersion &&
            purchaseInfo.payload == _payload) {
          return true;
        }
      } catch (e) {
        return false;
      }
    } else {
      // final result = await MyketIAP.launchPurchaseFlow(
      //   sku: _myketSkuFullVersion,
      //   payload: _payload,
      // );

      // return await _checkMyketProduct(result);
    }

    return false;
  }

  static Future<bool> checkIsFullVersionProduct() async {
    if (!initialized) {
      return false;
    }

    if (AppConfig.isBazaarVersion) {
      try {
        List<PurchaseInfo> purchasedProductsList =
            await FlutterPoolakey.getAllPurchasedProducts();

        for (var purchased in purchasedProductsList) {
          if (purchased.productId == _bazaarProductIdFullVersion &&
              purchased.purchaseState == PurchaseState.PURCHASED &&
              purchased.payload == _payload) {
            return true;
          }
        }
      } catch (e) {
        return false;
      }
    } else {
      // final result = await MyketIAP.getPurchase(
      //   sku: _myketSkuFullVersion,
      //   querySkuDetails: false,
      // );

      // return await _checkMyketProduct(result);
    }

    return false;
  }

  // static Future<bool> _checkMyketProduct(Map<dynamic, dynamic> result) async {
  //   if (result.isEmpty) {
  //     return false;
  //   }

  //   final IabResult? purchaseResult = result[MyketIAP.RESULT];
  //   final Purchase? purchase = result[MyketIAP.PURCHASE];

  //   debugPrint('*** Response: ${purchaseResult?.mResponse}');
  //   debugPrint('*** Message: ${purchaseResult?.mMessage}');

  //   debugPrint('*** purchase: $purchase');
  //   debugPrint('*** mItemType: ${purchase?.mItemType}');
  //   debugPrint('*** mPurchaseState: ${purchase?.mPurchaseState}');
  //   debugPrint('*** mOrderId: ${purchase?.mOrderId}');
  //   debugPrint('*** mSignature: ${purchase?.mSignature}');
  //   debugPrint('*** mSku: ${purchase?.mSku}');
  //   debugPrint('*** mToken: ${purchase?.mToken}');

  //   if (purchase?.mDeveloperPayload == _payload) {
  //     return true;
  //   }

  //   return false;
  // }

  static Future<void> dispose() async {
    if (AppConfig.isBazaarVersion) {
    } else {
      // await MyketIAP.dispose();
    }
  }
}
