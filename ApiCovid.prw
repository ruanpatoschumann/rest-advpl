//ApiCovid.prw
#include 'protheus.ch'
#include 'parmtype.ch

// https://api.covid19api.com/world/total

Class ApiCovid
   Data nTotConfir // World/TotalConfirmed
   Data nTotDeath // World/TotalDeath
   Data nTotRec // World/TotalRecovered
   Method New() CONSTRUCTOR //
   Method toHTML()
EndClass

Method New() Class ApiCovid
    Local oTotCovid := FWRest():New('https://api.covid19api.com')
    Local oJson := JSonObject():New()
    Local cErr
    oTotCovid:setPath('/world/total')

    // Verify Get
    If oTotCovid:Get()
        cErr  := oJson:fromJson(oTotCovid:GetResult())
        If !empty(cErr)
            MsgStop(cErr,"JSON PARSE ERROR")
            Return
        Endif
        ::nTotConfir := oJson:GetJsonObject('TotalConfirmed')
        ::nTotDeath := oJson:GetJsonObject('TotalDeaths')
        ::nTotRec := oJson:GetJsonObject('TotalRecovered')
    Else
        conout(oTotCovid:GetLastError())
    Endif
Return Self

Method toHTML() Class ApiCovid
    Local cHTML
    cHTML := '<H2 style="color:red">Total Confirmed: ' + cValToChar(::nTotConfir) + '</H2>'
    cHTML += '<H2 style="color:black">Total Deaths: ' + cValToChar(::nTotDeath) + '</H2>'
    cHTML += '<H2 style="color:green">Total Recovered: ' + cValToChar(::nTotRec) + '</H2>'
Return cHTML

User Function apiTest()
    oCovid := ApiCovid():New()
    MessageBox(oCovid:toHTML(),'API Covid',64)
Return Nil
