@GlobalFunction = 
  show_loading_mask: ->
    $("div.loading").show()

  hide_loading_mask: ->
    $("div.loading").hide()

$(document).ready ->
  alertify.success($("p.notice").html()) if $("p.notice").length > 0
  alertify.alert($("p.alert").html()) if $("p.alert").length > 0
