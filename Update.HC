
U0 SlugPlrCollision(Collider *a)
{
  Slug *temp = slug_que.next;
  while(temp != &slug_que)
  {
    Slug *next = temp->next;
    if(plr.myCollider == a)
    {
      goto col_cont;
    }
    if(plr.footCol == a)
    {
      goto col_cont;
    }
    if(temp->myCol != a)
    {
      goto col_cont;
    }

    if(AABBCollision(plr.footCol, temp->myCol))
    {
      if(plr.vel.y > 0)
      {
        plr.vel.y = -8;
        NewParticle(temp->myCol->pos.x,
        temp->myCol->pos.y,
        temp->curSprite,
        0,
        -8);
        DelSlug(temp);
        return;
        
      }
    }

    if(AABBCollision(plr.myCollider, temp->myCol))
    {
      PlayerDie;
    }
    col_cont:
    temp = next;
  }
}

U0 TurtlePlrCollision(Collider *a)
{
  Turtle *temp = turtle_que.next;
  while(temp != &turtle_que)
  {
    Turtle *next = temp->next;

    if(plr.myCollider == a)
      goto cont;
    if(plr.footCol == a)
      goto cont;
    if(temp->myCol != a)
      goto cont;

    if(AABBCollision(plr.footCol, temp->myCol))
    {
      if(plr.vel.y > 0)
      {
	plr.vel.y = -10;
	temp->Health = 0;
        return;
      }
    }


    if(AABBCollision(plr.myCollider, temp->myCol))
    {
      PlayerDie;
    }

    cont:
    temp = next;
  }
}

U0 TShellPlrCollision(Collider *a)
{
  TShell *temp = tshell_que.next;
  while(temp != &tshell_que)
  {
    TShell *next = temp->next;
    if(plr.myCollider == a)
      goto cont;
    if(plr.footCol == a)
      goto cont;
    if(temp->myCol != a)
      goto cont;

    if(AABBCollision(plr.footCol, temp->myCol))
    {
      if(plr.vel.y > 0)
      {
        plr.vel.y = -10;
	temp->Health = 0;
	return;
      }
    }

    if(AABBCollision(plr.myCollider, temp->myCol))
    {
      PlayerDie;
    }

    cont:
    temp = next;
  }
}


U0 UpdateCam()
{
  if(plr.myCollider->pos.x > 320)
  {
  camOffset.x = plr.myCollider->pos.x - 320;
  }
  else{
  camOffset.x = 0;
  }
  camOffset.y = 0;
}


U0 UpdatePlrMove()
{


  plrCol.isColTop = FALSE;
  plrCol.isColBottom = FALSE;
  plrCol.isColLeft = FALSE;
  plrCol.isColRight = FALSE;

  if(plr.powerUp != 0)
  {
    Bool isAboveMe = isAbovePlayer;
    if(keys.down && plr.grounded)
    {
      plr.ducking = TRUE;
    }
    else if(!isAboveMe)
    {
      plr.ducking = FALSE;
    }
  }

  isAboveMe = isAbovePlayer;
  if(isAboveMe && plr.ducking)
  {
    if(keys.left && plr.ducking)
    {
      plr.vel.x = -1.5;
      plr.isLookingRight = FALSE;
    }
    if(keys.right && plr.ducking)
    {
      plr.vel.x = 1.5;
      plr.isLookingRight = TRUE;
    }
  }

  if(plr.ducking && plr.powerUp != 0)
  {
    F64 oldSizeY = plr.myCollider->size.y;
    plr.myCollider->size.y = 22;
    F64 newSizeY = plr.myCollider->size.y;
    plr.myCollider->pos.y -= newSizeY - oldSizeY;
  }
  else if(!plr.ducking && plr.powerUp != 0)
  {
    oldSizeY = plr.myCollider->size.y;
    plr.myCollider->size.y = PLR_BIG_SIZE_Y;
    newSizeY = plr.myCollider->size.y;
    plr.myCollider->pos.y -= newSizeY - oldSizeY;
  }

  if(keys.shift && !plr.isJumping)
  {
    plr.acceleration = 2.0;
  }
  else if(!keys.shift && !plr.isJumping)
  {
    plr.acceleration = 1.5;
  }

  if(plr.isJumping && !keys.shift)
  {
    plr.vel.x /= FRICTION * 1.05;
  }

  if(keys.left && !plr.ducking)
  {
    plr.vel.x -= plr.acceleration;
    plr.isLookingRight = FALSE;
    plr.isWalking = TRUE;
  }
  if(keys.right && !plr.ducking)
  {
    plr.vel.x += plr.acceleration;
    plr.isLookingRight = TRUE;
    plr.isWalking = TRUE;
  }

  if(!plr.ducking)
  {
    plr.vel.x /= FRICTION;
  }
  else
  {
    plr.vel.x *= 0.95; 
  }

  if(Abs(plr.vel.x) < 0.1)
  {
    plr.vel.x = 0;
  }

  if(Abs(plr.vel.x) < 1)
  {
    plr.isWalking = FALSE;
  }

  plr.myCollider->pos.x += plr.vel.x;
  // X Axis collision
  Collider *temp = collider_que.next;
  while(temp != &collider_que)
  {
    Collider *next = temp->next;
    if(temp != plr.myCollider && AABBCollision(plr.myCollider, temp) && temp->type == 2)
    {

      if(plr.vel.x > 0)
      {
        plr.myCollider->pos.x = temp->pos.x - plr.myCollider->size.x;
        plrCol.isColRight = TRUE;
      }
      else
      {
	plr.myCollider->pos.x = temp->pos.x + temp->size.x;
        plrCol.isColLeft = TRUE;
      }
      plr.vel.x = 0;
      plr.isWalking = FALSE;
      goto colx_continue;
    }

    if(temp != plr.myCollider)
    {
      if(temp->type == ENEMY_COLLIDER)
      {
        SlugPlrCollision(temp);
        TurtlePlrCollision(temp);
      }
      if(temp->type == TSHELL_COLLIDER)
      {
	TShellPlrCollision(temp);
      }
    }
    colx_continue:
    temp = next;
  }
  plr.vel.y += plr.gravity;

  if(Abs(plr.vel.y) < 0.1)
  {
    plr.vel.y = 0;
  }


  if(plr.vel.y > 15)
  {
    plr.vel.y = 15;
  }

  plr.myCollider->pos.y += plr.vel.y;
  // Y Axis collision
  temp = collider_que.next;
  while(temp != &collider_que)
  {
    next = temp->next;
    if(temp != plr.myCollider && AABBCollision(plr.myCollider, temp) && temp->type == 2)
    {
      if(plr.vel.y > 0)
      {
        plr.myCollider->pos.y = temp->pos.y - plr.myCollider->size.y;
	plrCol.isColBottom = TRUE;
        plr.grounded = TRUE;

      }
      else
      {
        plrCol.isColTop = TRUE;
   	plr.myCollider->pos.y = temp->pos.y + temp->size.y;
      }
      plr.vel.y = 0;
    }
    temp = next;
  }
  if(!plr.grounded)
  {
    plr.isJumping = TRUE;
  }
  if(plr.vel.y != 0)
  {
    plr.grounded = FALSE;
  }
  if(keys.up && plr.grounded)
  {
    plr.vel.y = -12;
    plr.grounded = FALSE;
    plr.isJumping = TRUE;
  }
  if(keys.shift)
  {
    plr.walk_frameSpeedReset = 2;
  }
  else
  {
    plr.walk_frameSpeedReset = 3;
  }
  if(plr.grounded)
  {
    plr.isJumping = FALSE;
  }
  // jumping higher when holding jump
  if(keys.up && plr.vel.y < 0)
  {
    plr.gravity = 0.8;
  }
  else
  {
    plr.gravity = 1.5;
  }

  if(plr.myCollider->pos.y >= 500)
  {
    PlayerDie;
  }
  plr.headCol->pos.x = plr.myCollider->pos.x;
  plr.headCol->pos.y = plr.myCollider->pos.y - 5;
  plr.footCol->pos.x = plr.myCollider->pos.x + 2;
  plr.footCol->pos.y = plr.myCollider->size.y + plr.myCollider->pos.y;
  
}

CDC *GetPlayerWalkSprite(I8 frameNumber)
{
  if(plr.powerUp == 1)
  {
    if(plr.isLookingRight)
    {
      if(plr.ducking)
      {
	return tex_PMan_Big_DuckRight;
      }
      switch(frameNumber)
      {
        case 1: return tex_PMan_Big_Walk1Right; break;
        case 2: return tex_PMan_Big_Walk2Right; break;
        case 3: return tex_PMan_Big_Walk3Right; break;
      }
      return tex_PMan_Big_IdleRight;
    }
    else
    {
      if(plr.ducking)
      {
	return tex_PMan_Big_DuckLeft;
      }
      switch(frameNumber)
      {
        case 1: return tex_PMan_Big_Walk1Left; break;
        case 2: return tex_PMan_Big_Walk2Left; break;
        case 3: return tex_PMan_Big_Walk3Left; break;
      }
      return tex_PMan_Big_IdleLeft;
    }
    return tex_PMan_Big_IdleRight;
  }
  else
  {
    if(plr.isLookingRight)
    {
      switch(frameNumber)
      {
        case 1: return tex_PMan_Walk1Right; break;
        case 2: return tex_PMan_Walk2Right; break;
        case 3: return tex_PMan_Walk3Right; break;
      }
      return tex_PMan_IdleRight;
    }
    else
    {
      switch(frameNumber)
      {
        case 1: return tex_PMan_Walk1Left; break;
        case 2: return tex_PMan_Walk2Left; break;
        case 3: return tex_PMan_Walk3Left; break;
      }
      return tex_PMan_IdleLeft;
    }
    return tex_PMan_IdleRight;

  }
}

CDC *GetPlayerIdleSprite()
{
  if(plr.powerUp == 1)
  {
    if(plr.isLookingRight)
    {
      if(plr.ducking)
      {
	return tex_PMan_Big_DuckRight;
      }
      return tex_PMan_Big_IdleRight;
    }
    else
    {
      if(plr.ducking)
      {
	return tex_PMan_Big_DuckLeft;
      }
      return tex_PMan_Big_IdleLeft;
    }
  }
  else
  {
    if(plr.isLookingRight)
    {
      return tex_PMan_IdleRight;
    }
    else
    {
      return tex_PMan_IdleLeft;
    }
    return tex_PMan_IdleLeft;
  }
}

CDC *GetPlayerJumpSprite()
{
  if(plr.powerUp == 1)
  {
    if(plr.isLookingRight)
    {
      if(plr.ducking)
      {
	return tex_PMan_Big_DuckRight;
      }
      return tex_PMan_Big_JumpRight;
    }
    else
    {
      if(plr.ducking)
      {
	return tex_PMan_Big_DuckLeft;
      }
      return tex_PMan_Big_JumpLeft;
    }
  }
  else
  {
    if(plr.isLookingRight)
    {
      return tex_PMan_JumpRight;
    }
    else
    {
      return tex_PMan_JumpLeft;
    }
    return tex_PMan_IdleLeft;
  }

}


U0 UpdatePlayerAnimation()
{
   plr.curSprite = GetPlayerIdleSprite;
  if(plr.isWalking && !plr.isJumping)
  {
    plr.walk_frameSpeed--;
    if(plr.walkFrame > 3)
    {
      plr.walkFrame = 1;
    }
    if(plr.walk_frameSpeed <= 0)
    {
      plr.walkFrame++; 
      plr.walk_frameSpeed = plr.walk_frameSpeedReset;
    }

    plr.curSprite = GetPlayerWalkSprite(plr.walkFrame);
  }
  if(plr.isJumping)
  {
    plr.curSprite = GetPlayerJumpSprite;
  }
 

}

U0 UpdateMousePos()
{
  g_MouseX = ms.pos.x;
  g_MouseY = ms.pos.y;
}

Bool CheckBulletCollision(Bullet *bullet)
{
  Collider *temp = collider_que.next;
  while(temp != &collider_que)
  {
    Collider *next = temp->next;
    if(temp != bullet->myCollider && AABBCollision(bullet->myCollider, temp) && temp->type == 2)
    {
      // DelBullet(bullet);
      return TRUE;
    }
    temp = next;
  }
  return FALSE;
}

U0 UpdateBullets()
{
  Bullet *temp = bullet_que.next;
  while(temp != &bullet_que)
  {
    Bool delete = FALSE;
    Bullet *next = temp->next;
    temp->myCollider->pos.x += temp->vel.x;
    temp->myCollider->pos.y += temp->vel.y;
    if(CheckBulletCollision(temp))
    {
      delete = TRUE;
    }
    if(temp->myCollider->pos.x - camOffset.x > 640)
    {
      delete = TRUE;
    }
    else if(temp->myCollider->pos.x - camOffset.x < 0)
    {
      delete = TRUE;
    }
    else if(temp->myCollider->pos.y - camOffset.y > 480)
    {
      delete = TRUE;
    }
    else if(temp->myCollider->pos.y - camOffset.y < 0)
    {
      delete = TRUE;
    }
    if(delete)
    {
      DelBullet(temp);
    }
    temp = next;
  }
}



// Enemy Logic

U0 EnemyCollisions(Enemy *a, Bool yAxis = FALSE)
{

  // Ignore if enemy marked for death
  if(a->Health <= 0) return;

  // X axis collision loop
  Collider *temp = collider_que.next;
  while(temp != &collider_que)
  {
    Collider *next = temp->next;
    if(temp == plr.myCollider || temp == plr.footCol)
    {
      goto enemy_continue;
    }
    if(temp == a->myCol)
    {      
      goto enemy_continue;
    }

    if(a->myCol->type == ENEMY_COLLIDER && temp->type == ENEMY_COLLIDER)
    {
      goto enemy_shell_cont;
    }

    if(a->myCol->type == TSHELL_COLLIDER || temp->type == TSHELL_COLLIDER)
    {
      goto enemy_shell_cont;
    }
 

    if(temp->type != WALL_COLLIDER)
    {
      goto enemy_continue;
    }


    enemy_shell_cont:

    if(AABBCollision(a->myCol, temp))
    {

      if(a->myCol->type == ENEMY_COLLIDER && temp->type == ENEMY_COLLIDER)
      {
	goto bounceOff;
      }

      if(a->myCol->type == TSHELL_COLLIDER && temp->type == ENEMY_COLLIDER)
      {
	Enemy *e_temp = slug_que.next;
	while(e_temp != &slug_que)
	{
	   Enemy *e_next = e_temp->next;
	   if(e_temp->myCol == temp)
	   {
	     e_temp->Health = 0;
	     return;
	   }
	   e_temp = e_next;
	}
	e_temp = turtle_que.next;
	while(e_temp != &turtle_que)
	{
	   e_next = e_temp->next;
	   if(e_temp->myCol == temp)
	   {
	     e_temp->Health = 0;
	     return;
	   }
	   e_temp = e_next;
	}
	return;
      }

      if(a->myCol->type == ENEMY_COLLIDER && temp->type == TSHELL_COLLIDER)
      {
	a->Health = 0;
	return;
      }

      if(a->myCol->type == TSHELL_COLLIDER && temp->type == TSHELL_COLLIDER)
      {
        a->Health = 0;
        TShell *shell_temp = tshell_que.next;
	while(shell_temp != &tshell_que)
	{
	   TShell *shell_next = shell_temp->next;
	   if(shell_temp->myCol == temp)
	   {
	     shell_temp->Health = 0;
	     break;
	   }
	   shell_temp = shell_next;
	}
	return;
      }


      bounceOff:
      if(!yAxis)
      {
	if(a->vel.x < 0)
	{
          a->myCol->pos.x = temp->pos.x + temp->size.x;
	}
	else
	{
          a->myCol->pos.x = temp->pos.x - a->myCol->size.x;
	}
	a->isLookingRight = !a->isLookingRight;
        goto enemy_continue;
      }
      else
      {
 	if(a->vel.y < 0)
	{
	  a->myCol->pos.y = temp->pos.y - a->myCol->size.y;
	}
	 else
	{
	  a->myCol->pos.y = temp->pos.y - a->myCol->size.y;
	}
	a->vel.y = 0;
      }

    }
    enemy_continue:
    temp = next;
  }
}



U0 UpdateEnemy(Enemy *a)
{ 
  if(!a->active)
  {
    if(a->myCol->pos.x - camOffset.x < 640)
    {
      a->active = TRUE;
    }
    else
    {
      return;
    }
  }
  if(a->isLookingRight)
  {
    a->vel.x = a->speed;
  }
  else
  {
    a->vel.x = -a->speed;
  }
  a->myCol->pos.x += a->vel.x;
  EnemyCollisions(a);
  a->vel.y += GRAVITY; 
  a->myCol->pos.y += a->vel.y;
  EnemyCollisions(a, TRUE);
}

CDC GetSlugSprite(Slug *a)
{
  if(a->isLookingRight)
  {
    switch(a->curFrame)
    {
      default: return tex_Slug_Walk1Right; break;
      case 1: return tex_Slug_Walk1Right; break;
      case 2: return tex_Slug_Walk2Right; break;
    }
  }
  else
  {
    switch(a->curFrame)
    {
      default: return tex_Slug_Walk1Left; break;
      case 1: return tex_Slug_Walk1Left; break;
      case 2: return tex_Slug_Walk2Left; break;
    }
  }
}

U0 UpdateSlugAnimation(Slug *a)
{
  a->walk_frameSpeed--;
  a->curSprite = GetSlugSprite(a);
  if(a->curFrame > 2)
  {
    a->curFrame = 1;
  }
  if(a->walk_frameSpeed <= 0)
  {
    a->walk_frameSpeed = 5;
    a->curFrame++;
  } 
}

U0 UpdateSlugs()
{
  Slug *temp = slug_que.next;
  while(temp != &slug_que)
  {
    Slug *next = temp->next;
    UpdateEnemy(temp);
    UpdateSlugAnimation(temp);
    if(temp->Health <= 0)
    {
      NewParticle(temp->myCol->pos.x,
      temp->myCol->pos.y,
      temp->curSprite);
      DelSlug(temp);
      goto slug_nxt;
    }
    slug_nxt:
    temp = next;
  }
}



U0 UpdateParticles()
{
  Particle *temp = particle_que.next;
  while(temp != &particle_que)
  {
    Particle *next = temp->next;
    temp->pos.x += temp->vel.x;
    temp->vel.y += GRAVITY;
    temp->pos.y += temp->vel.y;
    if(temp->pos.y - camOffset.y > 500)
      DelParticle(temp);
    temp = next;
  }
}


CDC *GetTurtleSprite(Turtle *a)
{
  if(a->isLookingRight)
  {
    switch(a->curFrame)
    {
      default: return tex_Turtle_Walk1Right; break;
      case 1: return tex_Turtle_Walk1Right; break;
      case 2: return tex_Turtle_Walk2Right; break;
    }
  }
  else
  {
    switch(a->curFrame)
    {
      default: return tex_Turtle_Walk1Left; break;
      case 1: return tex_Turtle_Walk1Left; break;
      case 2: return tex_Turtle_Walk2Left; break;
    }
  }
}

U0 UpdateTurtleAnimation(Turtle *a)
{
  a->walk_frameSpeed--;
  a->curSprite = GetTurtleSprite(a);
  if(a->curFrame > 2)
  {
    a->curFrame = 1;
  }
  if(a->walk_frameSpeed <= 0)
  {
    a->walk_frameSpeed = 10;
    a->curFrame++;
  }
}

U0 UpdateTurtles()
{
  Turtle *temp = turtle_que.next;
  while(temp != &turtle_que)
  {
    Turtle *next = temp->next;
    UpdateEnemy(temp);
    UpdateTurtleAnimation(temp);
    if(temp->Health <= 0)
    {
      NewTShell(temp->myCol->pos.x,
      temp->myCol->pos.y,
      temp->isLookingRight);
      DelTurtle(temp);
      goto turtle_nxt;
    }
    turtle_nxt:
    temp = next;
  }
}

U0 UpdateTShells()
{
  TShell *temp = tshell_que.next;
  while(temp != &tshell_que)
  {
    TShell *next = temp->next;
    UpdateEnemy(temp);
    if(temp->Health <= 0)
    {
      NewParticle(temp->myCol->pos.x,
      temp->myCol->pos.y,
      temp->curSprite);
      DelTShell(temp);
      goto tshell_nxt;
    }
    tshell_nxt:

    temp = next;
  }
}


// Sorry for this global variable
// Amount of cycles of immune flash to become no longer immune
// Should be 4
// This was a bad idea, couldnt really set it in globals
//I8 immuneOver = 0;

U0 UpdatePlayerImmune()
{
  if(plr.immuneCycles >= 15)
  {
    plr.immune = FALSE;
    plr.immuneFlash = FALSE;
    plr.immuneCycles = 0;
  }
  if(plr.immune)
  {
    plr.immuneTimer--;
    if(plr.immuneTimer <= 0)
    {
      plr.immuneFlash = !plr.immuneFlash;
      plr.immuneTimer = 5;
      plr.immuneCycles++;
    }
  }
}

U0 UpdatePauseTimer()
{
  if(g_Paused)
  {
    plr.pauseTimer--;
    if(plr.pauseTimer <= 0)
    {
      g_Paused = FALSE;
      plr.pauseTimer = 15;      
    }
  }
}
