#!/usr/local/cpanel/3rdparty/bin/perl
sub resellertransferAjaxJs{
	print <<EOM;
<div id="loaderresellertransfer" style="background: none repeat scroll 0 0 black; position: fixed; display: block; opacity: 0.5; z-index: 1000001; left: 0; top: 0; height: 100%; width: 100%;display:none;">
<div style="position: absolute; left: 50%; top: 50%; z-index: 1; width: 60px; height: 60px; border: 6px solid #f3f3f3; border-radius: 50%; border-top: 6px solid #3498db; -webkit-animation: spin 2s linear infinite; animation: spin 2s linear infinite;"></div>
</div>
<style>
#tableBackupsList th:first-child, #tableBackupsList td:first-child { display: none; }
#datatableList thead th, #tableBackupsList thead th {
    width: 100% !important;
}
#datatableList thead th:first-child {width: 20% !important;}
table#tableBackupsList, table#datatableList {
    border-radius: 3px;
}
</style>
<script src="assets/js/jquery.min.js"></script>
<div id="resellertransferAlert" style="margin-top: 12px;"></div>
<script language="javascript">
    async function resellertransferAjax(args){

    \$('#resellertransferAlert').html('');

    var postUrl = '?action='+args['action'];
    var data = args['data'][0];
    var type = "POST";
    var dataType = "html";
    if(args['type'] != undefined){
      var type = args['type'];
    }
    if(args['dataType'] != undefined){
      var dataType = args['dataType'];
    }

    let result;
    let jQuery = \$;
    try {

        return await jQuery.ajax({
             url:  postUrl,
             type: type,
             data: data,
             dataType: dataType,
             beforeSend: function() {
                     jQuery('#loaderresellertransfer').show();
                 },
                 success: function(data) {
                      jQuery('#loaderresellertransfer').hide();
                 },
                 error: function(xhr) {
                         alert("Error Reseller Transfer Tools Request!");
                },
       });

    } catch (error) {
        console.error(error);
    }
    }

function submitMSG(valid, msg,id = 'resellertransferAlert') {
    var status = 'alert-danger';
    if (valid) {
        status = 'alert-success';
    }
    \$('#'+id).html('<div class="alert alert-danger" role="alert">'+msg+'</div>');
}

    let jQuery = \$;

/* Trigger */
//jQuery('input[name="remote_server_type"]').change(function(){
    resellertransferAjax({
    action:jQuery('input[name="remote_server_type"]:checked').val(),
    type:'GET',
    data:[],
    }).then(function(res) {
          jQuery("#getSourceServerType").html(res);
          jQuery('#getSourceServerTypeButton').attr('disabled',false);
          jQuery("#contentContainer").animate({scrollTop: jQuery("#getSourceServerType").position().top}, 500, 'swing');
    });

//});
</script>
EOM
}

sub resellertransferCustomHeader {
    Cpanel::Template::process_template(
        'whostmgr',
        {
            'print'                        => 1,
            'template_file'                => '_defheader.tmpl',
            'header'                       => $_[0] || undef,
            'icon'                         => '/addon_plugins/resellertransfer.png',
            'theme'                        => "bootstrap",
            'breadcrumbdata'               => {
                'name' => $_[0],
                'url' => '/cgi/'.$_[1],
                'previous' => [
                    {
                        'name' => 'Home',
                        'url' => '/scripts/command?PFILE=main'
                    },
                    {
                        'name' => 'Plugins',
                        'url'  => '/scripts/command?PFILE=Plugins'
                    }
                ]
            }
        },
    );

    return;
}

sub resellertransferFooter {
	if (getCpanelVersion() >= 64.0) {
		Whostmgr::HTMLInterface::deffooter();
	} else {
		print '</body></html>';
	}
}

1;