
U0 UpdateCam()
{
  camOffset.x = plr.myCollider->pos.x - 320;
  camOffset.y = plr.myCollider->pos.y - 240;
}

U0 UpdatePlrMove()
{
  // plr.vel.y = 0;
  plr.vel.x = 0;

    

  if(keys.left)
  {
    plr.vel.x = -5;
  }
  if(keys.right)
  {
    plr.vel.x = 5;
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
        plr.myCollider->pos.x = temp->pos.x - 0.1 - plr.myCollider->size.x;
      }
      else
      {
	plr.myCollider->pos.x = temp->pos.x + 0.1 + temp->size.x;
      }
    }
    temp = next;
  }
  plr.vel.y += GRAVITY;

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
        plr.myCollider->pos.y = temp->pos.y - 0.1 - plr.myCollider->size.y;
        plr.grounded = TRUE;
        plr.vel.y = 0;
      }
      else
      {
   	plr.myCollider->pos.y = temp->pos.y + 0.1 + temp->size.y;
        plr.vel.y = 0;
      }
    }
    temp = next;
  }

  if(plr.vel.y != 0)
  {
    plr.grounded = FALSE;
  }

  if(keys.up && plr.grounded)
  {
    plr.vel.y = -10;
    plr.grounded = FALSE;
  }

  if(!keys.up && plr.vel.y < 0)
  {
    plr.vel.y *= 0.5;
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











