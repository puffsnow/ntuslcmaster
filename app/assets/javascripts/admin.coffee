# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  $("a.register_accept").click (event)->
    event.preventDefault()
    $.ajax
      url: $(this).attr("href")
      dataType: "json"
      method: "POST"
      error: (jqXHR, textStatus, errorThrown) ->
      success: (data, textStatus, jqXHR) ->
        alert(data.response.success)
        alert(data.response.message)


  $("a.register_reject").click (event)->
    event.preventDefault()
    $.ajax
      url: $(this).attr("href")
      dataType: "json"
      method: "POST"
      error: (jqXHR, textStatus, errorThrown) ->
      success: (data, textStatus, jqXHR) ->
        alert(data.response.success)
        alert(data.response.message)

  return