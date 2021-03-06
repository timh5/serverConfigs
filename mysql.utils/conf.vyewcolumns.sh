## This defines which columns should be used in each table
## for row comparison during sync script
col_accounts=accountid,fname,lname,addr1,cc_num,cc_card_code,cc_exp,ownerid,packageid
col_books=id,ownerid,collectionid,isPublic,tstamp,deleted
col_cart_genstat=id,sessionid
col_collections=collectionid,ownerid,tstamp
col_comments=id,commentid,tstamp
col_converts=id
col_drawings=drawingid,layerid
col_files=id,tstamp,filename,diskname
col_folders=id,parentid
col_genstat=id
col_layers=layerid,ownerid,collectionid,tstamp
col_lobby_meeting_sessions=id,meeting_id,sessionid,tstamp
col_medias=mediaid,tstamp,layerid
col_meeting_data=id,lastAction
col_meeting_files=id,meetingid
col_meeting_sessions=id,meeting_id,tstamp
col_meeting_users=id,meetingid,userid,rights
col_meetings=id,meetingid,begintime,endtime
col_packages=packageid,type
col_pending_charges=id,userid,sessionid,charge_date,create_date,amount,charge_status
col_sched_meetings=id,meetingid,ownerid,start,stop,deleted
col_sessions=id,sessionid,userid,lastAction
col_stats=id,stat
col_userinfo=id,userid,fname
col_transactions=id,userid,sessionid,tstamp,RESPONSE_CODE,TRX_id,MD5_HASH,APPROVAL_CODE
col_addon_types=id,type,name,price
col_addons=id,packageid,creator_limit
col_adserve=id,grp,size,imgURL,clickURL
col_affiliate_commission=id,affiliateid,amount,commission,isPaid,is_recurring,createDate,deduction
col_affiliate_settings=id,affiliateid,typeName
col_affiliates=affiliateid,email,,fname,trackingid,createDate
col_apikeys=id,key,secret,userid
col_apilimits=apikeyid,name,count,limit
col_auditlogs=id,tstamp,sessionid,userid
col_autologin=id,userid,key,expireDate
col_bank_gateway=auth_net_login_id,auth_net_tran_key
col_bookfolders=id,parentid,ownerid,isPublic,isShared
col_brands=brandid,name,link
col_bugs=id,sessionid,tstamp
col_cakes=cakeid,key,val
col_cobrands=cobrandid,trackingid,link
col_coupon_types=id,code,useLimit,discountAmt
col_coupons=couponid,code,userid,useCount
col_email_inboxes=id,userid,email,enabled
col_emusic=id,username,tstamp
col_facebook=user,mid
col_group_settings=groupid,key,value
col_groups=id,name,parentid,rootgroupid
col_guest_limits=id,type,limit
col_invites=id,meetingid,bookid,meetingUserid,lastDate,lastEntry
col_ipn=id,userid,sessionid,txn_type,txn_id,payment_date,payment_gross,payment_fee,payment_status,recurring
col_login_fails=email,tstamp
col_meeting_session_times=id,meetingSessionid
col_meeting_settings=meetingid,key,value
col_nstep_requests=id,userid,meetingid,sessionid,tstamp
col_old_passwords=userid,old_passwords,tstamp
col_package_types=packageTypeid,type,name
col_password_reset=email,randtok,tstamp
col_plugin_names=id,plugin_id,name
col_screensharing=id,userid,meetingid,tstamp
col_selftests=id,tstamp,sid
col_servers=serverid,name,lastPing,users,rooms,force
col_servers_dev=serverid,name,lastPing,users,rooms,force
col_skins=id,ownerid,name
col_test=id,value
col_trx_charges=id,transactionid,chargeid
col_unitystat=id,vers,servid,tstamp
col_user_settings=userid,key,value
col_userlevel_group=userleveltypeid,userid,groupid
col_userlevel_subgroup=userleveltypeid,userid,groupid
col_userlevel_types=id,rootgroupid,name,rights
col_users=userid,deleted,email,pswd,type,createSession,validated,loginid,lastPasswordChange,rootgroupid,cobrandid
col_usertypes=id,type,name,rights
cl_votes=id,ownerid,rating,tstamp



