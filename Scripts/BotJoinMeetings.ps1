<#	
	.NOTES
	===========================================================================
	 Created on:   	4/10/2020 12:34 PM
	 Created by:   	Alvin Erb
	 Organization: 	Wellstar Health Systems
	 Filename:     	BotJoinMeetings.ps1
	===========================================================================
	.DESCRIPTION
		Run this script to autojoin your bot to the meetings you have setup. It is best to setup in a nighly job every 12 hours because of the time out of the bot. 
		
		Make sure to add APP Permissions for calling so the bot can join the meeting.
		Calls.JoinGroupCall.All
		Calls.JoinGroupCallAsGuest.All
#>


$ClientID = "" #Insert your ClientID
$ClientSecret = "" #Insert your ClientSecret
$TenantName = "" #your Contoso.mail.onmicrosoft.com 
$OrganizerID = "" #Instructions to decode on github. 
$TenantID = "" #tenantId

$ReqTokenBody = @{
    Grant_Type    = "client_credentials"
    Scope         = "https://graph.microsoft.com/.default"
    client_Id     = $clientID
    Client_Secret = $clientSecret
} 
$TokenResponse = Invoke-RestMethod -Uri "https://login.microsoftonline.com/$TenantName/oauth2/v2.0/token" -Method POST -Body $ReqTokenBody

#Examples Removed Characters for Testing Purposes fill replace with your Meeeting IDs

$array = @()
$array += "19:meeting_NTIyYjQwNGYtODdlZC00lLWE2Y2UtYTM1NTY2MzgwZDM2@thread.v2"
$array += "19:meeting_NDhkZTE5MWQtYmU0OC00MzBjLTk5OGzMyNjU4YTZlOGQ1@thread.v2"
$array += "19:meeting_OTQ2YTQyZDIk4Zi00ZTA3LWJiNTctMGI5ZGMxODAxYWQ4@thread.v2"
$array += "19:meeting_ZWZkMGRlYmMtZmRkYS00ZWZiLZGUtNmyYT2Q5ZmVhYjY0@thread.v2"
$array += "19:meeting_MzFhOWFmNmMtZWRhOS00YTQyLWEzY2UYzNGY1NWRmYjgz@thread.v2"
$array += "19:meeting_NmQ3OGU3MtMTRlNi00YzNkLThmZmMtOY0ZGVkZTFiYmJl@thread.v2"
$array += "19:meeting_OGIzNTkwZjAtNjc3ZC00ZGFhLTg5NZjg1ODE0ODNiY2Q0@thread.v2"
$array += "19:meeting_OTM2ZmY0YzItOGJhNy00YwL22TgzMtOGEyDcwODU3YjNj@thread.v2"
$array += "19:meeting_YjZmMWM0MWEtMzAxO0NW1QzLWI1M2NGE0OGQ1MDkyNTg1@thread.v2"
$array += "19:meeting_MmY4ZGI0YmIt3ODOC00YjEwLWJkYTgtMjNzUwNmZiYTg3@thread.v2"
$array += "19:meeting_ZTZlZGVhMWEtYTE5MS00ZjI2LThiMTYUzNWVjMWMxYzI5@thread.v2"
$array += "19:meeting_ZDc5MTQ1MzgtZDI5YS00MjAwLWJiNjAE1NzhkYjFiY2Nm@thread.v2"
$array += "19:meeting_ODdjZTZhOGYtNjhhYy00NTWI2MTYtMzBmMGQyMTM2ODY5@thread.v2"

Foreach($item in $Array)
{

	$RequestBody = '
	{
	  "@odata.type": "#microsoft.graph.call",
	  "callbackUri": "https://google.com/",
	  "tenantId": "$TenantID",
	  "meetingInfo": {
		"@odata.type": "#microsoft.graph.organizerMeetingInfo",
		"organizer": {
		  "@odata.type": "#microsoft.graph.identitySet",
		  "user": {
			"@odata.type": "#microsoft.graph.identity",
			"id": "$OrganizerID",
			"tenantId": "$TenantID"
		  }
		},
		"allowConversationWithoutHost": true
	   },
	  "mediaConfig": {
		"@odata.type": "#microsoft.graph.serviceHostedMediaConfig"
		},
	   "chatInfo": {
		"@odata.type": "#microsoft.graph.chatInfo",
		"threadId": "$item",
		"messageId": "0"
	  }
	}
	'	
	$RequestBody = $ExecutionContext.InvokeCommand.ExpandString($RequestBody)
 
	$GraphApiUrl = 'https://graph.microsoft.com/beta/communications/calls'
 
	Invoke-RestMethod -Headers @{Authorization = "Bearer $($Tokenresponse.access_token)" } -Uri $GraphApiUrl -Body $RequestBody -Method Post -ContentType 'application/json'
}
