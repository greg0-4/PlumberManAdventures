Bool isColliderPlayer(Collider *a)
{
  if(a == plr.myCollider)
  {
    return TRUE;
  }

  if(a == plr.headCol)
  {
    return TRUE;
  }

  if(a == plr.footCol)
  {
    return TRUE;
  }
  return FALSE;
}

U0 ShootBulletLogic()
{

  if(keys.space)
  {
    I64 bulletSpeed = 10;
    F64 distanceX = ms.pos.x - plr.myCollider->pos.x;
    F64 distanceY = ms.pos.y - plr.myCollider->pos.y;
    
    F64 totalDistance = Sqrt((distanceX * distanceX) + (distanceY * distanceY));

    Vector2 velocity;
    velocity.x = (distanceX / totalDistance) * bulletSpeed;
    velocity.y = (distanceY / totalDistance) * bulletSpeed;

    NewBullet(&velocity, plr.myCollider->pos.x, plr.myCollider->pos.y);
    keys.space = FALSE;
  }

}

Bool isAbovePlayer()
{
  Collider *temp = collider_que.next;
  while(temp != &collider_que)
  {
    Collider *next = temp->next;
    Bool amIPlr = isColliderPlayer(temp);
    if(amIPlr)
    {
      goto cont;
    }
    if(AABBCollision(plr.headCol, temp))
    {
      return TRUE;
    }
    cont:
    temp = next;
  }
  return FALSE;
}