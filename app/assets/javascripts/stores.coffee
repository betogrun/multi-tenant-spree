# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready ->
    $("#subdomain-message").hide()
    console.log("aqui")
    $("#store_subdomain").keyup ->
        value = $("#store_subdomain").val()
        console.log(value)
        check()
        
check = -> 
    $.ajax '/checksubdomain?subdomain_name='+$("#store_subdomain").val(),
    type: 'GET'
    dataType: 'html'
    error: (jqXHR, textStatus, errorThrown) ->
        #$('body').append "AJAX Error: #{textStatus}"
    success: (data, textStatus, jqXHR) ->
        #$('body').append "Successful AJAX call: #{data}"
        if data == 'true' then $("#subdomain-message").show() else $("#subdomain-message").hide()


