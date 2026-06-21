U0 ShootBulletLogic()
{

  if(keys.space)
  {
    I64 bulletSpeed = 10;
    F64 distanceX = ms.pos.x - plr.myCollider->pos.x;
    F64 distanceY = ms.pos.y - plr.myCollider->pos.y;
    
    F64 totalDistance = Sqrt((distanceX * distanceX) + (distanceY * distanceY));

    Vector2 velocity;
    velocity.x = (distanceX / totalDistance) * bulletSpeed;
    velocity.y = (distanceY / totalDistance) * bulletSpeed;

    NewBullet(&velocity, plr.myCollider->pos.x, plr.myCollider->pos.y);
    keys.space = FALSE;
  }

}