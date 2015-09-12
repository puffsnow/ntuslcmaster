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

  $("#create_member_field > .submit").click ->
    grade = parseInt($("#create_member_field input[name=\"grade\"]").val())
    name = $("#create_member_field input[name=\"name\"]").val()
    if isNaN(grade) || grade == 0
      alert("請輸入級別")
      return
    if name == ""
      alert("請輸入姓名")
      return
    $.ajax
      url: "/admin/create_member"
      dataType: "json"
      method: "POST"
      data: { grade: grade, name: name }
      error: (jqXHR, textStatus, errorThrown) ->
      success: (data, textStatus, jqXHR) ->
        alert(data.response.success)
        alert(data.response.message)

  $("#destroy_member_field > .submit").click ->
    member_id = $("#destroy_member_field .member_select").val()
    if member_id == ""
      alert("請選擇社員")
      return
    $.ajax
      url: "/admin/destroy_member"
      dataType: "json"
      method: "POST"
      data: { member_id: member_id }
      error: (jqXHR, textStatus, errorThrown) ->
      success: (data, textStatus, jqXHR) ->
        alert(data.response.success)
        alert(data.response.message)

  $("#update_member_relation_field > .submit").click ->
    

  return