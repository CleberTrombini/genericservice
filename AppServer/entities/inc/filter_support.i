
/*------------------------------------------------------------------------
    File        : filter_support.i
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : Ruben Dröge
    Created     : Wed Jul 08 13:08:19 CEST 2015
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Main Block  *************************** */
 method private void JFPFillMethod(input filter as FilterParams):
        define variable cWhere         as character         no-undo.
        define variable hQuery         as handle            no-undo. 
        define variable lUseReposition as logical           no-undo.
        define variable iCount         as integer           no-undo.
        define variable ablFilter      as character         no-undo.
        define variable iMaxRows       as integer           initial ? no-undo.
        define variable iSkipRows      as integer           initial ? no-undo.
        define variable cOrderBy       as character         initial "" no-undo.
        define variable id             as character         initial ? no-undo.
        def var ii as integer no-undo.
        def var cfieldname as character no-undo.
        def var cfieldlist as character no-undo.
        
        
        /* purge any existing data */
        empty temp-table tt{&entity}.
        iMaxRows = filter:TopRecs no-error.
        iSkipRows = filter:SkipRecs no-error.
        ablFilter = filter:Where no-error.
        
        
        //id = jsonObject:GetCharacter("id") no-error.
        cOrderBy = filter:SortBy no-error.
        cWhere = "WHERE " + ablFilter no-error.
        if cOrderBy > "" then 
        do:
            cOrderBy = replace(cOrderBy, ",", " by ").
            cOrderBy = "by " + cOrderBy + " ".
            /* NOTE: id and seq fields should be removed from
            cWhere and cOrderBy */
            cOrderBy = replace(cOrderBy, "by id desc", "").
            cOrderBy = replace(cOrderBy, "by id ", "").
            cOrderBy = replace(cOrderBy, "by seq desc", "").
            cOrderBy = replace(cOrderBy, "by seq ", "").
        end.
        
        message iSkipRows.
        lUseReposition = iSkipRows > 0.
        
        message "reposition" lUseReposition.
        
        if iMaxRows <> ? and iMaxRows > 0 then 
        do:
            buffer tt{&entity}:handle:BATCH-SIZE = iMaxRows.
        end.
        else 
        do:
            if id > "" then
                buffer tt{&entity}:handle:BATCH-SIZE = 1.
            else
                buffer tt{&entity}:handle:BATCH-SIZE = 0.
        end.
        
        buffer tt{&entity}:attach-data-source(data-source src{&entity}:HANDLE).
        
        if cOrderBy = ? then cOrderBy = "".
        
        cWhere = if cWhere > "" then (cWhere + " " + cOrderBy)
                  else (cOrderBy).
        
        data-source src{&entity}:FILL-WHERE-STRING = cWhere.
        
        message "cWhere" cWhere.
        
        if lUseReposition then 
        do:
            
        hQuery = data-source src{&entity}:QUERY.
            hQuery:query-open.
            if id > "" and id <> "?" then 
            do:
                hQuery:reposition-to-rowid(to-rowid(id)).
            end.
             else if iSkipRows <> ? and iSkipRows > 0 then 
                do:
                    hQuery:reposition-to-row(iSkipRows).
                    if not available {&entity} then
                        hQuery:get-next() no-error.
                end.
            iCount = 0.
            repeat while not hQuery:query-off-end and (iMaxRows = ? or iCount < iMaxRows):
                hQuery:get-next () no-error.
                if available {&entity} then 
                do:
                    
                    create tt{&entity}.
                    buffer-copy {&entity} to tt{&entity}.
                    assign 

                        tt{&entity}.id = string(rowid({&entity}))
                        iSeq              = iSeq + 1
                        tt{&entity}.seq   = iSeq
                        .
                        
                end.
                iCount = iCount + 1.
            end.
        end.
        else 
        do:
            if id > "" then data-source src{&entity}:RESTART-ROWID(1)
                = to-rowid ((id)).
            buffer tt{&entity}:set-callback ("AFTER-ROW-FILL", "AddIdField").
            dataset ds{&entity}:fill().
        end.
        finally:
            buffer tt{&entity}:detach-data-source().
        end finally.
            
     end method.

    method public void AddIdField (input DATASET ds{&entity}):
        def var iii as integer no-undo.
        def var cfieldname as character no-undo.
        def var cfieldlist as character no-undo.
        assign 
            tt{&entity}.id = string(rowid({&entity}))
            iSeq              = iSeq + 1
            tt{&entity}.seq   = iSeq.
            
    end.
    
    method public void count( input filter as FilterParams, output numRecs as integer):
        define variable ablFilter  as character         no-undo.
        define variable cWhere     as character         no-undo.
        define variable qh         as handle            no-undo.
        
        ablFilter = filter:Where no-error.
            
        cWhere = "WHERE " + ablFilter.
    
        create query qh.
        qh:set-buffers(buffer {&entity}:HANDLE).
        qh:query-prepare("PRESELECT EACH {&entity} " + cWhere).
        qh:query-open ().
        numRecs = qh:num-results.
    end method.
    
 
            
    
    
    
