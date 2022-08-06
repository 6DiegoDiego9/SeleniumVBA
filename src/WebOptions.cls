VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "WebOptions"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
' ==========================================================================
' SeleniumVBA v1.6
' A Selenium wrapper for Edge and Chrome written in Windows VBA based on JSon wire protocol.
'
' (c) GCUser99
'
' https://github.com/GCuser99/SeleniumVBA/tree/main
'
' ==========================================================================
'
' MODIFIED/EXTENDED BY GCUser99 FROM:
'
' TinySeleniumVBA v0.1.3
' A tiny Selenium wrapper written in pure VBA
'
' (c)2021 uezo
'
' Mail: uezo@uezo.net
' Twitter: @uezochan
' https://github.com/uezo/TinySeleniumVBA
'
' ==========================================================================
' MIT License
'
' Copyright (c) 2021 uezo
'
' Permission is hereby granted, free of charge, to any person obtaining a copy
' of this software and associated documentation files (the "Software"), to deal
' in the Software without restriction, including without limitation the rights
' to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
' copies of the Software, and to permit persons to whom the Software is
' furnished to do so, subject to the following conditions:
'
' The above copyright notice and this permission notice shall be included in all
' copies or substantial portions of the Software.
'
' THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
' IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
' FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
' AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
' LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
' OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
' SOFTWARE.
' ==========================================================================

' Spec for capabilities:
' - Chrome: https://chromedriver.chromium.org/capabilities
' - Edge: https://docs.microsoft.com/en-us/microsoft-edge/webdriver-chromium/capabilities-edge-options

Option Explicit

Private data_ As New Dictionary
Private browserOptionKey As String
Private browserName_ As String

Public Property Let Args(Value() As String)
    SetOption "args", Value
End Property

Public Property Get Args() As String()
    Args = GetOption("args")
End Property

Public Property Let Binary(ByVal Value As String)
    SetOption "binary", Value
End Property

Public Property Get Binary() As String
    Binary = GetOption("binary")
End Property

Public Property Let Extensions(Value() As String)
    SetOption "extensions", Value
End Property

Public Property Get Extensions() As String()
    Extensions = GetOption("extensions")
End Property

Public Property Let LocalState(ByVal Value As Dictionary)
    SetOption "localState", Value
End Property

Public Property Get LocalState() As Dictionary
    Set LocalState = GetOption("localState")
End Property

Public Property Let Prefs(Value As Dictionary)
    SetOption "prefs", Value
End Property

Public Property Get Prefs() As Dictionary
    Set Prefs = GetOption("prefs")
End Property

Public Property Let Detach(Value As Boolean)
    SetOption "detach", Value
End Property

Public Property Get Detach() As Boolean
    Detach = GetOption("detach")
End Property

Public Property Let DebuggerAddress(ByVal Value As String)
    SetOption "debuggerAddress", Value
End Property

Public Property Get DebuggerAddress() As String
    DebuggerAddress = GetOption("debuggerAddress")
End Property

Public Property Let ExcludeSwitches(Value() As String)
    SetOption "excludeSwitches", Value
End Property

Public Property Get ExcludeSwitches() As String()
    ExcludeSwitches = GetOption("excludeSwitches")
End Property

Public Property Let MinidumpPath(ByVal Value As String)
    SetOption "minidumpPath", Value
End Property

Public Property Get MinidumpPath() As String
    MinidumpPath = GetOption("minidumpPath")
End Property

Public Property Let MobileEmulation(Value As Dictionary)
    SetOption "mobileEmulation", Value
End Property

Public Property Get MobileEmulation() As Dictionary
    Set MobileEmulation = GetOption("mobileEmulation")
End Property

Public Property Let PerfLoggingPrefs(Value As Dictionary)
    SetOption "perfLoggingPrefs", Value
End Property

Public Property Get PerfLoggingPrefs() As Dictionary
    Set PerfLoggingPrefs = GetOption("perfLoggingPrefs")
End Property

Public Property Let WindowTypes(ByVal Value As String)
    SetOption "windowTypes", Value
End Property

Public Property Get WindowTypes() As String
    WindowTypes = GetOption("windowTypes")
End Property

Public Sub AddCapability(ByVal key As String, Value As Variant)
    If IsObject(Value) Then
        Set data_("alwaysMatch")(key) = Value
    Else
        data_("alwaysMatch")(key) = Value
    End If
End Sub

Public Sub SetOption(ByVal key As String, Value As Variant)
    If IsObject(Value) Then
        Set data_("alwaysMatch")(browserOptionKey)(key) = Value
    Else
        data_("alwaysMatch")(browserOptionKey)(key) = Value
    End If
End Sub

Public Function GetOption(ByVal key As String) As Variant
    If IsObject(data_("alwaysMatch")(browserOptionKey)(key)) Then
        Set GetOption = data_("alwaysMatch")(browserOptionKey)(key)
    Else
        GetOption = data_("alwaysMatch")(browserOptionKey)(key)
    End If
End Function

Public Sub AddArgument(ByVal argument As String)
    Dim arguments() As String
    Dim idx As Integer: idx = -1

    On Error Resume Next
    idx = UBound(Args)
    On Error GoTo 0
    
    If idx >= 0 Then
        arguments = Args
    End If
        
    ReDim Preserve arguments(idx + 1)
    arguments(UBound(arguments)) = argument
    
    Args = arguments
End Sub

Public Sub SetArguments(ByVal val As String, Optional ByVal delimiter As String = " ")
    SetOption "args", Split(val, delimiter)
End Sub

Public Property Let SetUserAgent(ByVal val As String)
    If Left(val, 13) <> "--user-agent=" Then val = "--user-agent=" & val
    AddArgument val
End Property

' Helper method to add prefs
Public Sub AddPref(ByVal key As String, ByVal Value As Variant)
    If Prefs Is Nothing Then
        SetOption "prefs", New Dictionary
    End If
    
    If key = "download.default_directory" Then Value = GetAbsolutePath(Value)
    If key = "browser.download.dir" Then Value = GetAbsolutePath(Value)

    Prefs(key) = Value
End Sub

' Convert to Dictionary (WebDriver takes Dictionary)
Public Function Dictionary() As Dictionary
Attribute Dictionary.VB_UserMemId = 0
    'edit class in text editor and uncomment line below to make Dictionary the default method for the class
    'this would then allow this syntax: options() -> options.Dictionary
    'Attribute Dictionary.VB_UserMemId = 0
    Set Dictionary = data_
End Function

' Convert to JSON string for debugging
Public Function ToJson() As String
    Dim jc As New WebJSonConverter
    ToJson = jc.ConvertToJson(data_, 4)
End Function

Friend Sub InitializeFor(ByVal browserName As String, Optional ByVal optionKey As String)
    Set data_ = New Dictionary
    data_.Add "browserName", browserName
    data_.Add "alwaysMatch", New Dictionary
    browserName_ = browserName
    
    Dim browserOptions As New Dictionary
    browserOptions.Add "args", Nothing
    browserOptions.Add "binary", Nothing
    browserOptions.Add "extensions", Nothing
    browserOptions.Add "localState", Nothing
    browserOptions.Add "prefs", Nothing
    browserOptions.Add "detach", Nothing
    browserOptions.Add "debuggerAddress", Nothing
    browserOptions.Add "excludeSwitches", Nothing
    browserOptions.Add "minidumpPath", Nothing
    browserOptions.Add "mobileEmulation", Nothing
    browserOptions.Add "perfLoggingPrefs", Nothing
    browserOptions.Add "windowTypes", Nothing
    
    Select Case LCase(browserName)
        Case "chrome"
            browserOptionKey = "goog:chromeOptions"
        Case "msedge"
            browserOptionKey = "ms:edgeOptions"
        Case "firefox"
            browserOptionKey = "moz:firefoxOptions"
        Case Else
            browserOptionKey = optionKey
    End Select
    
    data_("alwaysMatch").Add browserOptionKey, browserOptions
End Sub

Public Sub SetDownloadPrefs(Optional ByVal downloadDirectoryPath As String = ".\")
    downloadDirectoryPath = GetAbsolutePath(downloadDirectoryPath)

    Select Case browserName_
    Case "chrome", "msedge"
        Me.AddPref "download.default_directory", downloadDirectoryPath
        Me.AddPref "download.directory_upgrade", True
        Me.AddPref "download.prompt_for_download", False 'false disables prompting user for download permission
        Me.AddPref "safebrowsing.enabled", True
        Me.AddPref "plugins.always_open_pdf_externally", True 'instead of using the pdf viewer
        'Me.AddPref "safebrowsing.disable_download_protection", True
    Case "firefox"
        Me.AddPref "browser.download.folderList", 2 '0 is Desktop, 1 is Downloads
        Me.AddPref "browser.download.dir", downloadDirectoryPath
        Me.AddPref "pdfjs.disabled", True  'disable the built-in PDF viewer
        'Me.AddPref "browser.download.manager.showWhenStarting", False
        'Me.AddPref "browser.helperApps.neverAsk.saveToDisk", "application/pdf;text/plain;text/csv;application/text;text/xml;application/xml;application/csv;pplication/octet-stream doc xls pdf txt"
        'Me.AddPref "browser.download.useDownloadDir", True
        'Me.AddPref "browser.download.viewableInternally.enabledTypes", ""
        'this is needed to prevent a pdf from being opened instead of downloaded
    End Select
End Sub

Public Sub InitializeForChrome()
    InitializeFor "chrome"
End Sub

Public Sub InitializeForEdge()
    InitializeFor "msedge"
End Sub

Public Sub InitializeForFirefox()
    InitializeFor "firefox"
End Sub

Public Sub RunInvisible()
    Me.AddArgument "--headless"
End Sub