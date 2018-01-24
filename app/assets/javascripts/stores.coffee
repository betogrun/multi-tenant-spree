# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
    $("#new_store").validate(
        {
            debug: true,
            rules: {
                "store[subdomain]": { required: true, minlength: 6, remote: "/checksubdomain" },
                "admin_login": { required: true, email: true},
                "admin_password": { required: true, minlength: 6 },
                "confirm_admin_password": { required: true, equalTo: "#admin_password" }
            },
            messages: {
                 "store[subdomain]": {remote: $.validator.format("{0} is already in use")}
            }
        }
    )
