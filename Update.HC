
U0 UpdateCam()
{
  camOffset.x = plr.myCollider->pos.x - 320;
  camOffset.y = plr.myCollider->pos.y - 240;
}

U0 UpdatePlrMove()
{
  plr.vel.y = 0;
  plr.vel.x = 0;
  if(keys.up)
  {
    plr.vel.y = -5;
  }
  if(keys.down)
  {
    plr.vel.y = 5;
  }

    

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
    if(temp != plr.myCollider && AABBCollision(plr.myCollider, temp))
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

  plr.myCollider->pos.y += plr.vel.y;
  // Y Axis collision
  temp = collider_que.next;
  while(temp != &collider_que)
  {
    next = temp->next;
    if(temp != plr.myCollider && AABBCollision(plr.myCollider, temp))
    {
      if(plr.vel.y > 0)
      {
        plr.myCollider->pos.y = temp->pos.y - 0.1 - plr.myCollider->size.y;
      }
      else
      {
   	plr.myCollider->pos.y = temp->pos.y + 0.1 + temp->size.y;
      }
    }
    temp = next;
  }

}
