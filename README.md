# GenericService

An implementation of a generic WebHandler that implements a more 'normal' REST
api than the JSDO implementation.

This example is based on the Sports2000 db (of course :)).
It supports paging ("limit" and "offset"), sorting ("sort_by") and basic 
filtering by using whatever field available for a certain object/business entity.


It also performs checks:

- if fields used in the filter actually exist for a certain object.
- if entities exist (either as a main entity or as combined entities i.e. 
  customers orders eq. customers/id/orders)

Important files:

- FilterParams.cls      (object that handles the filter)
- GenericService.cls    (the actual webhandler)
- IBusinessEntity.cls   (the interface)
- filter_support.i      (generic methods: count/paging/field check)
