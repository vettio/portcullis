#= require lib/core

$('a.item').attr 'data-no-turbolinks', true
$('a.item').on 'click', (event) ->
  event.preventDefault()
  Portcullis.NewProfile.Events.toggleSelection $(this)
  false

Portcullis.NewProfile =
  Events:
    select: (elem) ->
    unselect: (elem) ->
    toggleSelection: (elem) ->
  Genres:
    select: (elem) ->
    unselect: (elem) ->
    toggleSelection: (elem) ->
