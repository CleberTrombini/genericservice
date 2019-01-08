
/*------------------------------------------------------------------------
    File        : IBusinessEntity
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : egarcia
    Created     : Tue Sep 08 13:49:51 EDT 2015
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using FilterParams.*.
using Progress.Json.ObjectModel.*.

interface interfaces.CRUD:  
   
    method public void Read(filter as FilterParams, output dataset-handle hDataSet). 
    method public void Create(input jsonObject as JsonObject, output dataset-handle hDataSet).
    method public void Update(filter as FilterParams, input jsonObject as JsonObject, output dataset-handle hDataSet).
    method public void CheckFieldList(fieldlist as character, output oFieldList as character, output lOk as logical). 
    method public void CreateEntityModel (output lcModel as longchar).

end interface.