 
 /*------------------------------------------------------------------------
    File        : customers
    Syntax      : 
    Author(s)   : rdroge
    Created     : Thu Dec 13 12:49:18 CET 2018
    Notes       : 
  ----------------------------------------------------------------------*/


using Progress.Lang.*.
using OpenEdge.BusinessLogic.BusinessEntity.
using restapi.orders.
using Progress.Json.ObjectModel.*.


block-level on error undo, throw.

class restapi.customers inherits BusinessEntity implements IBusinessEntity:
    /*------------------------------------------------------------------------------
            Purpose:                                                                      
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    
    {"restapi\inc\customers.i"}
  
    
    define data-source srcCustomer for sports2000.Customer.
    define variable iSeq as integer no-undo.
    
    
    /*------------------------------------------------------------------------------
            Purpose:                                                                      
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    constructor public customers():
        
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
    
        if (filter:id1 > "" and filter:id2 = "") then 
        do:
            this-object:GetSinglecustomer(filter, output dataset-handle hDataset).
        end.
        else if filter:filtered=true then 
        do:
            this-object:GetFilteredCustomers(filter, output dataset-handle hDataSet).
        end.
        else do:
            this-object:GetAllCustomers(output dataset-handle hDataSet).
        end.
        
    end method.
        
    /*------------------------------------------------------------------------------
            Purpose:  Get one or more records, based on a filter string                                                                     
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    method private void GetSingleCustomer( input filter as FilterParams, output DATASET dsCustomer ):
        empty temp-table ttCustomer no-error.       
        find Customer 
            where Customer.Custnum = integer(filter:id1).
            create ttCustomer.
            buffer-copy Customer to ttCustomer.
    end method.
    
    method private void GetFilteredCustomers( input filter as FilterParams, output DATASET dsCustomer ):
                
        empty temp-table ttCustomer no-error.       
        this-object:JFPFillMethod(filter).
       
    end method.
    
    method private void GetAllCustomers( output dataset dsCustomer ):
    
            super:ReadData().
    
    end method.
    {restapi/inc/filter_support.i &entity=customer}
    
      
    /*------------------------------------------------------------------------------
            Purpose: Create one or more new records                                                               
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    method public void Createcustomers(input-output DATASET dsCustomer):            
               
        super:CreateData(DATASET dsCustomer by-reference).        
    end method.    
    
    /*------------------------------------------------------------------------------
            Purpose:  Update one or more records                                                                  
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    method public void Updatecustomers(input-output DATASET dsCustomer):            
    
        super:UpdateData(DATASET dsCustomer by-reference).          
    end method.
    
    /*------------------------------------------------------------------------------
            Purpose:    Delete a record                                                               
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    method public void Deletecustomers(input-output DATASET dsCustomer):                    
    
        super:DeleteData(DATASET dsCustomer by-reference).
    end method.
     
    
end class.
