/** 
**/
/*------------------------------------------------------------------------
    File        : FilterParams
    Author(s)   : rdroge
    Notes       : Input parameters for filtering 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using FilterParams.*.

class FilterParams:
    define public property entityName   as character    no-undo get. set.
    define public property entityName2  as character    no-undo get. set.
    define public property TopRecs      as integer      initial 0 no-undo get. set.
    define public property SkipRecs     as integer      initial 0 no-undo get. set.
    define public property Where        as character    no-undo get. set.
    define public property SortBy       as character    no-undo get. set.
    define public property FieldList    as character    no-undo get. set.
    define public property id1          as character    no-undo get. set.
    define public property id2          as character    no-undo get. set.
    define public property rowid        as character    no-undo get. set.
    define public property filtered     as logical      initial false no-undo get. set.

    method override public character ToString():
        return substitute('where &1 by &2 field-list &3 [top:&4 skip:&5]',
                    this-object:Where, SortBy, FieldList, TopRecs, SkipRecs).
    end method.    
    
    method static public character BuildQueryString(input pFilter as FilterParams, input dataset-handle pDataset):
        define variable queryString as character no-undo.
        define variable buffer as handle no-undo.
        
        //find table by name from TableName
        //find table by serialize-name from TableName
        
        // for fields in WHERE
            //find by name 
            //find by serialize-name
        
        return queryString.
    end method.
    
    
end class.