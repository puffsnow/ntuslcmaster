# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  $(".grade_select").change ->
    grade = $(this).val()
    member_select_dom = $(this).next(".member_select")
    if grade == "0"
      return
    $.ajax
      url: "/members/search"
      dataType: "json"
      data: { str: grade }
      error: (jqXHR, textStatus, errorThrown) ->
      success: (data, textStatus, jqXHR) ->
        member_select_dom.children("option").remove()
        member_select_dom.append("<option value=\"0\"> 請選擇成員 </option>")
        members = data.members
        member_select_dom.append("<option value=\"" + member.id + "\"> " + member.name + " </option>") for member in members

  $("#register_exist_member_field > .submit").click ->
    member_id = $("#register_exist_member_field .member_select").val()
    if member_id == "0"
      alert("請選擇一個成員") 
      return
    $.ajax
      url: "/members/register"
      dataType: "json"
      method: "POST"
      data: { member_id: member_id }
      error: (jqXHR, textStatus, errorThrown) ->
      success: (data, textStatus, jqXHR) ->
        if data.response.success == true
          alertify.success("註冊社員申請已送出，請等待管理員認證")
          location.reload()
        else
          alertify.alert(data.response.message) 

  $("#register_new_member_field > .submit").click ->
    grade = parseInt($("#register_new_member_field input[name=\"grade\"]").val())
    name = $("#register_new_member_field input[name=\"name\"]").val()
    if isNaN(grade) || grade == 0
      alert("請輸入級別")
      return
    if name == ""
      alert("請輸入姓名")
      return
    $.ajax
      url: "/members/register"
      dataType: "json"
      method: "POST"
      data: { grade: grade, name: name }
      error: (jqXHR, textStatus, errorThrown) ->
      success: (data, textStatus, jqXHR) ->
        if data.response.success == true
          alertify.success("註冊社員申請已送出，請等待管理員認證")
          location.reload()
        else
          alertify.alert(data.response.message) 
  return


