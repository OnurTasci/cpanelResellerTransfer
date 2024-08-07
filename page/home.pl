#!/usr/local/cpanel/3rdparty/bin/perl
print <<EOM;
<div id="MainContent">
            <fieldset id="homeRemoteInformation">
                <legend>
                      Remote Server Information
                </legend>
                <div class="form-group">
                    <label for="host">Remote Server Type:</label>
                    <form method="post" role="form">
                    <div class="row">
                        <div class="col-sm-6">
                        <div class="form-check">
                          <input class="form-check-input" type="radio" value="cpanel" name="remote_server_type" id="remote_server_type1" checked>
                          <label class="form-check-label" for="remote_server_type1">
                            cPanel WHM
                          </label>
                        </div>
                        <div style="display:none;" class="form-check">
                          <input class="form-check-input" disabled type="radio" value="plesk" name="remote_server_type" id="remote_server_type2" >
                          <label class="form-check-label" for="remote_server_type2">
                            Plesk (Disabled)
                          </label>
                        </div>
                        <div style="display:none;" class="form-check">
                          <input class="form-check-input" disabled type="radio" value="directadmin" name="remote_server_type" id="remote_server_type2" >
                          <label class="form-check-label" for="remote_server_type2">
                            DirectAdmin (Disabled)
                          </label>
                        </div>
                        </div>
                    </div>
                   </form>
                </div>
            </fieldset>
            <div id="getSourceServerType"></div>
</div>
EOM
1;