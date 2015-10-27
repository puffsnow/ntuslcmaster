# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  if $("#member_update_contact_field input.disable_all").is(':checked')
    $("#member_update_contact_field .activity_option").prop("disabled", true)
    $("#member_update_contact_field .activity_option.disable_all").prop("disabled", false)

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


  $("#member_update_relation_field > .submit").click ->
    member_id = $("#member_update_relation_field .member_select").val()
    type = $("#member_update_relation_field .relation_type_select").val()
    $.ajax
      url: "/members/update_relation"
      dataType: "json"
      method: "POST"
      data: { member_id: member_id, type: type }
      error: (jqXHR, textStatus, errorThrown) ->
      success: (data, textStatus, jqXHR) ->
        alertify.success("修改關係成功") if data.response.success == true
        alertify.alert(data.response.message) if data.response.success == false


  $("#member_update_contact_field input.disable_all").change ->
    if $(this).is(':checked')
      $("#member_update_contact_field .activity_option").prop("disabled", true)
      $("#member_update_contact_field .activity_option.disable_all").prop("disabled", false)
      $("#member_update_contact_field .activity_option[value=\"10000\"]").prop("checked", false) if $(this).val() == "0"
      $("#member_update_contact_field .activity_option[value=\"0\"]").prop("checked", false) if $(this).val() == "10000"
    else
      $("#member_update_contact_field .activity_option").prop("disabled", false)


  $("#member_update_contact_field > .submit").click ->
    activity_array = $("#member_update_contact_field .activity_option:checked").map ->
      return this.value;
    .get()

    contact_array = $("#member_update_contact_field .contact:checked").map ->
      return this.value;
    .get()

    activity_comment = $("#member_update_contact_field #activity_comment").val()
    contact_comment = $("#member_update_contact_field #contact_comment").val()
    
    $.ajax
      url: "/members/update_contact"
      dataType: "json"
      method: "POST"
      data: { activities: activity_array, contacts: contact_array, activity_comment: activity_comment, contact_comment: contact_comment}
      error: (jqXHR, textStatus, errorThrown) ->
      success: (data, textStatus, jqXHR) ->
        alertify.success("修改聯絡資料成功") if data.response.success == true
        alertify.alert(data.response.message) if data.response.success == false

  $("#member_follow_field > .submit").click ->
    follow_id = $("#member_follow_field .member_select").val()
    if follow_id == "0"
      alert("請選擇一個成員") 
      return
    $.ajax
      url: "/follow_relations"
      dataType: "json"
      method: "POST"
      data: { follow_id: follow_id }
      error: (jqXHR, textStatus, errorThrown) ->
      success: (data, textStatus, jqXHR) ->
        if data.response.success == true
          alertify.success("已加入追蹤名單")
          contact_comment = data.response.contact_comment
          if contact_comment == undefined
            class_name = "active"
            description = "此社員未註冊"
          else if contact_comment.all_activities == true
            class_name = "success"
            description = "希望得到所有活動資訊"
          else if contact_comment.none_activities == true
            class_name = "danger"
            description = "希望不要聯繫"
          else
            class_name = "primary"
            description = "希望得到特定活動資訊"
          new_row = $("<tr class=\"" + class_name + "\"></tr>")
          new_row.append("<td>" + $("#member_follow_field .grade_select option:selected").text() + "</td>")
          new_row.append("<td>" + $("#member_follow_field .member_select option:selected").text() + "</td>")
          new_row.append("<td>" + description + "</td>")
          new_row.append("<td><a href=\"/follow_relations/" + follow_id + "\" class=\"a-remove-follow-relation\"><i class=\"fa fa-minus-square-o fa-lg\"></i></a></td>")
          new_row.append("<td></td>") if class_name == "active"
          new_row.append("<td><i class=\"fa fa-angle-double-down fa-lg\"></i></td>") if class_name != "active"  
          new_row.appendTo("#member_follow_field table")
        else
          alertify.alert(data.response.message) 

  $('#member_follow_field').on 'click', '.a-remove-follow-relation', (event) ->
    event.preventDefault()
    dom_button = $(this)
    $.ajax
      url: $(this).attr("href")
      dataType: "json"
      method: "DELETE"
      error: (jqXHR, textStatus, errorThrown) ->
      success: (data, textStatus, jqXHR) ->
        dom_button.closest("tr").remove()
        alertify.success("已從追蹤名單移除")

  $('#member_follow_field').on 'click', '.a-detail-follow-relation', (event) ->
    event.preventDefault()
    dom_button = $(this)
    $.ajax
      url: $(this).attr("href")
      dataType: "json"
      method: "GET"
      error: (jqXHR, textStatus, errorThrown) ->
      success: (data, textStatus, jqXHR) ->

  return


