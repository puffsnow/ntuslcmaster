# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  $(".family_tree_table .btn-member").click ->
    member_id = parseInt($(this).attr("id").substring(1))
    if member_chosen == 0
      show_family_tree(member_id) 
    else if member_chosen == member_id
      clear_family_tree
    else
      clear_family_tree
      show_family_tree(member_id)

  show_family_tree = (id) ->
    member_chosen = id

  clear_family_tree = ->
    member_chosen = 0

  member_chosen = 0