# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  $("a.register_accept").click (event)->
    event.preventDefault()
    register_row_dom = $(this).closest("tr")
    $.ajax
      url: $(this).attr("href")
      dataType: "json"
      method: "POST"
      error: (jqXHR, textStatus, errorThrown) ->
      success: (data, textStatus, jqXHR) ->
        alertify.success("接受社員登記完成") and register_row_dom.hide() if data.response.success == true
        alertify.alert(data.response.message) if data.response.success == false


  $("a.register_reject").click (event)->
    event.preventDefault()
    $.ajax
      url: $(this).attr("href")
      dataType: "json"
      method: "POST"
      error: (jqXHR, textStatus, errorThrown) ->
      success: (data, textStatus, jqXHR) ->
        alertify.success("拒絕社員登記完成") if data.response.success == true
        alertify.alert(data.response.message) if data.response.success == false

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
        alertify.success("建立社員成功") if data.response.success == true
        alertify.alert(data.response.message) if data.response.success == false

  $("#update_member_field > .submit").click ->
    member_id = $("#update_member_field .member_select").val()
    grade = parseInt($("#update_member_field input[name=\"grade\"]").val())
    name = $("#update_member_field input[name=\"name\"]").val()
    if member_id == ""
      alert("請選擇社員")
      return
    if isNaN(grade) || grade == 0
      alert("請輸入級別")
      return
    if name == ""
      alert("請輸入姓名")
      return
    $.ajax
      url: "/admin/update_member"
      dataType: "json"
      method: "POST"
      data: { member_id: member_id, grade: grade, name: name }
      error: (jqXHR, textStatus, errorThrown) ->
      success: (data, textStatus, jqXHR) ->
        alertify.success("修改社員成功") if data.response.success == true
        alertify.alert(data.response.message) if data.response.success == false

  $("#admin_update_relation_field > .submit").click ->
    master_id = $("#admin_update_relation_field .member_select:first").val()
    apprentice_id = $("#admin_update_relation_field .member_select:eq(1)").val()
    type = $("#admin_update_relation_field .relation_type_select").val()
    $.ajax
      url: "/admin/update_relation"
      dataType: "json"
      method: "POST"
      data: { master_id: master_id, apprentice_id: apprentice_id, type: type }
      error: (jqXHR, textStatus, errorThrown) ->
      success: (data, textStatus, jqXHR) ->
        alertify.success("修改社員關係成功") if data.response.success == true
        alertify.alert(data.response.message) if data.response.success == false

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
        alertify.success("刪除社員成功") if data.response.success == true
        alertify.alert(data.response.message) if data.response.success == false

  $("#update_activity_field .submit").click ->
    new_activity_name = $("#update_activity_field .create_activity_text").val()
    if new_activity_name == ""
      alert("請輸入活動名稱")
      return
    $.ajax
      url: "/admin/create_activity"
      dataType: "json"
      method: "POST"
      data: { name: new_activity_name }
      error: (jqXHR, textStatus, errorThrown) ->
      success: (data, textStatus, jqXHR) ->
        if data.response.success == true
          $("#update_activity_field table").append("<tr><td>" + new_activity_name + "</td><td></td></tr>")
          $("#update_activity_field .create_row").appendTo("#update_activity_field table")
          $("#update_activity_field .create_activity_text").val("")
          alertify.success("建立活動成功")
        alertify.alert(data.response.message) if data.response.success == false
