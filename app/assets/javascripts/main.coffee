$(document).ready ->
  alertify.success($("p.notice").html()) if $("p.notice").length > 0
  alertify.alert($("p.alert").html()) if $("p.alert").length > 0

$(document).ajaxStart ->
  $("div.loading").show()

$(document).ajaxStop ->
  $("div.loading").hide()
