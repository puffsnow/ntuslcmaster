# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  $(".select_grade").change ->
    grade = $(this).val()
    select_member_dom = $(this).next(".select_member")
    if grade == "0"
      return
    $.ajax
      url: "/members/search"
      dataType: "json"
      data: { str: grade }
      error: (jqXHR, textStatus, errorThrown) ->
      success: (data, textStatus, jqXHR) ->
        select_member_dom.children("option").remove()
        select_member_dom.append("<option value=\"0\"> 請選擇成員 </option>")
        members = data.members
        select_member_dom.append("<option value=\"" + member.id + "\"> " + member.name + " </option>") for member in members

  $(".register_exist_member_field > .submit").click ->
    member_id = $(".register_exist_member_field .select_member").val()
    if member_id == "0"
      alert("請選擇一個成員") 
      return
    $.ajax
      url: "/members/link"
      dataType: "json"
      method: "POST"
      data: { member_id: member_id }
      error: (jqXHR, textStatus, errorThrown) ->
      success: (data, textStatus, jqXHR) ->
        # alert(data.response.success)
        # alert(data.response.message)

  return


