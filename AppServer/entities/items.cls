 
 /*------------------------------------------------------------------------
    File        : items
    Syntax      : 
    Author(s)   : rdroge
    Created     : Thu Dec 13 10:02:58 CET 2018
    Notes       : 
  ----------------------------------------------------------------------*/


using Progress.Lang.*.
using OpenEdge.BusinessLogic.BusinessEntity.
using Progress.Json.ObjectModel.*.
using data.DataAccess.*.

block-level on error undo, throw.

class entities.items inherits BusinessEntity implements interfaces.CRUD:
    /*------------------------------------------------------------------------------
            Purpose:                                                                      
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    
    {"entities/inc/items.i"}
     
    define data-source srcItem for sports2020.Item.
    define variable iSeq as integer no-undo.
    define variable daO as data.DataAccess.
    define public property ttName as character no-undo initial "ttitem" get. set. 
    define public property piName as character no-undo initial "itemnum" get. set.
    define public property dbName as character no-undo initial "item" get. set.
    
    /*------------------------------------------------------------------------------
            Purpose:                                                                      
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    constructor public items():
        super (dataset dsitem:HANDLE).
    end constructor.
    
        method public void Read(input filter as generics.FilterParams, output dataset-handle hDataSet):
        this-object:Getitems(filter, output dataset dsitem by-reference).
        hDataSet = dataset dsitem:handle.    
    end method.
    
    method public void Create(input jsonObject as JsonObject, output dataset-handle hDataSet):
        dao = new data.DataAccess().
        dao:attachSource("ttitem", "itemnum", "item", "itemnum", "", ?, input-output dataset dsitem by-reference).
        dataset dsitem:get-buffer-handle (1):table-handle:tracking-changes = true.
        dataset dsitem:read-json('JsonObject', jsonObject).
        dataset dsitem:get-buffer-handle (1):table-handle:tracking-changes = false.
        
        dao:CommitChanges(piName, dataset dsitem by-reference).
        hDataSet = dataset dsitem:handle.
    
    end method.
    
    method public void Update(input filter as generics.FilterParams, input jsonObject as JsonObject, output dataset-handle hDataSet):
        define variable hChanges as handle.
        dao = new data.DataAccess().
        dao:attachSource("ttitem", "itemnum", "item", "itemnum", filter:id1, filter, input-output dataset dsitem by-reference).
        dataset dsitem:write-json('file', '/usr/wrk/emeapas/work/dsitem_before.json', true, ?, ?,?,true ).      
        create dataset hChanges.
        hChanges:create-like(dataset dsitem:handle).
        hChanges:read-json('JsonObject', jsonObject).
        
        hChanges:get-changes(dataset dsitem:handle).
        //hChanges:write-json('file', '/usr/wrk/emeapas/work/dsitem_before.json', true, ?, ?,?,true ).
        hChanges:merge-changes(dataset dsitem:handle).
        //dataset dsitem:get-buffer-handle (1):table-handle:tracking-changes = false.
        hChanges:write-json('file', '/usr/wrk/emeapas/work/dsitem_after.json', true, ?, ?,?,true ).
        //this-object:Updateitems(filter, input-output dataset dsitem by-reference).
        dao:CommitChanges(piName, input-output dataset dsitem by-reference).
        hDataSet = dataset dsitem:handle.
    
    end method.
    
    method public void Delete(input filter as generics.FilterParams, output dataset-handle hDataSet):
        
        dao = new data.DataAccess().
        dao:attachSource("ttitem", "itemnum", "item", "itemnum", filter:id1, filter, input-output dataset dsitem by-reference).
        this-object:Deleteitem(input-output dataset dsitem by-reference).
        hDataSet = dataset dsitem:handle.
        dao:dettachSource(dataset dsitem by-reference).
    
    end method.
        
    /*------------------------------------------------------------------------------
            Purpose:  Get one or more records, based on a filter string                                                                     
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    method private void Getitems( input filter as generics.FilterParams, output DATASET dsitem ):
        
        daO = new data.DataAccess().
        daO:attachSource(this-object:ttName, this-object:piName, this-object:dbName, this-object:piName, filter:id1, filter, input-output dataset dsitem by-reference).
        daO:dettachSource(dataset dsitem by-reference).    
            
    end method.
    
    {entities/inc/metadata.i &entity=item}
    
    /*------------------------------------------------------------------------------
            Purpose:  Update one or more records                                                                  
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    method public void Updateitems(input filter as generics.FilterParams, input-output DATASET dsitem):            
    
        dao = new data.DataAccess().
        dao:CommitChanges(piName, input-output dataset dsitem by-reference).
              
    end method.
    
    /*------------------------------------------------------------------------------
            Purpose:    Delete a record                                                               
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    method public void Deleteitem(input-output DATASET dsitem):                    
    
        
    end method.     
    
end class.
