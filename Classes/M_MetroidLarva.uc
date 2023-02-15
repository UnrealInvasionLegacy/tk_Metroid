class M_MetroidLarva extends tk_Monster;

#EXEC OBJ LOAD FILE="Resources/tk_Metroid_rc.u" PACKAGE="tk_Metroid"

var name DeathAnims[3];
var bool bLunging;

function SetMovementPhysics()
{
	SetPhysics(PHYS_Falling); 
}

simulated function PlayDirectionalDeath(Vector HitLoc)
{
	PlayAnim(DeathAnims[Rand(3)], 0.7, 0.1);
}

simulated function PlayDirectionalHit(Vector HitLoc)
{
	TweenAnim('HitF', 0.05);
}

function PlayVictory()
{
	Controller.bPreparingMove = true;
	Acceleration = vect(0,0,0);
	bShotAnim = true;
	PlayAnim('ThroatCut', 1.0, 0.1);
	Controller.Destination = Location;
	Controller.GotoState('TacticalMove','WaitForAnim');
}

singular function Bump(actor Other)
{
	local name Anim;
	local float frame,rate;
	
	if ( bShotAnim && bLunging )
	{
		bLunging = false;
		GetAnimParams(0, Anim,frame,rate);
		if ( Anim == 'JumpF_Mid' )
			MeleeDamageTarget(20, (20000.0 * Normal(Controller.Target.Location - Location)));
	}		
	Super.Bump(Other);
}

function RangedAttack(Actor A)
{
	local float Dist;
	
	if ( bShotAnim )
		return;
		
	Dist = VSize(A.Location - Location);
	if ( Dist > 350 )
		return;
	bShotAnim = true;
	PlaySound(ChallengeSound[Rand(4)], SLOT_Interact);
	if ( Dist < MeleeRange + CollisionRadius + A.CollisionRadius )
	{
  		if ( FRand() < 0.5 )
  			SetAnimAction('ThroatCut');
  		else
  			SetAnimAction('Weapon_Switch');
		MeleeDamageTarget(20, vect(0,0,0));
		Controller.bPreparingMove = true;
		Acceleration = vect(0,0,0);
		return;
	}
	
	// lunge at enemy
	bLunging = true;
	Enable('Bump');
	SetAnimAction('JumpF_Mid');
	Velocity = 500 * Normal(A.Location + A.CollisionHeight * vect(0,0,0.75) - Location);
	if ( dist > CollisionRadius + A.CollisionRadius + 35 )
		Velocity.Z += 0.7 * dist;
	SetPhysics(PHYS_Falling);
}

defaultproperties
{
     DeathAnims(0)="DeathF"
     DeathAnims(1)="DeathB"
     DeathAnims(2)="DeathL"
     bAlwaysStrafe=True
     HitSound(0)=Sound'tk_Metroid.Metroid.Metroid_Geep_Low'
     HitSound(1)=Sound'tk_Metroid.Metroid.Metroid_Geep_Low'
     HitSound(2)=Sound'tk_Metroid.Metroid.Metroid_Geep_Low'
     HitSound(3)=Sound'tk_Metroid.Metroid.Metroid_Geep_Low'
     DeathSound(0)=Sound'tk_Metroid.Metroid.squeehee'
     DeathSound(1)=Sound'tk_Metroid.Metroid.squee'
     DeathSound(2)=Sound'tk_Metroid.Metroid.squeehee'
     DeathSound(3)=Sound'tk_Metroid.Metroid.squee'
     ChallengeSound(0)=Sound'tk_Metroid.Metroid.Metroid_Geep_High'
     ChallengeSound(1)=Sound'tk_Metroid.Metroid.Metroid_Geep_Double'
     ChallengeSound(2)=Sound'tk_Metroid.Metroid.Metroid_Geep_High'
     ChallengeSound(3)=Sound'tk_Metroid.Metroid.Metroid_Geep_Double'
     IdleHeavyAnim="Idle_Biggun"
     IdleRifleAnim="Idle_Rifle"
     bCrawler=True
     MeleeRange=25.000000
     GroundSpeed=400.000000
     WaterSpeed=300.000000
     JumpZ=450.000000
     Health=60
     MovementAnims(0)="WalkF"
     MovementAnims(1)="WalkB"
     MovementAnims(2)="WalkL"
     MovementAnims(3)="WalkR"
     TurnLeftAnim="TurnR"
     TurnRightAnim="TurnL"
     SwimAnims(0)="SwimB"
     SwimAnims(1)="SwimF"
     WalkAnims(0)="WalkR"
     WalkAnims(1)="WalkL"
     WalkAnims(2)="WalkB"
     WalkAnims(3)="WalkF"
     AirAnims(0)="Jump_Mid"
     AirAnims(1)="Jump_Mid"
     AirAnims(2)="Jump_Mid"
     AirAnims(3)="Jump_Mid"
     TakeoffAnims(0)="Jump_Takeoff"
     TakeoffAnims(1)="Jump_Takeoff"
     TakeoffAnims(2)="Jump_Takeoff"
     TakeoffAnims(3)="Jump_Takeoff"
     LandAnims(0)="Jump_Land"
     LandAnims(1)="Jump_Land"
     LandAnims(2)="Jump_Land"
     LandAnims(3)="Jump_Land"
     DoubleJumpAnims(0)="DoubleJumpB"
     DoubleJumpAnims(1)="DoubleJumpF"
     DoubleJumpAnims(2)="DoubleJumpL"
     DoubleJumpAnims(3)="DoubleJumpR"
     DodgeAnims(0)="DodgeB"
     DodgeAnims(1)="DodgeF"
     DodgeAnims(2)="DodgeL"
     DodgeAnims(3)="DodgeR"
     AirStillAnim="Jump_Mid"
     TakeoffStillAnim="Jump_Takeoff"
     IdleWeaponAnim="idle_chat"
     Mesh=SkeletalMesh'tk_Metroid.MetroidLarva'
     Skins(0)=Texture'tk_Metroid.Metroid.MetroidBody'
     Skins(1)=Shader'tk_Metroid.Metroid.MetroidGlass'
     Mass=80.000000
}
