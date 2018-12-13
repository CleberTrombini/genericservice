 
/*------------------------------------------------------------------------
   File        : DemoHandler
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : egarcia
   Created     : Thu Oct 22 12:42:24 EDT 2015
   Notes       : 
 ----------------------------------------------------------------------*/

using Progress.Lang.*.
using OpenEdge.Web.WebHandler.
using OpenEdge.Web.WebResponse from propath.
using OpenEdge.Web.WebResponseWriter from propath.
using Progress.Json.ObjectModel.JsonObject from propath.
using OpenEdge.Net.HTTP.StatusCodeEnum from propath.


class DemoHandler inherits WebHandler: 

    define temp-table ttKlanten like BKLANTEN.
		
    method override protected integer HandleNotAllowedMethod( input poRequest as OpenEdge.Web.IWebRequest ):
		
        undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").
    end method.

    method override protected integer HandleNotImplemented( input poRequest as OpenEdge.Web.IWebRequest ):
		
        undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").
    end method.
 	
	
    /*------------------------------------------------------------------------------
            Purpose:                                                                
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    method override protected integer HandleGet( input poRequest as OpenEdge.Web.IWebRequest ):
 		
        define variable response   as OpenEdge.Web.WebResponse       no-undo.
        define variable writer     as OpenEdge.Web.WebResponseWriter no-undo.
        
        define variable jsonObject as JsonObject                     no-undo.
        
        response = new WebResponse().       
        writer = new WebResponseWriter(response).
        
        // writer:Write("Hello World!!!").
        
        for each BKLANTEN:
            create ttKlanten.
            buffer-copy BKLANTEN to ttKlanten.
        end.
        
        jsonObject = new JsonObject().
        jsonObject:READ(temp-table ttKlanten:handle).
        
        response:StatusCode = 200.
        response:ContentType = "application/json".  
       
        writer:Write(jsonObject:GetJsonText()).
        
        writer:Flush().
        writer:Close().

        return 0.
    end method. 
	
end class.