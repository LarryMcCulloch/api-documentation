' Routine to parse JSON

Class aspJSON
    Public data
    Private p_JSONstring
    Private aj_in_string, aj_in_escape, aj_i_tmp, aj_char_tmp, aj_s_tmp, aj_line_tmp, aj_line, aj_lines
    Private aj_currentlevel, aj_currentkey, aj_currentvalue, aj_XmlHttp, aj_RegExp, aj_colonfound

    Private Sub Class_Initialize()
        Set data = CreateObject("Scripting.Dictionary")
        Set aj_RegExp = New RegExp
        aj_RegExp.Pattern = "\s{0,}(\S{1}[\s,\S]*\S{1})\s{0,}"
        aj_RegExp.Global = False
        aj_RegExp.IgnoreCase = True
        aj_RegExp.Multiline = True
    End Sub

    Private Sub Class_Terminate()
        Set data = Nothing
        Set aj_RegExp = Nothing
    End Sub

    Public Sub loadJSON(inputsource)
        If Len(inputsource) = 0 Then Err.Raise 1, "loadJSON Error", "No data to load."

        p_JSONstring = CleanUpJSONstring(inputsource)
        aj_lines = Split(p_JSONstring, Chr(13) & Chr(10))

        Dim level(99)
        aj_currentlevel = 1
        Set level(aj_currentlevel) = data

        For Each aj_line In aj_lines
            aj_currentkey = ""
            aj_currentvalue = ""
            If InStr(aj_line, ":") > 0 Then
                aj_in_string = False
                aj_in_escape = False
                aj_colonfound = False
                For aj_i_tmp = 1 To Len(aj_line)
                    If aj_in_escape Then
                        aj_in_escape = False
                    Else
                        Select Case Mid(aj_line, aj_i_tmp, 1)
                            Case """"
                                aj_in_string = Not aj_in_string
                            Case ":"
                                If Not aj_in_escape And Not aj_in_string Then
                                    aj_currentkey = Left(aj_line, aj_i_tmp - 1)
                                    aj_currentvalue = Mid(aj_line, aj_i_tmp + 1)
                                    aj_colonfound = True
                                    Exit For
                                End If
                            Case "\"
                                aj_in_escape = True
                        End Select
                    End If
                Next
                If aj_colonfound Then
                    aj_currentkey = aj_Strip(aj_JSONDecode(aj_currentkey), """")
                    If Not level(aj_currentlevel).Exists(aj_currentkey) Then level(aj_currentlevel).Add aj_currentkey, ""
                End If
            End If
            If Right(aj_line, 1) = "{" Or Right(aj_line, 1) = "[" Then
                If Len(aj_currentkey) = 0 Then aj_currentkey = level(aj_currentlevel).Count
                Set level(aj_currentlevel).Item(aj_currentkey) = CreateObject("Scripting.Dictionary")
                Set level(aj_currentlevel + 1) = level(aj_currentlevel).Item(aj_currentkey)
                aj_currentlevel = aj_currentlevel + 1
                aj_currentkey = ""
            ElseIf Right(aj_line, 1) = "}" Or Right(aj_line, 1) = "]" Or Right(aj_line, 2) = "}," Or Right(aj_line, 2) = "]," Then
                aj_currentlevel = aj_currentlevel - 1
            ElseIf Len(Trim(aj_line)) > 0 Then
                If Len(aj_currentvalue) = 0 Then aj_currentvalue = aj_line
                aj_currentvalue = getJSONValue(aj_currentvalue)

                If Len(aj_currentkey) = 0 Then aj_currentkey = level(aj_currentlevel).Count
                level(aj_currentlevel).Item(aj_currentkey) = aj_currentvalue
            End If
        Next
    End Sub

    Private Function CleanUpJSONstring(aj_originalstring)
        aj_originalstring = Replace(aj_originalstring, Chr(13) & Chr(10), "")
        aj_originalstring = Mid(aj_originalstring, 2, Len(aj_originalstring) - 2)
        aj_in_string = False
        aj_in_escape = False
        aj_s_tmp = ""
        For aj_i_tmp = 1 To Len(aj_originalstring)
            aj_char_tmp = Mid(aj_originalstring, aj_i_tmp, 1)
            If aj_in_escape Then
                aj_in_escape = False
                aj_s_tmp = aj_s_tmp & aj_char_tmp
            Else
                Select Case aj_char_tmp
                    Case "\": aj_s_tmp = aj_s_tmp & aj_char_tmp: aj_in_escape = True
                    Case """": aj_s_tmp = aj_s_tmp & aj_char_tmp: aj_in_string = Not aj_in_string
                    Case "{", "["
                        aj_s_tmp = aj_s_tmp & aj_char_tmp & IIf(aj_in_string, "", Chr(13) & Chr(10))
                    Case "}", "]"
                        aj_s_tmp = aj_s_tmp & IIf(aj_in_string, "", Chr(13) & Chr(10)) & aj_char_tmp
                    Case ",": aj_s_tmp = aj_s_tmp & aj_char_tmp & IIf(aj_in_string, "", Chr(13) & Chr(10))
                    Case Else: aj_s_tmp = aj_s_tmp & aj_char_tmp
                End Select
            End If
        Next

        CleanUpJSONstring = ""
        aj_s_tmp = Split(aj_s_tmp, Chr(13) & Chr(10))
        For Each aj_line_tmp In aj_s_tmp
            aj_line_tmp = Replace(Replace(aj_line_tmp, Chr(10), ""), Chr(13), "")
            CleanUpJSONstring = CleanUpJSONstring & Trim(aj_line_tmp) & Chr(13) & Chr(10)
        Next
    End Function

    Private Function getJSONValue(ByVal val)
        val = Trim(val)
        If Left(val, 1) = ":" Then val = Mid(val, 2)
        If Right(val, 1) = "," Then val = Left(val, Len(val) - 1)
        val = Trim(val)

        Select Case val
            Case "true": getJSONValue = True
            Case "false": getJSONValue = False
            Case "null": getJSONValue = Null
            Case Else
                If InStr(val, """") = 0 Then
                    If IsNumeric(val) Then
                        getJSONValue = CDbl(val)
                    Else
                        getJSONValue = val
                    End If
                Else
                    If Left(val, 1) = """" Then val = Mid(val, 2)
                    If Right(val, 1) = """" Then val = Left(val, Len(val) - 1)
                    getJSONValue = aj_JSONDecode(Trim(val))
                End If
        End Select
    End Function

    Private Function aj_JSONDecode(ByVal val)
        val = Replace(val, "\""", """")
        val = Replace(val, "\\", "\")
        val = Replace(val, "\/", "/")
        val = Replace(val, "\b", Chr(8))
        val = Replace(val, "\f", Chr(12))
        val = Replace(val, "\n", Chr(10))
        val = Replace(val, "\r", Chr(13))
        val = Replace(val, "\t", Chr(9))
        aj_JSONDecode = Trim(val)
    End Function

    Private Function aj_Strip(ByVal val, stripper)
        If Left(val, 1) = stripper Then val = Mid(val, 2)
        If Right(val, 1) = stripper Then val = Left(val, Len(val) - 1)
        aj_Strip = val
    End Function

	'********** Chat GPT created function *************
	
	Public Function GetNestedValue(keyList)
		' Recursive function to access nested dictionaries
		Dim keysArray, currentKey, currentDict
		keysArray = Split(keyList, ".")
		Set currentDict = data(0)

		For Each currentKey In keysArray
			If currentDict.Exists(currentKey) Then
                If currentKey <> keysArray(UBound(keysArray)) Then
                    Set currentDict = currentDict(currentKey)
                Else
                    GetNestedValue = currentDict(currentKey)
                End If
			Else
				Set GetNestedValue = Null ' Key not found
				Exit Function
			End If
		Next
	End Function
	
'******************************************************	

End Class

' Example usage
Dim myJSONParser, jsonResponse
Set myJSONParser = New aspJSON

jsonResponse = "[{""RateResponse"":{""Response"":{""ResponseStatus"":{""Code"":""1"", ""Description"":""Success""}, ""Alert"":[{""Code"":""110971"", ""Description"":""Your invoice may vary from the displayed reference rates""}], ""TransactionReference"":{""CustomerContext"":""testing""}}, ""RatedShipment"":{""TotalCharges"":{""CurrencyCode"":""USD"", ""MonetaryValue"":""20.56""}}}}]"

myJSONParser.loadJSON(jsonResponse)
' Call GetNestedValue method
WScript.Echo myJSONParser.GetNestedValue("RateResponse.RatedShipment.TotalCharges.MonetaryValue") & " (Standard Rate)"
WScript.Echo myJSONParser.GetNestedValue("RateResponse.RatedShipment.NegotiatedRateCharges.TotalCharges.MonetaryValue") & " (Negotiated Rate)"

Set myJSONParser = Nothing