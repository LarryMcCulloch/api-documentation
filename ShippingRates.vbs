Dim objHTTP, strURL, objJSON, strToken, strVersion, strRequestOption, strBody
Dim strToName, strToAddr1, strToAddr2, strToAddr3, strToCity, strToCountryCode, strToPostalCode, strToStateProvinceCode
Dim strServiceCode, strServiceDescription, strWeight

' Specify parameters of URL
strVersion = "v1"
strRequestOption = "Rate" 
'strRequestOption = "Shop"
' Specify customer parameters
strToName = "Current Resident"
strToAddr1 = "961 S. Claudina"
strToAddr2 = ""
strToAddr3 = ""
strToCity = "Anaheim"
strToStateProvinceCode = "CA"
strToPostalCode = "92805"
strToCountryCode = "US"
' Specify UPS service and package weight
strServiceCode = "03"
strServiceDescription = "Ground"
strWeight = "1"

' Body is a JSON object containing all the request parameters
strBody = "{ " & _
    """RateRequest"": {" & _
      """Request"": {" & _
        """TransactionReference"": {" & _
          """CustomerContext"": ""Verify Success response""," & _
          """TransactionIdentifier"": ""TEST071223""" & _
        "}" & _
      "}," & _
      """Shipment"": {" & _
        """Shipper"": {" & _
          """Name"": ""Lares Research""," & _
          """ShipperNumber"": ""96X505""," & _
          """Address"": {" & _
          """AddressLine"": [" & _
            """295 Lockheed Ave""," & _
            """""," & _
            """""" & _
            "]," & _
            """City"": ""Chico""," & _
            """StateProvinceCode"": ""CA""," & _
            """PostalCode"": ""95973""," & _
            """CountryCode"": ""US""" & _
          "}" & _
        "}," & _
        """ShipTo"": {" & _
          """Name"":""" & strToName & """," & _
          """Address"": {" & _
            """AddressLine"": [" & _
              """" & strToAddr1 & """," & _
              """" & strToAddr2 & """," & _
              """" & strToAddr3 & """" & _
            "]," & _
            """City"":""" & strToCity & """," & _
            """StateProvinceCode"":""" & strToStateProvinceCode & """," & _
            """PostalCode"":""" & strToPostalCode & """," & _
            """CountryCode"":""" & strToCountryCode & """" & _
          "}" & _
        "}," & _
        """ShipFrom"": {" & _
          """Name"": ""Lares Research""," & _
          """Address"": {" & _
            """AddressLine"": ""295 Lockheed Ave""," & _
            """City"": ""Chico""," & _
            """StateProvinceCode"": ""CA""," & _
            """PostalCode"": ""95973""," & _
            """CountryCode"": ""US""" & _
          "}" & _
        "}," & _
        """PaymentDetails"": {" & _
          """ShipmentCharge"": {" & _
            """Type"": ""01""," & _
            """BillShipper"": {" & _
              """AccountNumber"": ""96X505""" & _
            "}" & _
          "}" & _
        "}," & _
        """ShipmentRatingOptions"": {" & _
          """TPFCNegotiatedRatesIndicator"": ""N""," & _
          """NegotiatedRatesIndicator"": ""N""" & _
        "}," & _
        """Service"": {" & _
          """Code"":""" & strServiceCode & """," & _
          """Description"":""" & strServiceDescription & """" & _
        "}," & _
        """NumOfPieces"": ""1""," & _
        """Package"": {" & _
          """PackagingType"": {" & _
            """Code"": ""02""," & _
            """Description"": ""Packaging""" & _
          "}," & _
          """Dimensions"": {" & _
            """UnitOfMeasurement"": {" & _
              """Code"": ""IN""," & _
              """Description"": ""Inches""" & _
            "}," & _
            """Length"": ""5""," & _
            """Width"": ""5""," & _
            """Height"": ""5""" & _
          "}," & _
          """PackageWeight"": {" & _
            """UnitOfMeasurement"": {" & _
              """Code"": ""LBS""," & _
              """Description"": ""Pounds""" & _
            "}," & _
            """Weight"":""" & strWeight & """" & _
          "}" & _
        "}" & _
      "}" & _
    "}" & _
  "}"

'  call writeResponse("RequestBody(Rate).json", strBody)
'  wscript.quit

' Specify the URL of the RESTful API
strURL = "https://wwwcie.ups.com/api/rating/"       'Development/Testing
'strURL = "https://onlinetools.ups.com/api/rating/"  'Production
strURL = strURL & strVersion & "/" & strRequestOption

' Specify the OAuth bearer token
strToken = AuthToken()
If strToken = "" Then
  ' Failed to get token
  MsgBox "Token failure"
  ' Clean up the objects
  Set objJSON = Nothing
  Set objHTTP = Nothing
  wscript.quit
End If

' Create an HTTP object
Set objHTTP = CreateObject("MSXML2.ServerXMLHTTP")

' Make a POST request to the API
objHTTP.Open "POST", strURL, False
objHTTP.setRequestHeader "Authorization", "Bearer " & strToken
objHTTP.setRequestHeader "Content-Type", "application/json"
objHTTP.setRequestHeader "transId", "12345"
objHTTP.setRequestHeader "transactionSrc", "testing"
objHTTP.send strBody

' Check if the request was successful (status code 200)
If objHTTP.status = 200 Then
    ' Parse the JSON response
    Set objJSON = CreateObject("Scripting.Dictionary")
    objJSON("Response") = objHTTP.responseText
    
    ' Access the data from the response
    Dim responseData, codeValue
    responseData = objJSON("Response")
    
    ' Process the data as needed
    call writeResponse("ResponseBody(Rate).json", responseData)
       
Else
    ' Display an error message if the request was not successful
    MsgBox "Rate Error: " & objHTTP.status & " - " & objHTTP.statusText
End If

' Clean up the objects
Set objJSON = Nothing
Set objHTTP = Nothing
'______________________________________________________________________________________________
'Write response to a file for troubleshooting'
sub writeResponse(fileName, strText)
  Dim fso, MyFile
  Set fso = CreateObject("Scripting.FileSystemObject")
  Set MyFile = fso.CreateTextFile(fileName, True)
  MyFile.WriteLine(strText)
  MyFile.Close
end sub
'______________________________________________________________________________________________
' Function to obtain authorization token
Function AuthToken
Const ForReading = 1
Const ForWriting = 2
Dim strURL, strCICS64, objHTTP, nStart, nEnd

' Create an HTTP object
Set objHTTP = CreateObject("WinHttp.WinHttpRequest.5.1")

' Set the request URL and method
strURL = "https://wwwcie.ups.com/security/v1/oauth/token"         'Development/Testing
'strURL = "https://onlinetools.ups.com/security/v1/oauth/token"    'Production
objHTTP.Open "POST", strURL, False

' Set the request headers
objHTTP.SetRequestHeader "Content-Type", "application/x-www-form-urlencoded"
objHTTP.SetRequestHeader "x-merchant-id", "96X505"

' Set the base-64 encoded client ID:client secret
strCICS64 = "WHNwcUl5UGZLcE5TaWRVTENIMldMSWJZRmNiQVVDVGI2TzdQcEZHdUhicFozcXZoOjROYUFmb2o0ZER4ZTk5UGY2ZHZiVFluaDh4SDFIcTJEUVJVdlVxeENxc3VsRG9SVHNucXZ5b1VTQ0hNV3RQcno"
objHTTP.SetRequestHeader "Authorization", "Basic " & strCICS64

' Create the request body
formData = "grant_type=client_credentials"

' Send the request
objHTTP.Send formData

' Check if the request was successful (status code 200)
If objHTTP.status = 200 Then
  
  ' Access the data from the response
  Dim responseData
  responseData = objHTTP.ResponseText

  ' Process the data as needed
  nStart = InStr(responseData, "access_token") + 15
  nEnd = InStr(responseData, "expires_in") - 3
  responseData = Mid(responseData, nStart, (nEnd - nStart))

  AuthToken = responseData
Else
    ' Display an error message if the request was not successful
    MsgBox "Auth Error: " & objHTTP.status & " - " & objHTTP.statusText
    AuthToken = ""
End If

' Clean up the objects
Set objHTTP = Nothing
End Function