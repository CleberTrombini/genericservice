 
 /*------------------------------------------------------------------------
    File        : DataAccess
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : rdroge
    Created     : Fri Jan 04 10:52:21 CET 2019
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using FilterParams.*.

block-level on error undo, throw.

class data.DataAccess: 

   
    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/
        
    constructor public DataAccess (  ):
        super ().
        
    end constructor.
    
    method public void attachSource (   input pcBuffers as character, 
                                        input pcFields as character,
                                        input pcSources as character,
                                        input pcSourceKeys as character,
                                        input pcKeyValue as character,
                                        input pFilter as FilterParams,    
                                        input-output dataset-handle phDataSet ):
                                            
        define variable iEntry          as integer   no-undo.
        define variable hDataSource     as handle    no-undo.
        define variable hBuffer         as handle    no-undo.
        define variable hQuery          as handle    no-undo.
        define variable pcSource        as character no-undo.
        define variable pcBuffer        as character no-undo.
        define variable cWhere          as character no-undo.
        define variable qh              as handle    no-undo.
        define variable numRecs         as integer   no-undo.   
        define variable iSeq            as integer   no-undo.
    
        define variable h_buff          as handle    no-undo.
        define variable cQuery          as character no-undo.
        define variable lUseReposition  as logical           no-undo.
        define variable iCount          as integer           no-undo.
        define variable ablFilter       as character         no-undo.
        define variable iMaxRows        as integer           initial ? no-undo.
        define variable iSkipRows       as integer           initial ? no-undo.
        define variable cOrderBy        as character         initial "" no-undo.
        define variable id              as character         initial ? no-undo.
        
        iMaxRows    = pFilter:TopRecs   no-error.
        iSkipRows   = pFilter:SkipRecs  no-error.
        cWhere      = pFilter:Where     no-error.
        id          = pFilter:rowid.
        
        if pFilter = ? then 
            pcKeyValue = "1".
        else
            pcKeyValue = pFilter:id1.
            
        cOrderBy = pFilter:SortBy no-error.
        cWhere = " WHERE " + cWhere no-error.
        if cOrderBy > "" then 
        do:
            cOrderBy = replace(cOrderBy, ",", " by ").
            cOrderBy = "by " + cOrderBy + " ".
            cOrderBy = replace(cOrderBy, "by id desc", "").
            cOrderBy = replace(cOrderBy, "by id ", "").
            cOrderBy = replace(cOrderBy, "by seq desc", "").
            cOrderBy = replace(cOrderBy, "by seq ", "").
        end.
        
        lUseReposition = iSkipRows > 0.
        
        do iEntry = 1 to num-entries(pcSources):
            
            create data-source hDataSource.
            create buffer hBuffer for table entry(iEntry, pcSources).
            hDataSource:add-source-buffer(hBuffer, entry(iEntry,pcSourceKeys)).
            phDataSet:get-buffer-handle(iEntry):ATTACH-DATA-SOURCE(hDataSource).
           
            
            pcSource = entry(1, pcSources).
            pcBuffer = entry(1, pcBuffers).
            message iEntry pcKeyValue.
            
            if (iEntry = 1 and pcKeyValue = "") then 
            do:
                
                if iMaxRows <> ? and iMaxRows > 0 then 
                do:
                    create query qh.
                    qh:set-buffers(hBuffer).
                    qh:query-prepare("PRESELECT EACH " + pcSource  + cWhere).
                    qh:query-open ().
                    numRecs = qh:num-results.
                    phDataSet:get-buffer-handle(1):BATCH-SIZE = iMaxRows.
                    message phDataSet:get-buffer-handle(1):batch-size.
                end.
                else 
                do:
                    if id > "" then
                        phDataSet:get-buffer-handle(iEntry):BATCH-SIZE = 1.
                    else
                        message "ja?".
                        phDataSet:get-buffer-handle(iEntry):BATCH-SIZE = 0.
                end.
                
                if cOrderBy = ? then cOrderBy = "".
            
                cWhere =    if cWhere > "" then 
                                (cWhere + " " + cOrderBy)
                            else 
                                (cOrderBy).
            
                hDataSource:fill-where-string = cWhere.
                
                message "fill where" hDataSource:fill-where-string.
                
                if lUseReposition then 
                do:
                    hQuery = hDataSource:query.
                    
                    hQuery:query-open.
                    
                    if id > "" and id <> "?" then 
                    do:
                        hQuery:reposition-to-rowid(to-rowid(id)).
                    end.
                    else if iSkipRows <> ? and iSkipRows > 0 then 
                        do:
                            message iSkipRows.
                            hQuery:reposition-to-row(iSkipRows) no-error.
                            if not hbuffer:available then
                            hQuery:get-next() no-error.
                        end.
                    iCount = 0.
                    repeat while not hQuery:query-off-end and (iMaxRows = ? or iCount < iMaxRows):
                        hQuery:get-next () no-error.
                        if hBuffer:available then do:
                        
                            phDataSet:get-buffer-handle(1):buffer-create.
                            phDataSet:get-buffer-handle(1):buffer-copy (hBuffer).
                            phDataSet:get-buffer-handle(1):buffer-field("id"):buffer-value() = string(hBuffer:rowid).
                            iSeq = iSeq + 1.
                            phDataSet:get-buffer-handle(1):buffer-field("seq"):buffer-value() = string(iSeq).
                        
                        end.
                                    
                        iCount = iCount + 1.
                    end.
                    phDataSet:write-json('file', '/usr/wrk/emeapas/work/phDataSet.json').
                end.
                else 
                do:
                    if id > "" then hDataSource:restart-rowid(1)
                        = to-rowid ((id)).
                    phDataSet:get-buffer-handle(iEntry):set-callback ("AFTER-ROW-FILL", "AddIdField").
                    phDataSet:fill().
                end.
            end. /* DO IF iEntry = 1 */
            else do:
                create query hQuery.
                hQuery:add-buffer(hBuffer).
                hQuery:query-prepare("FOR EACH " + ENTRY(1, pcSources) +
                    " WHERE " + ENTRY(1, pcSourceKeys) + " = " + pcKeyValue).
                hDataSource:query = hQuery.
                hQuery:query-open.
                hQuery:get-next () no-error.
                phDataSet:get-buffer-handle(1):buffer-create.
                phDataSet:get-buffer-handle(1):buffer-copy (hBuffer).
                phDataSet:get-buffer-handle(1):buffer-field("id"):buffer-value() = string(hBuffer:rowid).
                iSeq = iSeq + 1.
                phDataSet:get-buffer-handle(1):buffer-field("seq"):buffer-value() = string(iSeq).
            end. 
            
        end. /* DO iEntry = 1 TO NUM-ENTRIES */

        
    end method.

    method public void AddIdField (input DATASET-handle phDataSet):
            define variable iSeq as integer no-undo.
            message string(phDataSet:get-buffer-handle(1):rowid).
            phDataSet:get-buffer-handle(1):buffer-field("id"):buffer-value() = string(phDataSet:get-buffer-handle(1):rowid).
            iSeq              = iSeq + 1.
            phDataSet:get-buffer-handle(1):buffer-field("seq"):buffer-value() = string(iSeq).
            
    end method.
    
    method public void fetchAll (input-output dataset-handle phDataSet):
        phDataSet:FILL().
        
    end method.

    method public void dettachSource (input dataset-handle phDataSet):
    
        define variable iBuff as integer no-undo.
  
        do iBuff = 1 to phDataSet:NUM-BUFFERS:
            phDataSet:GET-BUFFER-HANDLE(iBuff):DETACH-DATA-SOURCE().
        end.
    end method.
    
    
    method public void CommitChanges (input-output dataset-handle hDataSet):
    
        define variable hTopBuff    as handle  no-undo.
        define variable iBuff       as integer no-undo.
        
       
        do iBuff = 1 to hDataSet:NUM-TOP-BUFFERS:
            hTopBuff = hDataSet:GET-TOP-BUFFER(iBuff).
            
            /* Skip the reposition children. */
            if hTopBuff:parent-relation ne ? then next. 
            this-object:traverseBuffers(hTopBuff, dataset-handle hDataSet).
        end. /* END DO iBuff */
    
    end method.
    
    method private void traverseBuffers (input phBuffer as handle, input-output dataset-handle hDataSet):
            define variable iChildRel as integer no-undo.
        
            this-object:saveBuffer(phBuffer, dataset-handle hDataSet).
            do iChildRel = 1 to phBuffer:num-child-relations:
                this-object:traverseBuffers(phBuffer:get-child-relation(iChildRel):CHILD-BUFFER, dataset-handle hDataSet).
            end. /* END DO iChildRel */
    end method.
    
    method private void saveBuffer (input phBuffer as handle, input-output dataset-handle hDataSet):
        
        define variable hBeforeBuff as handle    no-undo.
        define variable hBeforeQry  as handle    no-undo.
        define variable cLogicProc  as character no-undo.
       
       
        hBeforeBuff = phBuffer:before-buffer.
        if valid-handle(hBeforeBuff) then 
        do:

    /*        Create a query on the before buffer BIttCust, then read through the change records*/
    /*        and commit the changes to the database                                            */
            
            
            create query hBeforeQry.
            hBeforeQry:add-buffer(hBeforeBuff).
            hBeforeQry:query-prepare("FOR EACH " + hBeforeBuff:name).
            hBeforeQry:query-open().
            hBeforeQry:get-first().
            
            do while not (hBeforeQry:query-off-end):
                
                
                message "CommitChanges : " hBeforeBuff:name skip
                    hBeforeBuff:row-state
                    hBeforeBuff:buffer-field(1):BUFFER-VALUE skip
                    hBeforeBuff:buffer-field(2):NAME
                    hBeforeBuff:buffer-field(2):BUFFER-VALUE
                   .
                
                /* The actual SAVE to the database */
                if not hBeforeBuff:error then
                    hBeforeBuff:save-row-changes().
    
                /* If there was an error signal that this row did not make it into the database. */
                if hBeforeBuff:error then
                    assign 
                        hDataSet:error       = true
                        hBeforeBuff:rejected = true.
                hBeforeQry:get-next().
            end. /* DO WHILE NOT QUERY-OFF-END */
            delete object hBeforeQry.
        end. /* DO IF VALID-HANDLE */
    end method.
end class.