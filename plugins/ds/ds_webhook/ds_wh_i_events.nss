// -----------------------------------------------------------------------------
//    File: ds_wh_i_events.nss
//  System: Webhooks (events)
// -----------------------------------------------------------------------------
// Description:
//  Event functions for PW Subsystem.
// -----------------------------------------------------------------------------
// Builder Use:
//  None!  Leave me alone.
// -----------------------------------------------------------------------------

#include "ds_wh_i_main"

// -----------------------------------------------------------------------------
//                              Function Prototypes
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
//                             Function Definitions
// -----------------------------------------------------------------------------

void webhook_OnModuleLoad()
{
    string sTitle = "Dark Sun: Sands of Time is starting!";
    string sDescription = "The Sands of Time server is starting up.  Once the module is stable and ready for " +
        "players to login, we'll let you know.  Note: the normal password will not work until the server is " +
        "stable.  Once the server is stable, the standard password will be restored.";
    string sUserName = "DM Tiny";
    string sThumbnail = (d2() == 1 ? LOGO : HAPPYBABY);
    
    ModuleEventWebhook(sTitle, sDescription, sUserName, sThumbnail);
}

void webhook_OnModuleShutdown()
{
    string sTitle = "Dark Sun: Sands of Time is shutting down!";
    string sDescription = "The Sands of Time server is shutting down for maintenance.  Once the module is ready " +
        "for play again, which will be shortly, we'll let you know here.";
    string sUserName = "DM Tiny";
    string sThumbnail = (d2() == 1 ? LOGO : CRYBABY);
    
    ModuleEventWebhook(sTitle, sDescription, sUserName, sThumbnail);
}

void webhook_OnModuleStable()
{
    string sTitle = "Dark Sun: Sands of Time is ready!";
    string sDescription = "The Sands of Time server is ready for players to login.  Come one, come all!";
    string sUserName = "DM Tiny";
    
    ModuleEventWebhook(sTitle, sDescription, sUserName, LOGO);
}

void webhook_OnClientEnter()
{
    object oPC = GetEnteringObject();
    LogWebhook(oPC, LOG_IN);
    LogDetailedWebhook(oPC, LOG_IN);
}

void webhook_OnClientLeave()
{
    object oPC = GetExitingObject();
    LogWebhook(oPC, LOG_OUT);
    LogDetailedWebhook(oPC, LOG_OUT);
}

void webhook_OnQuestEvent()
{
    object oPC = OBJECT_SELF;
    SendQuestWebhookMessage(oPC);
}

void webhook_OnPlayerDeath()
{

}

void webhook_OnPlayerDying()
{

}

void webhook_OnPlayerReSpawn()
{

}

void webhook_OnPlayerLevelUp()
{

}

void webhook_OnPlayerChat()
{
    object oPC = GetPCChatSpeaker();
    if (_GetIsDM(oPC))
        DMChatWebhook();


}

void webhook_OnPlayerChatCommand()
{
    object oPC = GetPCChatSpeaker();
    ChatCommandWebhook(oPC);
}

void webhook_OnModuleDebug()
{
    int nLevel = GetArgumentInt();
    string sMessage = GetArgumentString();
    object oTarget = OBJECT_SELF;

    DebugWebhook(nLevel, sMessage, oTarget);
}

void webhook_OnHour()
{
    // Period is (nPeriod + 1) * 2 minutes (10 = 22 minutes, 14 = 30 minutes)
    // or -- nPeriod = (Desired Interval) / 2 - 1
    int nPeriod = 10;

    int nHourCount = GetLocalInt(GetModule(), "WEBHOOK_HOUR_COUNT");
    if (nHourCount >= nPeriod)
    {
        CultureWebhook();
        DeleteLocalInt(GetModule(), "WEBHOOK_HOUR_COUNT");
    }
    else
        SetLocalInt(GetModule(), "WEBHOOK_HOUR_COUNT", ++nHourCount);
}
