U0 ShootBulletLogic()
{

  if(keys.space)
  {
    I64 bulletSpeed = 10;
    F64 distanceX = ms.pos.x - 320.0;
    F64 distanceY = ms.pos.y - 240.0;
    
    F64 totalDistance = Sqrt((distanceX * distanceX) + (distanceY * distanceY));

    Vector2 velocity;
    velocity.x = (distanceX / totalDistance) * bulletSpeed;
    velocity.y = (distanceY / totalDistance) * bulletSpeed;

    NewBullet(&velocity, plr.myCollider->pos.x, plr.myCollider->pos.y);
    keys.space = FALSE;
  }

}