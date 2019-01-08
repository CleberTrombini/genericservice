 
 /*------------------------------------------------------------------------
    File        : customerorders
    Syntax      : 
    Author(s)   : rdroge
    Created     : Wed Jan 02 10:08:45 CET 2019
    Notes       : 
  ----------------------------------------------------------------------*/


using Progress.Lang.*.
using OpenEdge.BusinessLogic.BusinessEntity.
using FilterParams.*.
using Progress.Json.ObjectModel.*.

block-level on error undo, throw.

class entities.customersorders inherits BusinessEntity implements interfaces.CRUD:
    /*------------------------------------------------------------------------------
            Purpose:                                                                      
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    
    {"entities\inc\custorders.i"}
    
    /* TODO Fill in appropriate datasource tables */ 
    define query qOrder for order.
    define data-source srcttCustomer for customer. 
    define data-source srcttOrder for query qOrder order keys (OrderNum).
    
    /*------------------------------------------------------------------------------
            Purpose:                                                                      
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    constructor public customersorders():
        
        define variable hDataSourceArray as handle no-undo extent 2.
        define variable cSkipListArray as character no-undo extent 2.
        
        super (dataset dsCustOrder:HANDLE).
        
        /* Data Source for each table in dataset. Should be in table order as defined 
            in DataSet */ 
         hDataSourceArray[1] = data-source srcttCustomer:HANDLE.
         hDataSourceArray[2] = data-source srcttOrder:HANDLE.
                  
         /* Skip-list entry for each table in dataset. Should be in temp-table order 
           as defined in DataSet */
        /* Each skip-list entry is a comma-separated list of field names, to be
            ignored in create stmt */
         
         /* TODO Update cSkipListArray if required by your BusinessEntity */
         cSkipListArray[1] = ?.
         cSkipListArray[2] = ?.
         
         this-object:ProDataSource = hDataSourceArray.
        this-object:SkipList = cSkipListArray.
                 
    end constructor.
    
    method public void Read(input filter as FilterParams, output dataset-handle hDataset):
        
        this-object:ReadCustomersOrders(filter, output dataset-handle hDataSet).
    
    end method.
        
    /*------------------------------------------------------------------------------
            Purpose:  Get one or more records, based on a filter string                                                                     
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    method public void ReadCustomersOrders(
            input filter as FilterParams, 
            output DATASET dsCustOrder):
                
            define variable iCustNum as integer no-undo.
            define variable cWhere as character no-undo.
            
            iCustNum = integer(filter:id1).
            cWhere = filter:where. 
            
            if cWhere > "" then
            do:
                query qOrder:query-prepare("FOR EACH Order WHERE order.custnum=" + string(iCustNum) + " AND " + cWhere).
            end.
            else
            do:
                query qOrder:query-prepare("FOR EACH Order WHERE order.custnum=" + string(iCustNum) ).
            end.    
            
            buffer ttCustomer:attach-data-source(data-source srcttCustomer:HANDLE ).
            buffer ttOrder:attach-data-source(data-source srcttOrder:HANDLE ).
            data-source srcttCustomer:fill-where-string = "WHERE custnum=" + string(iCustNum).                
            dataset dsCustOrder:fill().
              
    end method.
    
    {entities/inc/metadata.i &entity=customer}
    
end class.
