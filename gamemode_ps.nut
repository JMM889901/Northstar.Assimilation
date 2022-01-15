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
	if ( victim != attacker && victim.IsPlayer() && attacker.IsPlayer() || GetGameState() != eGameState.Playing )
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
            attacker.GiveWeapon( victim.GetMainWeapons()[0].GetWeaponClassName() )
            attacker.GiveWeapon( victim.GetMainWeapons()[1].GetWeaponClassName() )
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
