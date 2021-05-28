// ApiMethods.prw
#include 'protheus.ch'
#include 'parmtype.ch
// POST on https://reqres.in/api/users + (Req. Body Params) =       201
// ---- data: {email, first_name, job, avatar}
// GET on https://reqres.in/api/users/{id} =                        200 .OR. 404
// PUT on https://reqres.in/api/users/{id} + (Req. Body Params) =   200
// ---- data: {email, first_name, job, avatar}
// PATCH on https://reqres.in/api/users/{id} + (Req. Body Params) = 200
// ---- data: {email, first_name, job, avatar}
// DELETE on https://reqres.in/api/users/{id} =                     204

Class ApiMethods
    Data nId            // Will exists after creation
    Data cEmail         // xirtam@liamg.oc
    Data cName          // Morpheus suehproM
    Data cJob           // Leader
    Data cAvatar        // https://placekitten.com/300/300
    Data cCreatedAt     // Will exists after creation
    Data cUpdatedAt     // Will exists after update

    Method New(cEmail, cName, cJob, cAvatar) CONSTRUCTOR //
    Method toHTML()
    Method Clear()
    Method _Post()
    Method _Get()
    Method _Put()
    Method _Patch()
    Method _Delete()
EndClass

Method New(cEmail, cName, cJob, cAvatar) Class ApiMethods
    ::cEmail := cEmail
    ::cName := cName
    ::cJob := cJob
    ::cAvatar := cAvatar
Return Self

Method Clear() Class ApiMethods
    ::nId := ''
    ::cEmail := ''
    ::cName := ''
    ::cJob := ''
    ::cAvatar := ''
    ::cCreatedAt := ''
    ::cUpdatedAt := ''
Return

Method toHTML() Class ApiMethods
    Local cHTML := ''
    cHTML += '<H1>Id: ' + cValToChar(::nId) + '</H1>'
    cHTML += '<H1>Name: ' + cValToChar(::cName) + '</H1>'
    cHTML += '<H1>Email: ' + cValToChar(::cEmail) + '</H1>'
    cHTML += '<H1>Job: ' + cValToChar(::cJob) + '</H1>'
    cHTML += '<H1>Avatar: ' + cValToChar(::cAvatar) + '</H1>'
    cHTML += '<H1>Created At: ' + cValToChar(::cCreatedAt) + '</H1>'
    cHTML += '<H1>Updated At: ' + cValToChar(::cUpdatedAt) + '</H1>'
Return cHTML

Method _Post() Class ApiMethods
    Local oBodyJson := JSonObject():New()
    Local oResJson := JSonObject():New()
    Local oRest := FWRest():New('https://reqres.in/api')
    Local aHeader := {}
    Local cError, cErr, nStatus

    // Set Endpoint
    oRest:setPath('/users')

    // Set to Body Json Values of the object
    oBodyJson['email']      := ::cEmail
    oBodyJson['name']       := ::cName
    oBodyJson['job']        := ::cJob
    oBodyJson['avatar']     := ::cAvatar

    // Pass Body Params
    oRest:SetPostParams(oBodyJson:toJson())
    // Let us Validate the http returns
    oRest:setChkStatus(.F.)

    // Try Post
    If oRest:Post(aHeader)
        cError := ''
        nStatus := HTTPGetStatus(@cError)
        If nStatus == 201
            cErr  := oResJson:fromJson(oRest:GetResult())
            If !empty(cErr)
                MsgStop(cErr, 'Json Parse Error')
                Return
            EndIf
            // Wow it's worked
            ::nId := Val(oResJson:GetJsonObject('id'))
            ::cCreatedAt := oResJson:GetJsonObject('createdAt')
            Return nStatus
        Else
            MsgStop("Can't create. Status: " + cValToChar(nStatus))
        EndIf
    Else
        MsgStop(oRest:getLastError() + CRLF + oRest:getResult())
    EndIf
Return

Method _Get() Class ApiMethods
    Local oResJson := JSonObject():New()
    Local oRest := FWRest():New('https://reqres.in/api')
    Local aHeader := {}
    Local cError, cErr, nStatus, cGetParams

    // Set Endpoint
    oRest:setPath('/users/'+cValToChar(::nId))
    If (!::nId)
        MsgStop("Id isn't in URI !!!")
        Return
    EndIf

    // Try Get
    If oRest:Get(aHeader, cGetParams)
        nStatus := HTTPGetStatus(@cError)

        cErr  := oResJson:fromJson(oRest:GetResult())
        If !empty(cErr)
            MsgStop(cErr, 'Json Parse Error')
            Return
        Endif
            /*Ret Sample
                {
                    "data":
                    {
                        "id":2,
                        "email":"janet.weaver@reqres.in",
                        "first_name":"Janet",
                        "last_name":"Weaver",
                        "avatar":"https://reqres.in/img/faces/2-image.jpg"},
                        "support":
                        {
                            "url":"https://reqres.in/#support-heading",
                            "text":"To keep ReqRes free, contributions towards server costs are appreciated!"
                        }
                    }
                }
            */
        ::cEmail    := oResJson['data']['email']
        ::cName     := (oResJson['data']['first_name'] + ' ' + oResJson['data']['last_name'])
        ::cAvatar   := oResJson['data']['avatar']
        Return nStatus
    Else
        MsgStop(oRest:getLastError() + CRLF + oRest:getResult())
    EndIf
Return

Method _Put() Class ApiMethods
    Local oResJson := JSonObject():New()
    Local oBodyJson := JSonObject():New()
    Local oRest := FWRest():New('https://reqres.in/api')
    Local aHeader := {}
    Local cError

    If (!::nId)
        MsgStop("Id isn't in URI !!!")
        Return
    EndIf

    // Set Endpoint
    oRest:setPath('/users/'+cValToChar(::nId))

    // Set to Body Json Values of the object
    oBodyJson['email'] := 'suehprom@xirtam.oc'
    oBodyJson['name'] := 'Morpheus'
    oBodyJson['job'] := 'Scientist'
    oBodyJson['avatar'] := 'http://placekitten.com/300/300'
    If oRest:Put(aHeader, oBodyJson:ToJson())
        nStatus := HTTPGetStatus(@cError)
        cErr  := oResJson:fromJson(oRest:GetResult())
        If !empty(cErr)
            MsgStop(cErr, 'Json Parse Error')
            Return
        Endif
        ::cEmail        := oBodyJson['email']   // Form some reason protheus aren't getting all fields
        ::cName         := oBodyJson['name']    // Form some reason protheus aren't getting all fields
        ::cAvatar       := oBodyJson['avatar']  // Form some reason protheus aren't getting all fields
        ::cJob          := oBodyJson['job']     // Form some reason protheus aren't getting all fields
        ::cUpdatedAt    := oResJson['updatedAt']
        Return nStatus
    Else
        MsgStop(oRest:getLastError() + CRLF + oRest:getResult())
    EndIf
Return

Method _Patch() Class ApiMethods
    Local oResJson := JSonObject():New()
    Local oBodyJson := JSonObject():New()
    Local aHeader := {}
    Local cError
    Local cHeaderRet, cResponse

    If (!::nId)
        MsgStop("Id isn't in URI !!!")
        Return
    EndIf
    //MessageBox(cResponse, 'Resposta', 64)

    // Set Endpoint
    //oRest:setPath('/users/'+cValToChar(::nId))

    // Set to Body Json Values of the object
    oBodyJson['email'] := 'suehprom@xirtam.oc'
    oBodyJson['name'] := 'Morpheus'
    oBodyJson['job'] := 'Scientist'
    oBodyJson['avatar'] := 'http://placekitten.com/300/300'

    //HTTPQuote(cURL, 'POST', queryParams, bodyParams, nTimeout, aHeadOut, @HeadRet)
    cResponse := HTTPQuote('https://reqres.in/api/users/'+cValToChar(::nId), 'PATCH', '', oBodyJson:toJson(), 120, {'Content-Type: application/json'}, @cHeaderRet)
    nStatus := HTTPGetStatus(@cError)
    If nStatus == 200
        cErr  := oResJson:fromJson(cResponse)
        If !empty(cErr)
            MsgStop(cErr, 'Json Parse Error')
            Return
        Endif
        ::cEmail        := oBodyJson['email']   // Form some reason protheus aren't getting all fields
        ::cName         := oBodyJson['name']    // Form some reason protheus aren't getting all fields
        ::cAvatar       := oBodyJson['avatar']  // Form some reason protheus aren't getting all fields
        ::cJob          := oBodyJson['job']     // Form some reason protheus aren't getting all fields
        ::cUpdatedAt    := oResJson['updatedAt']
        Return nStatus
    Else
        MsgStop(oRest:getLastError() + CRLF + oRest:getResult())
    EndIf
Return

Method _Delete() Class ApiMethods
    Local oResJson := JSonObject():New()
    Local oRest := FWRest():New('https://reqres.in/api')
    Local aHeader := {}
    Local cError, cErr, nStatus, cGetParams

    // Set Endpoint
    oRest:setPath('/users/'+cValToChar(::nId))
    If (!::nId)
        MsgStop("Id isn't in URI !!!")
        Return
    EndIf

    // Try Get
    If oRest:Get(aHeader, cGetParams)
        nStatus := HTTPGetStatus(@cError)

        cErr  := oResJson:fromJson(oRest:GetResult())
        If !empty(cErr)
            MsgStop(cErr, 'Json Parse Error')
            Return
        Endif
            /*Ret Sample
                {
                    "data":
                    {
                        "id":2,
                        "email":"janet.weaver@reqres.in",
                        "first_name":"Janet",
                        "last_name":"Weaver",
                        "avatar":"https://reqres.in/img/faces/2-image.jpg"},
                        "support":
                        {
                            "url":"https://reqres.in/#support-heading",
                            "text":"To keep ReqRes free, contributions towards server costs are appreciated!"
                        }
                    }
                }
            */
            ::clear()
        Return nStatus
    Else
        MsgStop(oRest:getLastError() + CRLF + oRest:getResult())
    EndIf
Return


User Function resTest()
    Local nLastStatus
    oApi := ApiMethods():New('xirtam@liamg.oc', 'Morpheus suehproM', 'Leader', 'https://placekitten.com/300/300')
    MessageBox(oApi:toHTML(), 'oApi := ApiMethods:New(<Values>)', 64)
    nLastStatus := oApi:_Post()
    MessageBox(oApi:toHTML(), ('POST - Status: ' + cValToChar(nLastStatus)), 64)
    oApi:Clear()
    oApi:nId := 2
    MessageBox('<H1 style="color:red">oApi:Clear() oApi->nId := 2</H1>' + oApi:toHTML(),'oApi:Clear()',64)
    nLastStatus := oApi:_Get()
    MessageBox(oApi:toHTML(), ('GET - Status: ' + cValToChar(nLastStatus)), 64)
    nLastStatus := oApi:_Put()
    MessageBox(oApi:toHTML(), ('PUT - Status: ' + cValToChar(nLastStatus)), 64)
    nLastStatus := oApi:_Patch()
    MessageBox(oApi:toHTML(), ('PATCH - Status: ' + cValToChar(nLastStatus)), 64)
    nLastStatus := oApi:_Delete()
    MessageBox(oApi:toHTML(), ('DELETE - Status: ' + cValToChar(nLastStatus)), 64)
Return
