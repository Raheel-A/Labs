'session2 shooter


Graphics 1000,800

'debugflag= this flag turns on selected debug code
' a CONST or constant is a vaule that cannot be reassigned
Const tron=False

'Unity Variables
Global unity_hypo:Int
Global unity_vector:vector2 = New Vector2

'setup projectile
Global bullet:projectile=New projectile
bullet.pos=New vector2
bullet.pos.x=GraphicsWidth()/2
bullet.pos.y=GraphicsHeight()/2
bullet.vel=New vector2
bullet.speed=5
bullet.rad=5
bullet.target=New vector2


'setup enemy
Global rock:enemy=New enemy
rock.pos=New vector2
rock.pos.x=GraphicsWidth()*0.75
rock.pos.y=GraphicsHeight()/2
rock.vel=New vector2
rock.vel.x=Rnd(-2,2)
rock.vel.y=Rnd(-2,2)
rock.rad=80
rock.speed=3


SetClsColor 211,222,222


Repeat
	Cls
	
	
	If MouseHit(1)
		bullet_set_vel(MouseX(),MouseY())
	EndIf
	
	update_bullet()
	update_rock()
	
	'check if the bullet has it the target
	Hit()
	
	'drawship
	SetColor 23,123,23
	DrawOval (GraphicsWidth()/2-5,GraphicsHeight()/2-5,10,10)
	
	
	'drawbullet
	SetColor 34,34,34
	DrawOval ( bullet.pos.x-bullet.rad , bullet.pos.y-bullet.rad , bullet.rad*2 , bullet.rad*2 )

	'draw rock
	SetColor 88,34,14
	DrawOval ( rock.pos.x-rock.rad , rock.pos.y-rock.rad , rock.rad*2 , rock.rad*2 )
	
	
	
Flip

Until KeyDown(KEY_ESCAPE) Or AppTerminate()


End
'=============================================
'student code

Function bullet_set_vel(tx:Int,ty:Int)
	'debug code stores the target postion
	bullet.target.x=tx
	bullet.target.y=ty

	'set position back to the centre
	bullet.pos.x=GraphicsWidth()/2
	bullet.pos.y=GraphicsHeight()/2
	
	'calcuate the velocity for vector bullet.vel
	bullet.vel.x = bullet.pos.x - bullet.target.x
	bullet.vel.y = bullet.pos.y - bullet.target.y
	
	unity_hypo = Sqr(bullet.vel.x^2 + bullet.vel.y^2)
	
	unity_vector.x = (bullet.vel.x / unity_hypo) * bullet.speed
	unity_vector.y = (bullet.vel.y / unity_hypo) * bullet.speed
	
	
	
End Function

Function update_bullet()
	'update the position of the bullet bullet.pos using bullet.vel
	
	bullet.pos.x = bullet.pos.x - unity_vector.x
	bullet.pos.y = bullet.pos.y - unity_vector.y
	
	'debug code is useful in real time systems
	'this reports the nearest true positon of the bullet to the target
	If tron
		If Abs(bullet.target.x-bullet.pos.x)<bullet.speed And Abs(bullet.target.y-bullet.pos.y)<bullet.speed
			DebugLog "TR"
			DebugLog "bullet.pos.x="+bullet.pos.x+"~t~t target.x="+bullet.target.x
			DebugLog "bullet.pos.y="+bullet.pos.y+"~t~t target.y="+bullet.target.y
		EndIf 
	EndIf
	
	hit()
	
End Function

Function update_rock()
	'update the rock position rock.pos using rock.vel
	
	rock.pos.x = rock.pos.x + rock.vel.x
	rock.pos.y = rock.pos.y + rock.vel.y

	'it is possible to call function from within other functions
	' rock_OutOfBounds() should check if the rock has left the screen	
	rock_OutOfBounds()	
	
End Function

Function rock_OutOfBounds()
	'if the rock.pos is more than graphicswidth()/2 from the screen centre then make a new pos and vel
	'must calculate the distance (magnitude of the vector) between rock.pos and graphicswidth()/2,graphicsheight()/2
	
	local_rock_x = Abs(GraphicsWidth()/2 - rock.pos.x) - rock.rad -1
	local_rock_y = Abs(GraphicsHeight()/2 - rock.pos.y) - rock.rad -1
	
	If (local_rock_x >=GraphicsWidth()/2 Or local_rock_y >=GraphicsHeight()/2)
	rock_respawn()
	'If False ' create a test 
		'generate new pos and vel
		'rock_respawn()
	EndIf
	
End Function

Function rock_respawn()
		'generates new values for the rock.pos and the rock.vel
		rock.pos.x=Rand(0,GraphicsWidth()-1)
		rock.vel.x=Rnd(-2,2)
		rock.pos.y=Rand(0,GraphicsHeight()-1)
		rock.vel.y=Rnd(-2,2)	
End Function

Function hit()
	'given the position of the bullet (bullet.pos) and the positon and radius of the rock (rock.pos and rock.rad)
	Local bullet_
	If ((rock.pos.x - bullet.pos.x)^2 + (rock.pos.y - bullet.pos.y)^2 <= (rock.rad + bullet.rad)^2)
	
	'detect if the bullet has hit the rock
	rock_respawn()
	
	EndIf
End Function



'=============================
'type definition


'the vector type is used by other types
' the vector type is 2d (vector2) and contains x and y
'the vector is a complex number
Type vector2
	Field x:Float
	Field y:Float
End Type

'the projectile type is a template with position, velocity, speed, radius,
'pos, vel, target, are all vector2 which is a user defined type
'speed and rad, are scalars
'target is a debug vector that stores the mouse click postion
Type projectile
	Field pos:vector2
	Field vel:vector2
	Field speed:Float
	Field rad:Float
	'degbug only
	Field target:vector2
End Type

' the enemy type is a template with position, velocity, speed and size.
Type enemy
	Field pos:vector2
	Field vel:vector2
	Field speed:Float
	Field rad:Float
End Type	




