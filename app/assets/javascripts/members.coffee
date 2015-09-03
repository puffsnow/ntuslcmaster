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
  return


