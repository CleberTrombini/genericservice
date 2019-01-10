 
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

block-level on error undo, throw.

class entities.items inherits BusinessEntity:
    /*------------------------------------------------------------------------------
            Purpose:                                                                      
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    
    {"entities\inc\items.i"}
     
    define data-source srcItem for sports2000.Item.
    define variable iSeq as integer no-undo.
    
    /*------------------------------------------------------------------------------
            Purpose:                                                                      
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    constructor public items():
        
        define variable hDataSourceArray as handle no-undo extent 1.
        define variable cSkipListArray as character no-undo extent 1.
        
        super (dataset dsItem:HANDLE).
        
        /* Data Source for each table in dataset. Should be in table order as defined 
            in DataSet */     
         hDataSourceArray[1] =  data-source srcItem:HANDLE.
         
                  
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
            this-object:GetSingleItem(filter, output dataset-handle hDataset).
        end.
        else if filter:filtered=true then 
        do:
            this-object:GetFiltereditems(filter, output dataset-handle hDataSet).
        end.
        else do:
            this-object:GetAllitems(output dataset-handle hDataSet).
        end.
    end method.
        
    /*------------------------------------------------------------------------------
            Purpose:  Get one or more records, based on a filter string                                                                     
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    method private void GetSingleItem( input filter as FilterParams, output DATASET dsItem ):
        
        empty temp-table ttItem no-error.       
        find Item 
            where Item.Itemnum = integer(filter:id1).
            create ttItem.
            buffer-copy Item to ttItem.
    end method.
    
    method private void GetFiltereditems( input filter as FilterParams, output DATASET dsItem ):
                
        empty temp-table ttItem no-error.       
        
    end method.
    
    method private void GetAllitems( output dataset dsItem ):
    
            super:ReadData().
    
    end method.
    {entities\inc\metadata.i &entity=Item}
      
    /*------------------------------------------------------------------------------
            Purpose: Create one or more new records                                                               
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    method public void Createitems(input-output DATASET dsItem):            
               
        super:CreateData(DATASET dsItem by-reference).
                
    end method.    
    
    /*------------------------------------------------------------------------------
            Purpose:  Update one or more records                                                                  
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    method public void Updateitems(input-output DATASET dsItem):            
    
        super:UpdateData(DATASET dsItem by-reference).      
            
    end method.
    
    /*------------------------------------------------------------------------------
            Purpose:    Delete a record                                                               
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    method public void Deleteitems(input-output DATASET dsItem):                    
    
        super:DeleteData(DATASET dsItem by-reference).
        
    end method.
     
    
end class.
