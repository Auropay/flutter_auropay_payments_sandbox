package net.auropay.auropay_payments_sandbox

import android.content.Context
import android.util.Log

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import org.json.JSONObject

import net.auropay.payments.AuroPay
import net.auropay.payments.domain.enums.Country
import net.auropay.payments.domain.service.CustomerProfile
import net.auropay.payments.domain.service.EventListener
import net.auropay.payments.domain.service.PaymentResultData
import net.auropay.payments.domain.service.PaymentResultListener
import net.auropay.payments.domain.service.PaymentResultWithDataListener
import net.auropay.payments.domain.service.Theme

/** AuropayPaymentsSandboxPlugin */
class AuropayPaymentsSandboxPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    private lateinit var channel: MethodChannel
    private lateinit var activityContext: Context

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel =
            MethodChannel(flutterPluginBinding.binaryMessenger, "net.auropay.auropay_payments")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {

        if (call.method == "do_payment") {

            val arguments = call.arguments as Map<*, *>
            val options = JSONObject(arguments)
            val customer = options["customerProfile"] as JSONObject

            val eventListener = object : EventListener {
                override fun onEvent(eventId: String, eventDesc: String) {
                    Log.e("native err eventId", eventId)
                    result.success(
                        mapOf(
                            "type" to "failure",
                            "data" to mapOf(
                                "error" to eventDesc,
                                "errorCode" to eventId.toString()
                            )
                        )
                    )
                }
            }

            val builder = AuroPay.Initialize()
                .subDomainId(options["subDomainId"] as String)
                .accessKey(options["accessKey"] as String)
                .secretKey(options["secretKey"] as String)
                .customerProfile(
                    CustomerProfile(
                        customer["title"] as String,
                        customer["firstName"] as String,
                        customer["middleName"] as String,
                        customer["lastName"] as String,
                        customer["phone"] as String,
                        customer["email"] as String
                    )
                )
                .addEventListener(eventListener)

            if (options.has("autoContrast")) {
                builder.autoContrast(options["autoContrast"] as Boolean)
            }

            if (options.has("country")) {
                builder.country(getCountry(options["country"] as String))
            }

            if (options.has("showReceipt")) {
                builder.showReceipt(options["showReceipt"] as Boolean)
            }

            if (options.has("theme")) {
                val theme = options["theme"] as JSONObject
                builder.theme(
                    Theme(
                        "#${theme["primaryColor"] as String}",
                        "#${theme["secondaryColor"] as String}",
                        "#${theme["colorOnPrimary"] as String}",
                        "#${theme["colorOnSecondary"] as String}",
                    )
                )
            }


            val auropay = builder.build()
            var referenceNumber: String? = null
            if (options.has("referenceNumber")) {
                referenceNumber = options["referenceNumber"] as String
            }

            if (referenceNumber != null) {
                if (options["detailedResponse"] as Boolean) {
                    auropay.doPayment(
                        activityContext,
                        options["amount"] as Double,
                        referenceNumber,
                        options["showCustomerForm"] as Boolean,
                        null,
                        object: PaymentResultWithDataListener {
                            override fun onSuccess(paymentData: PaymentResultData) {
                                result.success(
                                    mapOf(
                                        "type" to "success",
                                        "data" to mapOf(
                                            "orderId" to paymentData.orderId,
                                            "transactionStatus" to paymentData.transactionStatus,
                                            "transactionId" to paymentData.transactionId,
                                            "transactionDate" to paymentData.transactionDate,
                                            "referenceNo" to paymentData.referenceNo,
                                            "processMethod" to paymentData.processMethod,
                                            "reasonMessage" to paymentData.reasonMessage,
                                            "amount" to paymentData.amount,
                                            "convenienceFee" to paymentData.convenienceFee,
                                            "taxAmount" to paymentData.taxAmount,
                                            "discountAmount" to paymentData.discountAmount,
                                            "captureAmount" to paymentData.captureAmount,
                                        )
                                    )
                                )
                            }

                            override fun onFailure(message: String) {
                                Log.e("native err", message)
                                result.success(
                                    mapOf(
                                        "type" to "failed",
                                        "data" to mapOf(
                                            "error" to message,
                                            "errorCode" to "-1"
                                        )
                                    )
                                )
                            }
                        })
                } else {
                    auropay.doPayment(
                        activityContext,
                        options["amount"] as Double,
                        referenceNumber,
                        options["showCustomerForm"] as Boolean,
                        object : PaymentResultListener {
                            override fun onSuccess(
                                orderId: String,
                                transactionStatus: Int,
                                transactionId: String
                            ) {
                                result.success(
                                    mapOf(
                                        "type" to "success",
                                        "data" to mapOf(
                                            "orderId" to orderId,
                                            "transactionStatus" to transactionStatus,
                                            "transactionId" to transactionId
                                        )
                                    )
                                )
                            }

                            override fun onFailure(message: String) {

                                Log.e("native err", message)
                                result.success(
                                    mapOf(
                                        "type" to "failed",
                                        "data" to mapOf(
                                            "error" to message,
                                            "errorCode" to "-1"
                                        )
                                    )
                                )
                            }
                        },
                        null)
                }
            } else {
                if (options["detailedResponse"] as Boolean) {
                    auropay.doPayment(
                        activityContext,
                        options["amount"] as Double,
                        null,
                        options["showCustomerForm"] as Boolean,
                        null,
                        object : PaymentResultWithDataListener {
                            override fun onSuccess(paymentData: PaymentResultData) {
                                result.success(
                                    mapOf(
                                        "type" to "success",
                                        "data" to mapOf(
                                            "orderId" to paymentData.orderId,
                                            "transactionStatus" to paymentData.transactionStatus,
                                            "transactionId" to paymentData.transactionId,
                                            "transactionDate" to paymentData.transactionDate,
                                            "referenceNo" to paymentData.referenceNo,
                                            "processMethod" to paymentData.processMethod,
                                            "reasonMessage" to paymentData.reasonMessage,
                                            "amount" to paymentData.amount,
                                            "convenienceFee" to paymentData.convenienceFee,
                                            "taxAmount" to paymentData.taxAmount,
                                            "discountAmount" to paymentData.discountAmount,
                                            "captureAmount" to paymentData.captureAmount,
                                        )
                                    )
                                )
                            }

                            override fun onFailure(message: String) {

                                Log.e("native err", message)
                                result.success(
                                    mapOf(
                                        "type" to "failed",
                                        "data" to mapOf(
                                            "error" to message,
                                            "errorCode" to "-1"
                                        )
                                    )
                                )
                            }
                        })
                } else {
                    auropay.doPayment(
                        activityContext,
                        options["amount"] as Double,
                        null,
                        options["showCustomerForm"] as Boolean,
                        object : PaymentResultListener {
                            override fun onSuccess(
                                orderId: String,
                                transactionStatus: Int,
                                transactionId: String
                            ) {
                                result.success(
                                    mapOf(
                                        "type" to "success",
                                        "data" to mapOf(
                                            "orderId" to orderId,
                                            "transactionStatus" to transactionStatus,
                                            "transactionId" to transactionId
                                        )
                                    )
                                )
                            }

                            override fun onFailure(message: String) {
                                Log.e("native err", message)
                                result.success(
                                    mapOf(
                                        "type" to "failed",
                                        "data" to mapOf(
                                            "error" to message,
                                            "errorCode" to "-1"
                                        )
                                    )
                                )
                            }
                        },
                        null)
                }
            }

        } else {
            result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(p0: ActivityPluginBinding) {
        activityContext = p0.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {

    }

    override fun onReattachedToActivityForConfigChanges(p0: ActivityPluginBinding) {

    }

    override fun onDetachedFromActivity() {

    }

    private fun getCountry(country: String): Country {
        return when (country) {
            "in" -> Country.IN
            "us" -> Country.US
            else -> Country.IN
        }
    }
}
