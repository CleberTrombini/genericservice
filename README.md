# GenericService

An implementation of a generic WebHandler that implements a more 'normal' REST
api than the JSDO implementation.

This example is based on the Sports2000 db (of course :)).
It supports paging ("limit" and "offset"), sorting ("sort_by") and basic 
filtering by using whatever field available for a certain object/business entity.

It also supports viewing of meta data of a certain entity (field names and data types).
This can be done by using /api/<b>meta</b>/ as URI.
If you just want to get data, you should use /api/<b>data</b>/

<b>It performs checks:</b>

- if fields used in the filter actually exist for a certain object.
- if entities exist (either as a main entity or as combined entities i.e. 
  customers orders eq. customers/id/orders)

<b>Important files:</b>

- FilterParams.cls      (object that handles the filter)
- GenericService.cls    (the actual webhandler)
- IBusinessEntity.cls   (the interface)
- filter_support.i      (generic methods: count/paging/field check)

<b>Note:</b>

You will need to create a new OpenEdge Project of type 'Server', 'PAS for OpenEdge' and with transport 'WEB'. 

Then you will need to create the Resource URI(s) (mappings) for the WebHandler accordingly:

1. /api/{apitype}/{entityname}/{id1}/{entityname2}/{id2}
2. /api/{apitype}/{entityname}/{id1}/{entityname2}
3. /api/{apitype}/{entityname}/{id1}
4. /api/{apitype}/{entityname}

