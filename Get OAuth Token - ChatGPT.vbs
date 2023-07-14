Const ForReading = 1
Const ForWriting = 2

' Create an HTTP object
Set http = CreateObject("WinHttp.WinHttpRequest.5.1")

' Set the request URL and method
url = "https://wwwcie.ups.com/security/v1/oauth/token"
http.Open "POST", url, False

' Set the request headers
http.SetRequestHeader "Content-Type", "application/x-www-form-urlencoded"
http.SetRequestHeader "x-merchant-id", "96X505"
'http.SetRequestHeader "Authorization", "Basic " & Base64Encode("XspqIyPfKpNSidULCH2WLIbYFcbAUCTb6O7PpFGuHbpZ3qvh:4NaAfoj4dDxe99Pf6dvbTYnh8xH1Hq2DQRUvUqxCqsulDoRTsnqvyoUSCHMWtPrz")
http.SetRequestHeader "Authorization", "Basic " & "WHNwcUl5UGZLcE5TaWRVTENIMldMSWJZRmNiQVVDVGI2TzdQcEZHdUhicFozcXZoOjROYUFmb2o0ZER4ZTk5UGY2ZHZiVFluaDh4SDFIcTJEUVJVdlVxeENxc3VsRG9SVHNucXZ5b1VTQ0hNV3RQcno"
' Create the request body
formData = "grant_type=client_credentials"

' Send the request
http.Send formData

' Get the response data
data = http.ResponseText
WScript.Echo data

Function Base64Encode(str)
    Set objXML = CreateObject("MSXML2.DOMDocument")
    Set objNode = objXML.CreateElement("base64")
    objNode.DataType = "bin.base64"
    objNode.Text = Encode(str)
    Base64Encode = objNode.Text
    Set objNode = Nothing
    Set objXML = Nothing
End Function

Function Encode(str)
    With CreateObject("Microsoft.XMLDOM").createElement("tmp")
        .DataType = "bin.hex"
        .Text = Stream_StringToBinary(str)
        Encode = Replace(Left(Replace(.NodeTypedValue, vbLf, ""), Len(.NodeTypedValue) - 2), " ", "0")
    End With
End Function

Function Stream_StringToBinary(Text)
    Const adTypeText = 2
    Const adTypeBinary = 1

    ' Create Stream object
    Dim BinaryStream
    Set BinaryStream = CreateObject("ADODB.Stream")

    ' Set stream type to binary
    BinaryStream.Type = adTypeBinary

    ' Open the stream and write text to it
    BinaryStream.Open
    BinaryStream.WriteText Text

    ' Change stream type to text
    BinaryStream.Position = 0
    BinaryStream.Type = adTypeText

    ' Read binary data
    Stream_StringToBinary = BinaryStream.ReadText

    ' Clean up
    BinaryStream.Close
    Set BinaryStream = Nothing
End Function
