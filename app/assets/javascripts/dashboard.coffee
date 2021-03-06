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

onDataBound = (e) ->
  if current_user is ''
    console.log(current_user)
    $('.editButton').hide()
    $('.deleteButton').hide()
    $('.sui-toolbar').hide()

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
          Win7: { path: 'Win7', type: String }
          Office: { path: 'Offie', type: String }
          Access: { path: 'Access', type: String }
          Visio: { path: 'Visio', type: String }
          Project: { path: 'Project', type: String }
          created_at: { path: 'created_at', type: String }
          updated_at: { path: 'updated_at', type: String }
          contract: { path: 'contract', type: String }
          room: { path: 'room', type: String }
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
        dataBound: onDataBound
    },

    sorting: true
    columns: [
      { field: 'contract', title: 'Contract', width: 50 },
      { field: 'AssetTag', title: 'AssetTag', width: 50 },
      { field: 'Model', title: 'Model', width: 100 },
      { field: 'Serial', title: 'Serial', width: 100 },
      { field: 'Location', title: 'Location', width: 50 },
      { field: 'room', title: 'Room', width: 50 },
      { field: 'POC', title: 'POC', width: 50 },
      { field: 'Disposition', title: 'Disposition', width: 200 },
      { field: 'updated_at', title: 'last update', width: 50 },
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
  dataSource = $('#inventories').swidget().dataSource
  input = $('#filterbox input')
  timeout = undefined
  value = undefined
  input.on 'keydown', ->
    clearTimeout timeout

    timeout = setTimeout((->
      value = input.val()
      if value
        dataSource.filter = or: [
          {
            path: 'AssetTag'
            filter: 'contains'
            value: value
          }
          {
            path: 'Location'
            filter: 'contains'
            value: value
          }
          {
            path: 'Serial'
            filter: 'contains'
            value: value
          }
          {
            path: 'POC'
            filter: 'contains'
            value: value
          }
          {
            path: 'Model'
            filter: 'contains'
            value: value
          }
        ]
      else
        dataSource.filter = null
      dataSource.read()
      return
    ), 300)
    return
