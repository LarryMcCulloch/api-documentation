# UPS API Documentation
This respository contains OpenAPI Specifications for the APIs on developer.ups.com. 

These files can be used in conjunction with various plugins and packages to generate models for UPS API request and response objects. 

All of our APIs are secured with with OAuth 2.0 protocol and require an access token to transact with. Access tokens can be generated through two different grant types, either Client Credentials (OAuth ClientCredentials) or Authorization Code (OAuth AuthCode). The grant type is based on how you will transact with UPS APIs, whether your application will represent a single entity or multiple users. For more information please check the links below:
 
 [Client Credentials](https://developer.ups.com/api/reference/oauth/client-credentials?loc=en_US) 
 
 [Authorization Code](https://developer.ups.com/api/reference/oauth/authorization-code?loc=en_US)

Client Credential vs. Authorization Code Flow
 
Before deciding what OAuth API to call for an access token, you will need to decide which OAuth flow your use case falls under.

A. <Client Credentials>: In general, the client credentials flow is for application-to-application authentication with no user interaction. In the UPS API implementation, it is used when your application or software will only transact with UPS using a single UPS.com username and shipper accounts linked to that username. For example, your shipping software would obtain a rate, create shipping labels or track packages only using your UPS.com username and shipper number.

B. <Authorization Code>: Auth-Code flow is for user-to-application authentication. In the UPS API implementation, it is used when your application or software enables other users to transact with UPS. For example, your shipping software would allow a user to use their own UPS.com username and shipper number when obtaining a rate, creating a shipping label, or tracking their package. With this flow, your software can transact on behalf of the user without handling the user’s credentials.
## License

Copyright 2022 UPS.

Code licensed under the MIT License: <http://opensource.org/licenses/MIT>
