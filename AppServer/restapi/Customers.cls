 
 /*------------------------------------------------------------------------
    File        : Customers
    Syntax      : 
    Author(s)   : rdroge
    Created     : Thu Dec 13 12:49:18 CET 2018
    Notes       : 
  ----------------------------------------------------------------------*/


using Progress.Lang.*.
using OpenEdge.BusinessLogic.BusinessEntity.

block-level on error undo, throw.

class restapi.Customers inherits BusinessEntity implements IBusinessEntity:
    /*------------------------------------------------------------------------------
            Purpose:                                                                      
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    
    {"restapi\customers.i"}
    
    define data-source srcCustomer for sports2000.Customer.
    define variable iSeq as integer no-undo.
    
    
    /*------------------------------------------------------------------------------
            Purpose:                                                                      
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    constructor public Customers():
        
        define variable hDataSourceArray as handle no-undo extent 1.
        define variable cSkipListArray as character no-undo extent 1.
        
        super (dataset dsCustomer:HANDLE).
        
        /* Data Source for each table in dataset. Should be in table order as defined 
            in DataSet */     
         hDataSourceArray[1] =  data-source srcCustomer:HANDLE.
         
                  
         /* Skip-list entry for each table in dataset. Should be in temp-table order 
           as defined in DataSet */
        /* Each skip-list entry is a comma-separated list of field names, to be
            ignored in create stmt */
             
         cSkipListArray[1] = "".
         
         
         this-object:ProDataSource = hDataSourceArray.
        this-object:SkipList = cSkipListArray.
                 
    end constructor.
    
    method public void Read(input filter as FilterParams, output dataset-handle hDataset):
    
       
    end method.
        
    /*------------------------------------------------------------------------------
            Purpose:  Get one or more records, based on a filter string                                                                     
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    method public void ReadCustomers(
            input filter as character, 
            output DATASET dsCustomer):
        
        super:ReadData(filter).
              
    end method.
    
    {restapi/inc/filter_support.i &entity=customer}
      
    /*------------------------------------------------------------------------------
            Purpose: Create one or more new records                                                               
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    method public void CreateCustomers(input-output DATASET dsCustomer):            
               
        super:CreateData(DATASET dsCustomer by-reference).        
    end method.    
    
    /*------------------------------------------------------------------------------
            Purpose:  Update one or more records                                                                  
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    method public void UpdateCustomers(input-output DATASET dsCustomer):            
    
        super:UpdateData(DATASET dsCustomer by-reference).          
    end method.
    
    /*------------------------------------------------------------------------------
            Purpose:    Delete a record                                                               
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    method public void DeleteCustomers(input-output DATASET dsCustomer):                    
    
        super:DeleteData(DATASET dsCustomer by-reference).
    end method.
     
    
end class.
