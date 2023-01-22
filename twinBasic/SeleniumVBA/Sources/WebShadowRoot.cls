VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "WebShadowRoot"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Attribute VB_Description = "This class is used for exposing a shadow root DOM subtree that is rendered separately from a document's main DOM tree"
'@Exposed
'%ModuleDescription "This class is used for exposing a shadow root DOM subtree that is rendered separately from a document's main DOM tree"
'@folder("SeleniumVBA.Source")
' ==========================================================================
' SeleniumVBA v3.3
' A Selenium wrapper for Edge, Chrome, Firefox, and IE written in Windows VBA based on JSon wire protocol.
'
' (c) GCUser99
'
' https://github.com/GCuser99/SeleniumVBA/tree/main
'
' ==========================================================================
' MIT License
'
' Copyright (c) 2022 GCUser99
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

'this class is written to support Shadow Roots

Option Explicit

Private driver_ As WebDriver
Private shadowRootId_ As String

Friend Property Set driver(objWebDriver As WebDriver)
    Set driver_ = objWebDriver
End Property

Friend Property Let shadowRootId(ByVal val As String)
    shadowRootId_ = val
End Property

Friend Property Get shadowRootId() As String
    shadowRootId = shadowRootId_
End Property

'%Description("Finds the first element for a given selector and value")
Public Function FindElement(by_ As By, ByVal val As String) As WebElement
Attribute FindElement.VB_Description = "Finds the first element for a given selector and value"
    Set FindElement = driver_.FindElementFromShadowRoot(by_, val, Me)
End Function

'%Description("Finds all elements that satisfy the specified selector and value")
Public Function FindElements(by_ As By, ByVal val As String) As WebElements
Attribute FindElements.VB_Description = "Finds all elements that satisfy the specified selector and value"
    Set FindElements = driver_.FindElementsFromShadowRoot(by_, val, Me)
End Function
