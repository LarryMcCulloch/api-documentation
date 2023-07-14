' Test call
Dim strToken
strToken = AuthToken()
WScript.echo strToken



Function AuthToken
Const ForReading = 1
Const ForWriting = 2
Dim strURL, strCICS64, objHTTP, nStart, nEnd

' Create an HTTP object
Set objHTTP = CreateObject("WinHttp.WinHttpRequest.5.1")

' Set the request URL and method
strURL = "https://wwwcie.ups.com/security/v1/oauth/token"
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
    MsgBox "Error: " & objHTTP.status & " - " & objHTTP.statusText
    AuthToken = ""
End If

' Clean up the objects
Set objHTTP = Nothing

End Function