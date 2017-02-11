# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


detailCreated = (e) ->
  # add a nested grid to the row, containing the person's friends
  $('<div/>').appendTo(e.detailCell).shieldGrid
    dataSource:
      remote:
        read: "/inventories/#{e.item.id}/versions.json"
    sorting: multiple: true
    paging: pageSize: 5
    columns: [
      { field: 'item_type', title: 'Item Type', width: 50 },
      { field: 'event', title: 'Event', width: 100 },
      { field: 'object_changes', title: 'What Changed', width: 100, format: remove_newlines = (value) ->
          if value != null
            return value.replace /\n/g, '<br />'
          return
      },
      { field: 'whodunnit', title: 'Changed By', width: 100},
      { field: 'created_at', title: 'Created At', width: 100 }
    ]
$ ->
  $('#inventories').shieldGrid
    dataSource:
      schema:
        fields:
          id: { path: 'id', type: Number }
          AssetTag: { path: 'AssetTag', type: String }
          Model: { path: 'Model', type: String }
          Serial: { path: 'Serial', type: String }
          Description: { path: 'Description', type: String }
          Location: { path: 'Location', type: String }
          POC: { path: 'POC', type: String }
          Disposition: { path: 'Disposition', type: String }
      remote:
        read: '/inventories.json'
        modify:
          create: (items, success, error) ->
            newItem = items[0]
            $.ajax
              url: '/inventories'
              type: 'POST'
              dataType: 'json'
              data: { inventory: newItem.data }
              complete: (xhr) ->
                if xhr.readyState == 4 and xhr.status == 201
                  newItem.data.id = xhr.responseJSON.id
                  return success()
                error()
          update: (items, success, error) ->
            newItem = items[0]
            $.ajax
              url: "/inventories/#{newItem.data.id}"
              type: 'PUT'
              dataType: 'json'
              data: { inventory: newItem.data }
            .then(success, error)
          remove: (items, success, error) ->
            newItem = items[0]
            $.ajax
              url: "/inventories/#{newItem.data.id}"
              type: 'DELETE'
              dataType: 'json'
             .then(success, error)
    paging: {
            pageSize: 15,
            pageLinksCount: 7
        },
    events: {
        detailCreated: detailCreated
    },

    sorting: true
    columns: [
      { field: 'AssetTag', title: 'AssetTag', width: 50 },
      { field: 'Model', title: 'Model', width: 100 },
      { field: 'Serial', title: 'Serial', width: 100 },
      { field: 'Location', title: 'Location', width: 100 },
      { field: 'Disposition', title: 'Disposition', width: 200 },
      {
        title: 'Actions',
        width: 70,
        buttons: [
          { cls: 'editButton', commandName: 'edit', caption: 'Edit' }
          { cls: 'deleteButton', commandName: 'delete', caption: 'Delete' }
        ]
      }
    ]
    editing:
      enabled: true
      type: 'row'
      confirmation:
        delete:
          enabled: true
          template: (item) ->
            "Are you sure you want to delete Inventory Item \"#{item.AssetTag}\"?"
    toolbar: [
      {
        buttons: [
          commandName: 'insert'
          caption: 'Add Inventory Item'
        ]
        position: 'top'
      }
    ]
