$(document).ready ->
  $("div.field").hide()
  $("div.field-0").show()
  alertify.success($("p.notice").html()) if $("p.notice").length > 0
  alertify.alert($("p.alert").html()) if $("p.alert").length > 0
  $(".nav-tabs li").click ->
    if !$(this).hasClass("active")
      $(".nav-tabs li.active").removeClass("active")
      choose_tab_num = $(".nav-tabs li").index($(this))
      $(".nav-tabs li:eq(" + choose_tab_num + ")").addClass("active")
      $("div.field").hide()
      $("div.field-" + choose_tab_num).show()

$(document).ajaxStart ->
  $("div.loading").show()

$(document).ajaxStop ->
  $("div.loading").hide()
