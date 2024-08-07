#!/usr/local/cpanel/3rdparty/bin/perl
print '
<link rel="stylesheet" href="assets/css/dataTables.bootstrap4.min.css">
<link rel="stylesheet" href="assets/css/dataTables.checkboxes.css">
<script src="assets/js/jquery.dataTables.min.js"></script>
<script src="assets/js/dataTables.bootstrap4.min.js"></script>
<script src="assets/js/dataTables.checkboxes.min.js"></script>
<form method="post" id="getSourceServerForm" role="form">
<fieldset>
        <legend>
            Remote Server Information
        </legend>
        <div class="form-group">
            <div class="row">
                <div class="col-sm-5">
                    <label for="host">Remote Server Address:</label>
                    <input type="text" placeholder="127.0.0.1" autocomplete="false" name="server_host" required class="form-control">
                </div>
                <div class="col-sm-1">
                    <label for="server_port">Port:</label>
                    <input type="text" placeholder="2087" value="2087" autocomplete="false" name="server_port"   required class="form-control">
                </div>
            </div>
        </div>
        <div class="form-group">
            <label for="host">Remote Username:</label>
            <div class="row">
                <div class="col-sm-6">
                    <input type="text" placeholder="root" autocomplete="false" name="server_username" required class="form-control">
                </div>
            </div>
        </div>
        <div class="form-group">
            <label for="host">Remote Password:</label>
            <div class="row">
                <div class="col-sm-6">
                    <input placeholder="*****" autocomplete="false" type="text" name="server_password" required class="form-control">
                </div>
            </div>
        </div>
        <div class="form-group">
            <div class="form-check">
                <input class="form-check-input" type="checkbox" value="s" checked id="checkSsl" name="server_ssl">
                <label class="form-check-label" for="checkSsl">
                    SSL Connect
                </label>
            </div>
        </div>

    </fieldset>
    <button disabled type="submit" id="getSourceServerTypeButton" class="btn btn-primary">
        <div class="button-text">Scan Remote Server</div>
    </button>
    </form>
    <div class="table-responsive" style="display:none;" id="cPanelStep2">

     <legend>Remote Server Users List </legend>

    <table class="table table-striped table-bordered"  id="datatableList">
        <thead>
        <tr>
            <th></th>
            <th>User</th>
            <th>Domain</th>
            <th>Disk</th>
            <th>IP</th>
            <th>Owner</th>
            <th>Plan</th>
        </tr>
        </thead>
        <tbody>
        </tbody>
    </table>
    <button type="button" style="display:none;" class="getbackups btn btn-primary mt-3 mb-3">Start Migration</button>
</div>
<div id="backupsList" style="display: none;">

     <legend>Remote Server Selected Users List </legend>

    <table class="table table-striped table-bordered" id="tableBackupsList">
        <thead>
        <tr>
            <th></th>
            <th>User</th>
            <th>Domain</th>
            <th>Disk</th>
            <th>Status</th>
        </tr>
        </thead>
        <tbody>
        </tbody>
    </table>
    <button type="button" style="display:none;" class="importbackups btn btn-primary mt-3 mb-3">Start Queued Transfer</button>

</div>

<script>
  jQuery("#getSourceServerForm").submit(function(e){
        e.preventDefault();
        var form = jQuery(this);
        resellertransferAjax({
            action:"cpanel/getList",
            type:"GET",
            dataType:"json",
            data:[form.serialize()],
        }).then(function(json) {
            if (json.status) {
                jQuery("#getSourceServerForm").attr("style","display: none !important");
                jQuery("#cPanelStep2").attr("style","display: block !important");
                jQuery("#homeRemoteInformation").attr("style","display: none !important");
                var suspended = "";
                jQuery("#datatable tbody").empty();
                jQuery.each( json.acct, function( index, value ){
                    suspended = "";
                    if(value.suspended == 1) { suspended = "bg-danger"; }
                    jQuery("#datatableList tbody").append("<tr class=\""+suspended+"\" id=\"user_"+value.user+"\" ><td>"+value.user+"</td><td>"+value.user+"</td><td>"+value.domain+"</td><td>"+value.diskused+"</td><td>"+value.ip+"</td><td>"+value.owner+"</td><td>"+value.plan+"</td></tr>");
                });
                jQuery(".getbackups").attr("style","display: block !important");
                dataTablesGenerator();
            } else {
                submitMSG(false, json.cpanelresult.error);
            }
        });
    });


function dataTablesGenerator(){
    let jQuery = $;
    var datatableList = $("#datatableList").DataTable({ "columnDefs": [ { "targets": 0, "checkboxes": { "selectRow": true } } ], "select": { "style": "multi" }, "order": [[1, "asc"]] });
    jQuery(".getbackups").click(function (event) {
        if (event.isDefaultPrevented()) {
            submitMSG(false);
        } else {
            event.preventDefault();

            jQuery("#backupsList").attr("style","display: block !important");
            jQuery("#cPanelStep2").attr("style","display: none !important");

            var tableBackupsListBa = jQuery("#tableBackupsList").DataTable({
                "columnDefs": [
                    {
                        "targets": 0,
                        "checkboxes": {
                            "selectRow": true
                        }
                    }
                ],
                "select": {
                    "style": "multi"
                },
                "order": [[1, "asc"]]
            });

            jQuery.each(datatableList.column(0).checkboxes.selected(), function(index, host){
                var hostDetails = datatableList.$("#user_"+host);
                resellertransferAjax({
                    action:"cpanel/resetPassword",
                    dataType:"json",
                    type:"GET",
                    data:[jQuery("#getSourceServerForm").serialize()+"&host=" + host],
                }).then(function(json) {
                  if (json.metadata.result) {
                                        jQuery("#tableBackupsList").dataTable().fnAddData( [
                                            "<input type=\"checkbox\" class=\"checkBackupFinis\" checked=\"checked\" name=\"backup["+host+"]\" data-username=\""+host+"\" readonly>",
                                            host,
                                            hostDetails.find("td:eq(2)").text(),
                                            hostDetails.find("td:eq(3)").text(),
                                            "<div class=\"transferStatus\" data-host=\""+host+"\" ></div>Ready for Transfer",
                                        ] );
                                    } else {
                                        jQuery("#tableBackupsList").dataTable().fnAddData( [
                                            "<input type=\"checkbox\" class=\"checkBackupFinis\" name=\"backup["+host+"]\" data-username=\""+host+"\" readonly>",
                                            host,
                                            hostDetails.find("td:eq(2)").text(),
                                            hostDetails.find("td:eq(3)").text(),
                                            json.msg+"<button data-retryuser=\""+host+"\" class=\"retryBackupUser btn btn-primary\">Transfer Retry</button>"
                                    ] );
                         }
                });
            });
            checkAllBakcup(datatableList);
        }
    });

   $(document).on("click", ".retryBackupUser", function(event) {
        event.preventDefault();
        var host = $(this).data("retryuser");
        resellertransferAjax({
           action:"cpanel/resetPassword",
            dataType:"json",
            type:"GET",
            data:[jQuery("#getSourceServerForm").serialize()+"&host=" + host],
        }).then(function(json) {
            if (json.metadata.result) {
                $("*[data-retryuser=\""+host+"\"]").parent().parent().find("td:nth-child(5)").html("<div class=\"transferStatus\" data-host=\""+host+"\"></div> Ready for Transfer");


                   var session_id = $(".importbackups").attr("data-session-id");
                  $.ajax({
                                        type: "GET",
                                        dataType: "json",
                                        url: apiUrl+"enqueue_transfer_item?api.version=1&transfer_session_id="+session_id+"&module=AccountRemoteUser&user="+host+"&localuser="+host+"",
                                        success: function (jsonIn) {
                                            if (jsonIn.metadata.result == 1) {
                                                $("*[data-host=\""+host+"\"]").parent().html("Added Queue");
                                            }
                                        }
                                    });


            } else {
               submitMSG(false,json.msg);
            }
        });
    });
}


function checkAllBakcup (tableBackupsListBa) {
    var users = [];
    var totalusers = 0;
    $.each(tableBackupsListBa.column(0).checkboxes.selected(), function(index, host){
        users.push(host);
    });
    totalusers = users.length;
    var dataArray = $("#getSourceServerForm").serializeArray(),
        getSourceServerForm = {};

    $(dataArray).each(function(i, field){
        getSourceServerForm[field.name] = field.value;
    });

    var masterUrl = "../../";
    var apiUrl = "../../json-api/";

    $.ajax({
        type: "GET",
        dataType: "json",
        url: apiUrl+"create_remote_user_transfer_session?api.version=1&unrestricted_restore=1&host="+getSourceServerForm["server_host"]+"&password="+getSourceServerForm["server_password"]+"",
        success: function (json) {
            if (json.metadata.result == 1) {
                $(".importbackups").attr("data-session-id",json.data.transfer_session_id);
                $(users).each(function(key,host) {
                    $.ajax({
                        type: "GET",
                        dataType: "json",
                        url: apiUrl+"enqueue_transfer_item?api.version=1&transfer_session_id="+json.data.transfer_session_id+"&module=AccountRemoteUser&user="+host+"&localuser="+host+"",
                        success: function (jsonIn) {
                            if (jsonIn.metadata.result == 1) {
                             $("*[data-host=\""+host+"\"]").parent().html("Added Queue");
                            }
                        }
                    });
                });
              $(".importbackups").attr("style","display: block; !important");
            }else{
                submitMSG(false,json.metadata.reason);
            }
        }
    });


    $(document).on("click", ".importbackups", function(event) {
        var session_id = $(".importbackups").attr("data-session-id");
        $.ajax({
            type: "GET",
            dataType: "json",
            url: "../../json-api/start_transfer_session?api.version=1&transfer_session_id="+session_id+"",
            success: function (json) {
                if (json.metadata.result == 1) {
                    window.location.href = "../../scripts5/transfer_session?transfer_session_id="+session_id;
                }else{
                    submitMSG(false,json.metadata.reason);
                }
            }
        });
    });


}

</script>

';
1;