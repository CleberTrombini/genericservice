 
 /*------------------------------------------------------------------------
    File        : orders
    Syntax      : 
    Author(s)   : rdroge
    Created     : Fri Dec 14 13:52:13 CET 2018
    Notes       : 
  ----------------------------------------------------------------------*/


using Progress.Lang.*.
using OpenEdge.BusinessLogic.BusinessEntity.

block-level on error undo, throw.

class restapi.orders inherits BusinessEntity:
    /*------------------------------------------------------------------------------
            Purpose:                                                                      
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    
    {"restapi\inc\orders.i"}
    
    define data-source srcOrder for sports2000.Order.
    
    
    /*------------------------------------------------------------------------------
            Purpose:                                                                      
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    constructor public orders():
        
        define variable hDataSourceArray as handle no-undo extent 1.
        define variable cSkipListArray as character no-undo extent 1.
        
        super (dataset dsOrder:HANDLE).
        
        /* Data Source for each table in dataset. Should be in table order as defined 
            in DataSet */     
         hDataSourceArray[1] =  data-source srcOrder:HANDLE.
         
                  
         /* Skip-list entry for each table in dataset. Should be in temp-table order 
           as defined in DataSet */
        /* Each skip-list entry is a comma-separated list of field names, to be
            ignored in create stmt */
             
         cSkipListArray[1] = "".
         
         
         this-object:ProDataSource = hDataSourceArray.
        this-object:SkipList = cSkipListArray.
                 
    end constructor.
        
    /*------------------------------------------------------------------------------
            Purpose:  Get one or more records, based on a filter string                                                                     
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    method public void Readorders(
            input filter as character, 
            output DATASET dsOrder):
        
        super:ReadData(filter).
              
    end method.
      
    /*------------------------------------------------------------------------------
            Purpose: Create one or more new records                                                               
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    method public void Createorders(input-output DATASET dsOrder):            
               
        super:CreateData(DATASET dsOrder by-reference).        
    end method.    
    
    /*------------------------------------------------------------------------------
            Purpose:  Update one or more records                                                                  
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    method public void Updateorders(input-output DATASET dsOrder):            
    
        super:UpdateData(DATASET dsOrder by-reference).          
    end method.
    
    /*------------------------------------------------------------------------------
            Purpose:    Delete a record                                                               
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    method public void Deleteorders(input-output DATASET dsOrder):                    
    
        super:DeleteData(DATASET dsOrder by-reference).
    end method.
     
    
end class.
