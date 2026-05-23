
U0 UpdatePlrMove()
{
  I8 direction = 0;
  if(keys.up)
  {
    plr.myCollider->pos.y--;
  }
  if(keys.down)
  {
    plr.myCollider->pos.y++;
  }
  if(keys.left)
  {
    plr.myCollider->pos.x--;
  }
  if(keys.right)
  {
    plr.myCollider->pos.x++;
  }

}