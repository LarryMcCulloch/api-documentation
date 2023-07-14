Rating Business Rules
The Rating API is used when rating or shopping a shipment. The Rating API for packages allows you to submit two types of rate requests to UPS:
 
A rate request to return the rate for a specific UPS service, for example, UPS Next Day Air
A shop request to return all available services and their rates for a shipment
 
In this way, you and your customers are able to estimate their shipping costs prior to requesting a specific shipping service or service option.

WARNING : UPS restricts the usage of the Rating API to users who plan to ship packages manifested, tendered, and delivered by UPS. Any customers or developers abusing the API or data mining the API will have their access revoked

Business Process and Rules
General
Elements/tags that are not defined in the interface or do not conform to the interface structure will be ignored by UPS.
Only users that plan to ship packages manifested, tendered, and delivered by UPS can use the API.
Any customers/developers abusing or data mining the API will have their access revoked.
Negotiated Rates
The Rating API provides access to Published Rates as well as Negotiated Rates. A negotiated rate is established by contract between the customer and UPS. If you have a pricing contract with UPS please contact your sales representative for proper setup.

Once your UPS sales rep has verified your setup you need to do the following: 1.Add your account to your My UPS profile using one of your most recent three invoices. o If you have never generated an invoice or have not generated an invoice in the past 90 days add the account using the pickup location postal code for the account. o Since you have not generated an invoice you will need to contact your sales representative a second time to enable negotiated rates in UPS systems 2.When transacting with UPS API servers include the correct My UPS ID/PW + Account + Access Key 3. Include the 'NegotiatedRatesIndicator' element within your request. The element is an empty tag.

IMPORTANT NOTES:
Negotiated rates in the CIE are for test purposes only and are not representative of actual negotiated rates. A 1% discount is applied when requested.
Post-shipment charges, such as address corrections, dimensional weight adjustments, and other adjustments will affect the actual rate billed which may differ from the rates returned by the Rating API
Make sure that all requests are identical when comparing shipping charges between applications and APIs that provide UPS Negotiated Rates.
Working through discrepancies requires knowledge of all parameters posted, defaults, numeric rounding, and the rate table used by the applications being compared.
You can check your results against the UPS Calculate Time and Cost program: https://ups.com/ctc
User Level Promotion Business Processes and rules
User level promotion is for the customers who do not have a UPS shipper account. The following conditions need to be met to use user level promotions: UserLevelDiscountIndicator in request, do not pass shipper number, Username should be present and user should be eligible for a user level promotion
If User level promotion is requested with a UPS shipper account (Shipper/ShipperNumber), User level promotion will not be requested for a given shipment.
Saturday Delivery
UPS offers Saturday Delivery options, for an additional charge, for many service levels. When requesting Time In Transit information with the Rating API, services that are eligible for Saturday Delivery may be returned. Services that are available for Saturday Delivery will have an Estimated Delivery day of week (/RatedShipment/TimeInTransit/ServiceSummary/EstimatedArrival/DayOfWeek) of "SAT" (Saturday). In addition, if there is a charge for the service, there will be a Saturday Delivery indicator with a value of "1" (/RatedShipment/TimeInTransit/ServiceSummary/SaturdayDelivery) along with a disclaimer that the service is available for an additional charge (/RatedShipment/TimeInTransit/ServiceSummary/SaturdayDeliveryDisclaimer)
Saturday Delivery is available in select cities for the non-premium services of UPS Three Day Select and UPS Ground. There is no additional charge for eligible residential destinations but a fee will apply for eligible commercial destinations. To return 'SaturdayDelivery' in the response you must send a 'Ratetimeintransit' or 'Shoptimeintransit' request. For commercial destinations you may send a 'Shoptimeintransit' without the 'SaturdayDelivery' element. For Ratetimeintransit requests shipping to commercial addresses to return a service level resulting in a Saturday Delivery, please add the 'SaturdayDeliveryIndicator' to the request.
Simple Rate Business Processes and Rules
UPS Simple Rate enables shippers to use their own packaging to ship anywhere in the U.S. for a flat rate. UPS Simple Rate offers five different rate options based on package size and is available for UPS Ground, UPS 2nd Day Air, UPS 3 Day Select and Next Day Air Saver services. It includes guaranteed delivery complete with UPS tracking and visibility
UPS Simple Rate rates are exempt from residential, delivery area extended, delivery area, and fuel surcharge fees. All other surcharges and value added accessorials apply.
The following information describes business rules for UPS Simple Rate:
Must not contain dangerous goods
Shipment is prepaid
Not valid for freight collect or third party shipments
Only valid for a single piece shipment
Up to 50 lbs.
Simple Rate Box Descriptions:
XS (Extra Small ) o Size Range: 1 to 100 cu in3
S (Small) o Size Range: 101 to 250 cu in3
M (Medium) o Size Range: 251 to 650 cu in3
L (Large) o Size Range: 651 to 1050 cu in3
XL (Extra Large) o Size Range: 1051 to 1728 cu in3
Simple Rate is available within the U.S. 50 States Only Valid for the following services (code):
UPS Ground (03)
UPS 3 Day Select (12)
UPS 2nd Day Air (02)
UPS Next Day Air Saver (13)
Using Negotiated Rates in CIE
Negotiated rates are available in the UPS Customer Integration Environment (CIE) and are returned when the Negotiated Rate indicator is provided in the rate request.

The negotiated rates returned do not reflect the contractual rate and may vary. Typically, they are 1% off the published rate.
Also in the Customer Integration Environment, the shipper eligibility for negotiated rates is not fully verified.
Negotiated Itemized Charges for UPS Worldwide Express Freight are not returned in CIE.
1% of tax charges and total charges with taxes are returned as negotiated rates in CIE mode if the TaxInformationIndicator is present in the request and if taxes are applicable.
User Level and Transactional Promotions in CIE
Discounted rates are available in the UPS Customer Integration Environment (CIE) and are returned when either the transactional promotion is valid or the User Level Discount Indicator is provided in the rate request.

The negotiated rates returned do not reflect the contractual rate and may vary. Typically, they are 1% off the published rate.
For Transactional Promotions, the promotion code is not validated. There is also no check as to whether or not the applied promotion is valid for the service or shipping lane in the request.
For User Level Promotions, the UserID is still validated to see if a valid promotion is tied to it. However, there is no check as to whether or not the applied promotion is valid for the service or shipping lane in the request.
 
All API URLs are case sensitive.
Testing:	https://wwwcie.ups.com/api/rating/{version}/{requestoption}
Production:	https://onlinetools.ups.com/api/rating/{version}/{requestoption}
 

UPS Freight Less-than-Truckload (“LTL”) transportation services are offered by TFI International Inc., its affiliates or divisions (including without limitation TForce Freight), which are not affiliated with United Parcel Service, Inc. or any of its affiliates, subsidiaries or related entities (“UPS”). UPS assumes no liability in connection with UPS Freight LTL transportation services or any other services offered or provided by TFI International Inc. or its affiliates, divisions, subsidiaries or related entities.