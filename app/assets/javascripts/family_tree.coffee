# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->

  $(".family_tree_table .btn-member").click ->
    member_id = parseInt($(this).attr("id").substring(1))
    member_chosen = parseInt($("input[name='member_chosen']").val())
    if member_chosen == 0
      show_family_tree(member_id) 
    else if member_chosen == member_id
      clear_family_tree()
    else
      clear_family_tree()
      show_family_tree(member_id)

  show_family_tree = (id) ->
    $.ajax
      url: "/family_tree/get_relations"
      dataType: "json"
      method: "GET"
      data: {member_id: id}
      error: (jqXHR, textStatus, errorThrown) ->
      success: (data, textStatus, jqXHR) ->
        for relation in data.response.relations
          master_id = relation.master_id
          apprentice_id = relation.apprentice_id
          originX = $('.btn-member[id="m'+master_id+'"]').offset().top + ($('.btn-member[id="m'+master_id+'"]').outerHeight()/2)
          originY = $('.btn-member[id="m'+master_id+'"]').offset().left + $('.btn-member[id="m'+master_id+'"]').outerWidth()
          targetX = $('.btn-member[id="m'+apprentice_id+'"]').offset().top + ($('.btn-member[id="m'+apprentice_id+'"]').outerHeight()/2)
          targetY = $('.btn-member[id="m'+apprentice_id+'"]').offset().left
          class_name = if relation.is_primary == true then "primary_relation" else "sub_relation"
          if master_id != id
            $('.btn-member[id="m'+master_id+'"]').addClass("btn-danger") if relation.is_primary
            $('.btn-member[id="m'+master_id+'"]').addClass("btn-info") if !relation.is_primary
          if apprentice_id != id
            $('.btn-member[id="m'+apprentice_id+'"]').addClass("btn-danger") if relation.is_primary
            $('.btn-member[id="m'+apprentice_id+'"]').addClass("btn-info") if !relation.is_primary
          draw_line(originX, originY, targetX, targetY, class_name)
        $('.btn-member[id="m'+id+'"]').addClass("btn-warning")


    $("input[name='member_chosen']").val(id)

  clear_family_tree = ->
    $(".relation_line").remove()
    $(".btn-member").removeClass("btn-danger btn-info btn-warning")
    $("input[name='member_chosen']").val(0)

  draw_line = (originX, originY, targetX, targetY, className) ->
    linkLine = $('<div class="relation_line '+className+'"></div>')
    length = Math.sqrt((targetX - originX) * (targetX - originX) + (targetY - originY) * (targetY - originY))
    angle = 180 / 3.1415 * Math.acos((targetX - originX) / length)
    linkLine.css('top', originX).css('left', originY)
    
    angle *= -1 if targetY > originY
  
    linkLine
      .css('height', length)
      .css('-webkit-transform', 'rotate(' + angle + 'deg)')
      .css('-moz-transform', 'rotate(' + angle + 'deg)')
      .css('-o-transform', 'rotate(' + angle + 'deg)')
      .css('-ms-transform', 'rotate(' + angle + 'deg)')
      .css('transform', 'rotate(' + angle + 'deg)')
      .appendTo('body');
      