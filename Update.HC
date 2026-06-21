
U0 UpdateCam()
{
  if(plr.myCollider->pos.x > 320)
  {
  camOffset.x = plr.myCollider->pos.x - 320;
  }
  camOffset.y = 0;
}

U0 UpdatePlrMove()
{


  plrCol.isColTop = FALSE;
  plrCol.isColBottom = FALSE;
  plrCol.isColLeft = FALSE;
  plrCol.isColRight = FALSE;

  if(keys.shift)
  {
    plr.acceleration = 2.0;
  }
  else
  {
    plr.acceleration = 1.5;
  }

  if(keys.left)
  {
    plr.vel.x -= plr.acceleration;
    plr.isLookingRight = FALSE;
    plr.isWalking = TRUE;
  }
  if(keys.right)
  {
    plr.vel.x += plr.acceleration;
    plr.isLookingRight = TRUE;
    plr.isWalking = TRUE;
  }

  plr.vel.x /= FRICTION;

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
    }
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

}

CDC *GetPlayerWalkSprite(I8 frameNumber)
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

CDC *GetPlayerIdleSprite()
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

CDC *GetPlayerJumpSprite()
{
  if(plr.isLookingRight)
  {
    return tex_PMan_JumpRight;
  }
  else
  {
    return tex_PMan_JumpLeft;
  }
}


U0 UpdatePlayerAnimation()
{
   plr.curSprite = GetPlayerIdleSprite;
  if(plr.isWalking && !plr.isJumping)
  {
    if(plr.isJumping)
      return;
    if(plr.isFalling)
      return;
    plr.walk_frameSpeed--;
    if(plr.walkFrame > 3)
    {
      plr.walkFrame = 1;
    }
    if(plr.walk_frameSpeed <= 0)
    {
      plr.walkFrame++; 
      plr.walk_frameSpeed = 5;
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
      // DelBullet(bullet);
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











