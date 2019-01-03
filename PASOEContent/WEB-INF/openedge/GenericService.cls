/*------------------------------------------------------------------------
   File        : GenericService
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : ruben
   Created     : Mon Aug 31 11:21:00 EST 2015
   Notes       : 
 ----------------------------------------------------------------------*/

using Progress.Json.ObjectModel.*.
using FilterParams.*.
using Progress.Lang.*.
using OpenEdge.Net.*.
using OpenEdge.Net.HTTP.*.
using OpenEdge.Web.*.


block-level on error undo, throw.

class GenericService inherits WebHandler: 

    method override protected integer HandleGet(input poRequest as OpenEdge.Web.IWebRequest):
        define variable response    as WebResponse       no-undo.
        define variable writer      as WebResponseWriter no-undo.
        define variable body        as longchar          no-undo.
        
        define variable entityName  as character         no-undo.
        define variable entityName2 as character         no-undo.
        define variable id1         as character         no-undo.
        define variable id2         as character         no-undo.
        define variable queryString as character         no-undo.        
        define variable oFieldlist  as character         no-undo.
        define variable lcModel     as longchar          no-undo.   
        define variable apiType     as character         no-undo.   
        
        define variable filter      as FilterParams      no-undo.
        define variable lOk         as logical           no-undo initial true.   
        
        define variable entity      as GenericEntity     no-undo.
        define variable dynClass    as IBusinessEntity   no-undo.
        define variable dynClass2   as IBusinessEntity   no-undo.
        
        define variable hDataSet    as handle            no-undo.
        define variable hTempTable  as handle            no-undo.
        define variable hCP         as handle            no-undo.
       
        define variable jsonObject  as JsonObject        no-undo.       
        define variable jsonArray   as JsonArray         no-undo.
        
        response = new WebResponse().        
        writer = new WebResponseWriter(response).
        entityName  = poRequest:GetPathParameter("entityname").
        entityName2 = poRequest:GetPathParameter("entityname2").
        id1         = poRequest:GetPathParameter("id1").
        id2         = poRequest:GetPathParameter("id2").
        apiType     = poRequest:GetPathParameter("apitype").
        
        
        queryString = poRequest:GetContextValue("QUERY_STRING").
        if apiType = "data" then
        do:
        
            filter = new FilterParams().
            
            if id1 > "" then
                filter:id1 = id1.
            if id2 > "" then
                filter:id2 = id2.
            if entityName2 > "" then
                filter:entityName2 = entityname2.  
            if queryString > "" then 
            do:
                filter:filtered = true.
                define variable cParam as character no-undo.
                define variable i      as integer   no-undo.
                define variable cName  as character no-undo.
                define variable cWhere as character no-undo.
                define variable cValue as character no-undo.
                define variable idx    as integer   no-undo.
                
                do i = 1 to num-entries(queryString, "&"):
                    cParam = entry(i, queryString, "&").
                    idx = index(cParam, "=").
                    if idx > 0 then 
                    do:
                        cName = substring(cParam, 1, idx - 1).
                        cValue = OpenEdge.Net.URI:Decode(substring(cParam, idx + 1)).
                        case cName:
                            when "sort_by" then 
                                filter:SortBy = entry(2,cParam,"=").
                            when "limit" then
                                filter:TopRecs = integer(entry(2,cParam,"=")).
                            when "offset" then
                                filter:SkipRecs = integer(entry(2,cParam,"=")).
                            otherwise do:
                                filter:FieldList = left-trim(filter:FieldList + "," + cName, ",").
                            
                            if cWhere > "" then 
                                cWhere = cWhere + " AND " + cName + "=" + QUOTER(OpenEdge.Net.URI:Decode(cValue)).
                            else 
                                cWhere = cName + "=" + QUOTER(OpenEdge.Net.URI:Decode(cValue)).
                            end.    
                        end case.        
                        filter:where = cWhere.
                    end.
                end.
            end.
            entity = new GenericEntity("restapi." + entityName).
            dynClass = dynamic-new string("restapi." + entityName) () no-error.
            if entityName2 > "" then
                dynClass2 = dynamic-new string("restapi." + entityName + entityName2) () no-error .                
        
            if dynClass = ? or ( entityName2 > "" and dynClass2 = ?) then 
            do:
                lOk = false.
                response:StatusCode = 400.
                jsonObject = new JsonObject().
                jsonObject:Add("Error", "Following entities or combination of these entities do not exist for this api").
                jsonObject:Add("Entity", right-trim(left-trim(entityName + "," + entityName2, ","), ",")).
                
                body = jsonObject:GetJsonText().
            end.
            else if filter:where > "" then
            do:
                if dynClass2 <> ? then 
                do:
                    dynClass2:CheckFieldList(filter:FieldList, output oFieldList, output lOk).
                    if not lOk then 
                    do:
                        response:StatusCode = 400.
                        jsonObject = new JsonObject().
                        jsonObject:Add("Error", "Following field(s) in query do not exist for this entity").
                        jsonObject:Add("Fields", oFieldList).
                        body = jsonObject:GetJsonText().
                    end.
                end.
                else 
                do:
                    dynClass:CheckFieldList(filter:FieldList, output oFieldList, output lOk).
                    if not lOk then
                    do:
                        response:StatusCode = 400.
                        jsonObject = new JsonObject().
                        jsonObject:Add("Error", "Following field(s) in query do not exist for this entity").
                        jsonObject:Add("Fields", oFieldList).
                        body = jsonObject:GetJsonText().
                    end.    
                end.
            end.
            
            message lOk.
            
            if lOk and dynClass2 <> ? then
            do:
                response:StatusCode = 200.
                define variable ii as integer no-undo.
                dynClass2:Read(filter, output dataset-handle hDataSet).
               
                hTempTable = hDataSet:get-buffer-handle(1):table-handle.
                jsonObject = new JsonObject().
                jsonObject:Read(hTempTable).
                
                do ii=2 to hDataSet:num-buffers:
                    hTempTable = hDataSet:get-buffer-handle(ii):table-handle.
                    message hTempTAble:name.
                    jsonArray = new JsonArray().
                    jsonArray:READ(hTempTable).
                    jsonObject:Add(entityName2, jsonArray ).
                                           
                end.
                body = jsonObject:GetJsonText(). 
            end.
            else if lOk then
            do:
                response:StatusCode = 200.
                dynClass:Read(filter, output DATASET-HANDLE hDataSet).
                hTempTable = hDataSet:get-buffer-handle(1):table-handle.
                jsonObject = new JsonObject().
                jsonObject:Read(hTempTable).
                body = jsonObject:GetJsonText().
            end.
        end.
        else if apiType = "meta" then
        do:
            
            dynClass = dynamic-new string("restapi." + entityName) () no-error.
            dynClass:CreateEntityModel(output lcModel).
            body = lcModel.
        end.    
                
        response:ContentType = "application/json".
        writer:write(body).
        writer:flush().
        writer:close().            
    end method.
    
    method override protected integer HandleNotAllowedMethod( input poRequest as OpenEdge.Web.IWebRequest ):
        
        undo, throw new Progress.Lang.AppError("This method is not allowed").
    end method.

    method override protected integer HandleNotImplemented( input poRequest as OpenEdge.Web.IWebRequest ):
        
        undo, throw new Progress.Lang.AppError("This method is not implemented").
    end method.
    
        
    
         
    
end class.