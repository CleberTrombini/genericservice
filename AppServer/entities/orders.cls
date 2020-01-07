 
 /*------------------------------------------------------------------------
    File        : orders
    Syntax      : 
    Author(s)   : rdroge
    Created     : Thu Dec 13 12:49:18 CET 2018
    Notes       : 
  ----------------------------------------------------------------------*/


using Progress.Lang.*.
using Progress.Json.ObjectModel.*.
using data.DataAccess.*.
using OpenEdge.BusinessLogic.*.


block-level on error undo, throw.

class entities.orders inherits BusinessEntity implements interfaces.CRUD:
    /*------------------------------------------------------------------------------
            Purpose:                                                                      
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    
    {"entities/inc/orders.i"}
  
    
    define data-source srcorder for sports2020.order.
    define variable iSeq as integer no-undo.
    define variable daO as data.DataAccess.
    define public property ttName as character no-undo initial "ttorder" get. set. 
    define public property piName as character no-undo initial "ordernum" get. set.
    define public property dbName as character no-undo initial "order" get. set.
    
    
    /*------------------------------------------------------------------------------
            Purpose:                                                                      
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    constructor public orders():
        super (dataset dsorder:HANDLE).
    end constructor.
    
    method public void Read(input filter as generics.FilterParams, output dataset-handle hDataSet):
        this-object:Getorders(filter, output dataset dsorder by-reference).
        hDataSet = dataset dsorder:handle.    
    end method.
    
    method public void Create(input jsonObject as JsonObject, output dataset-handle hDataSet):
        dao = new data.DataAccess().
        dao:attachSource("ttorder", "ordernum", "order", "ordernum", "", ?, input-output dataset dsorder by-reference).
        dataset dsorder:get-buffer-handle (1):table-handle:tracking-changes = true.
        dataset dsorder:read-json('JsonObject', jsonObject).
        dataset dsorder:get-buffer-handle (1):table-handle:tracking-changes = false.
        
        dao:CommitChanges(piName, dataset dsorder by-reference).
        hDataSet = dataset dsorder:handle.
    
    end method.
    
    method public void Update(input filter as generics.FilterParams, input jsonObject as JsonObject, output dataset-handle hDataSet):
        define variable hChanges as handle.
        dao = new data.DataAccess().
        dao:attachSource("ttorder", "ordernum", "order", "ordernum", filter:id1, filter, input-output dataset dsorder by-reference).
        dataset dsorder:write-json('file', '/usr/wrk/emeapas/work/dsorder_before.json', true, ?, ?,?,true ).      
        create dataset hChanges.
        hChanges:create-like(dataset dsorder:handle).
        hChanges:read-json('JsonObject', jsonObject).
        
        hChanges:get-changes(dataset dsorder:handle).
        //hChanges:write-json('file', '/usr/wrk/emeapas/work/dsorder_before.json', true, ?, ?,?,true ).
        hChanges:merge-changes(dataset dsorder:handle).
        //dataset dsorder:get-buffer-handle (1):table-handle:tracking-changes = false.
        hChanges:write-json('file', '/usr/wrk/emeapas/work/dsorder_after.json', true, ?, ?,?,true ).
        //this-object:Updateorders(filter, input-output dataset dsorder by-reference).
        dao:CommitChanges(piName, input-output dataset dsorder by-reference).
        hDataSet = dataset dsorder:handle.
    
    end method.
    
    method public void Delete(input filter as generics.FilterParams, output dataset-handle hDataSet):
        
        dao = new data.DataAccess().
        dao:attachSource("ttorder", "ordernum", "order", "ordernum", filter:id1, filter, input-output dataset dsorder by-reference).
        this-object:Deleteorder(input-output dataset dsorder by-reference).
        hDataSet = dataset dsorder:handle.
        dao:dettachSource(dataset dsorder by-reference).
    
    end method.
        
    /*------------------------------------------------------------------------------
            Purpose:  Get one or more records, based on a filter string                                                                     
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    method private void Getorders( input filter as generics.FilterParams, output DATASET dsorder ):
        
        daO = new data.DataAccess().
        daO:attachSource(this-object:ttName, this-object:piName, this-object:dbName, this-object:piName, filter:id1, filter, input-output dataset dsorder by-reference).
        daO:dettachSource(dataset dsorder by-reference).    
            
    end method.
    
    {entities/inc/metadata.i &entity=order}
    
    /*------------------------------------------------------------------------------
            Purpose:  Update one or more records                                                                  
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    method public void Updateorders(input filter as generics.FilterParams, input-output DATASET dsorder):            
    
        dao = new data.DataAccess().
        dao:attachSource("ttorder", "ordernum", "order", "ordernum", filter:id1, filter, input-output dataset dsorder by-reference).
        dao:CommitChanges(piName, input-output dataset dsorder by-reference).
              
    end method.
    
    /*------------------------------------------------------------------------------
            Purpose:    Delete a record                                                               
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    method public void Deleteorder(input-output DATASET dsorder):                    
    
        
    end method.
      
    
end class.
