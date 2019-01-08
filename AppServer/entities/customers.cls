 
 /*------------------------------------------------------------------------
    File        : customers
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

class entities.customers inherits BusinessEntity implements interfaces.CRUD:
    /*------------------------------------------------------------------------------
            Purpose:                                                                      
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    
    {"entities\inc\customers.i"}
  
    
    define data-source srcCustomer for sports2000.Customer.
    define variable iSeq as integer no-undo.
    define variable daO as data.DataAccess.
    
    
    /*------------------------------------------------------------------------------
            Purpose:                                                                      
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    constructor public customers():
        super (dataset dsCustomer:HANDLE).
    end constructor.
    
    method public void Read(input filter as FilterParams, output dataset-handle hDataSet):
        this-object:GetCustomers(filter, output dataset dsCustomer by-reference).
        hDataSet = dataset dsCustomer:handle.    
    end method.
    
    method public void Create(input jsonObject as JsonObject, output dataset-handle hDataSet):
        
        temp-table ttCustomer:tracking-changes = true.
        temp-table ttCustomer:write-json("file", "/usr/wrk/emeapas/work/ttcustomer.json").
        dataset dsCustomer:read-json('JsonObject', jsonObject).
        for each ttcustomer exclusive-lock:
            assign ttcustomer.custnum = current-value ( NextCustNum).
        end.
        temp-table ttCustomer:tracking-changes = false.
        this-object:Createcustomers(input-output dataset dsCustomer by-reference).
        hDataSet = dataset dsCustomer:handle.
    
    end method.
    
    method public void Update(input filter as FilterParams, input jsonObject as JsonObject, output dataset-handle hDataSet):
        
        dataset dsCustomer:read-json('JsonObject', jsonObject).
        this-object:Updatecustomers(filter, input-output dataset dsCustomer by-reference).
        hDataSet = dataset dsCustomer:handle.
    
    end method.
        
    /*------------------------------------------------------------------------------
            Purpose:  Get one or more records, based on a filter string                                                                     
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    method private void GetCustomers( input filter as FilterParams, output DATASET dsCustomer ):
        
        daO = new data.DataAccess().
        daO:attachSource("ttcustomer", "custnum", "Customer", "custnum", filter:id1, filter, input-output dataset dsCustomer by-reference).
        daO:dettachSource(dataset dsCustomer by-reference).    
            
    end method.
    
    {entities/inc/metadata.i &entity=customer}
    
      
    /*------------------------------------------------------------------------------
            Purpose: Create one or more new records                                                               
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    method public void Createcustomers( input-output DATASET dsCustomer):            
        

        dao = new data.DataAccess().
        dao:attachSource("ttcustomer", "CustNum", "Customer", "CustNum", "", ?, input-output dataset dsCustomer by-reference).
        dataset dsCustomer:write-json('file', '/usr/wrk/emeapas/work/dump.json').
        
        dao:CommitChanges(input-output dataset dsCustomer by-reference).
        //dataset dsCustomer:write-json('file', '/usr/wrk/emeapas/work/output.json').    
        
    end method.    
    
    /*------------------------------------------------------------------------------
            Purpose:  Update one or more records                                                                  
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    method public void Updatecustomers(input filter as FilterParams, input-output DATASET dsCustomer):            
    
        dao = new data.DataAccess().
        dao:attachSource("ttcustomer", "CustNum", "Customer", "CustNum", filter:id1, filter, input-output dataset dsCustomer by-reference).
        dao:CommitChanges(input-output dataset dsCustomer by-reference).
              
    end method.
    
    /*------------------------------------------------------------------------------
            Purpose:    Delete a record                                                               
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    method public void Deletecustomers(input-output DATASET dsCustomer):                    
    
        
    end method.
     
    
end class.
