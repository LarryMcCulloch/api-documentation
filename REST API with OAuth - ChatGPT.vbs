Dim objHTTP, strURL, objJSON, strToken

' Specify the URL of the RESTful API
strURL = "https://api.example.com/data"

' Specify the OAuth bearer token
strToken = "YOUR_OAUTH_BEARER_TOKEN"

' Create an HTTP object
Set objHTTP = CreateObject("MSXML2.ServerXMLHTTP")

' Make a GET request to the API
objHTTP.Open "GET", strURL, False
objHTTP.setRequestHeader "Authorization", "Bearer " & strToken
objHTTP.setRequestHeader "Content-Type", "application/json"
objHTTP.send

' Check if the request was successful (status code 200)
If objHTTP.status = 200 Then
    ' Parse the JSON response
    Set objJSON = CreateObject("Scripting.Dictionary")
    objJSON("Response") = objHTTP.responseText
    
    ' Access the data from the response
    Dim responseData
    responseData = objJSON("Response")
    
    ' Process the data as needed
    MsgBox responseData
Else
    ' Display an error message if the request was not successful
    MsgBox "Error: " & objHTTP.status & " - " & objHTTP.statusText
End If

' Clean up the objects
Set objJSON = Nothing
Set objHTTP = Nothing
