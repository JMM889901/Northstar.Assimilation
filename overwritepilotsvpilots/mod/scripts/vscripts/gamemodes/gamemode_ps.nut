global function GamemodePs_Init

void function GamemodePs_Init()
{
	Riff_ForceTitanAvailability( eTitanAvailability.Never )

	AddCallback_OnPlayerKilled( GiveScoreForPlayerKill )
	ScoreEvent_SetupEarnMeterValuesForMixedModes()
	SetTimeoutWinnerDecisionFunc( CheckScoreForDraw )

}
void function GiveScoreForPlayerKill( entity victim, entity attacker, var damageInfo )
{
	print(victim)
	print(attacker)
    if ( !victim.IsPlayer() || !attacker.IsPlayer() || GetGameState() != eGameState.Playing )
	{
        return
	}
	if ( attacker == victim ) // suicide
	{
		string message = victim.GetPlayerName() + " committed suicide."
		foreach ( entity player in GetPlayerArray() )
			SendHudMessage( player, message, -1, 0.4, 255, 0, 0, 0, 0, 3, 0.15 )
			
	}
	else 
	{
            AddTeamScore( attacker.GetTeam(), 1 )
            attacker.AddToPlayerGameStat( PGS_ASSAULT_SCORE, 1 )
            foreach ( entity weapon in attacker.GetMainWeapons() )
                attacker.TakeWeaponNow( weapon.GetWeaponClassName() )
    
            foreach ( entity weapon in attacker.GetOffhandWeapons() )
                attacker.TakeWeaponNow( weapon.GetWeaponClassName() )
            
	    attacker.GiveOffhandWeapon( victim.GetOffhandWeapon( OFFHAND_MELEE ).GetWeaponClassName(), OFFHAND_MELEE )
            attacker.GiveOffhandWeapon( victim.GetOffhandWeapon( OFFHAND_LEFT ).GetWeaponClassName(), OFFHAND_LEFT )
 	    attacker.GiveOffhandWeapon( victim.GetOffhandWeapon( OFFHAND_RIGHT ).GetWeaponClassName(), OFFHAND_RIGHT )
	    foreach ( entity weapon in victim.GetMainWeapons() )
		{
		attacker.GiveWeapon( weapon.GetWeaponClassName(), weapon.GetMods() )
		}
}
}


int function CheckScoreForDraw()
{
	if (GameRules_GetTeamScore(TEAM_IMC) > GameRules_GetTeamScore(TEAM_MILITIA))
		return TEAM_IMC
	else if (GameRules_GetTeamScore(TEAM_MILITIA) > GameRules_GetTeamScore(TEAM_IMC))
		return TEAM_MILITIA

	return TEAM_UNASSIGNED
}
