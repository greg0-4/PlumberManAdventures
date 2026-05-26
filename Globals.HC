Bool g_Gaming = TRUE;

class Vector2
{
  F64 x,y;
};

class Collider : CQue
{
  Vector2 pos;
  Vector2 size;
  I64 type;
} collider_que;

class Player
{
  Collider *myCollider;
  Vector2 vel;
} plr;

class Keys
{
  Bool up,down,left,right,space;
} keys;

class Bullet : CQue
{
  Vector2 vel;
  Collider *myCollider;
} bullet_que;


Collider *NewCollider(F64 x1, F64 y1, F64 x2, F64 y2, F64 type)
{
  Collider *new = CAlloc(sizeof(Collider));
  new->pos.x = x1;
  new->pos.y = y1;
  new->size.x = x2;
  new->size.y = y2;
  new->type = type;
  QueIns(new, collider_que.last);
  return new;
}

U0 DelCollider(Collider *a)
{
  QueRem(a);
  Free(a);
}


Bullet *NewBullet(Vector2 *vel, F64 x, F64 y)
{
  "\n[%f] [%f]",vel->x,vel->y;
  Bullet *new = CAlloc(sizeof(Bullet));
  new->vel.x = vel->x;
  new->vel.y = vel->y;
  new->myCollider = NewCollider(x, y, 8, 8, 3);
  QueIns(new, bullet_que.last);
  return new;
}

U0 DelBullet(Bullet *a)
{
  DelCollider(a->myCollider);
  QueRem(a);
  Free(a);
}


Bool AABBCollision(Collider *a, Collider *b)
{
  if(a->pos.x > b->pos.x + b->size.x){
    return FALSE;
  }
  if(a->pos.x + a->size.x < b->pos.x){
    return FALSE;
  }
  if(a->pos.y > b->pos.y + b->size.y){
    return FALSE;
  }
  if(a->pos.y + a->size.y < b->pos.y){
    return FALSE;
  }
  return TRUE;
}

I64 gameMap[4][5] = {
  {1,1,1,1,1},
  {1,0,0,0,1},
  {1,0,0,0,1},
  {1,0,0,1,1}
};

Vector2 camOffset;

U0 InitMapColliders()
{
  I64 x,y = 0;
  for(x=0;x<4;x++)
  {
    for(y=0;y<4;y++)
    {
      I64 tile = gameMap[y][x];
      switch(tile)
      {
	case 1: NewCollider(x*24,y*24,24,24,2); break;
      }
    }
  }
}

I64 g_MouseX = ms.pos.x;
I64 g_MouseY = ms.pos.y;

U0 Init()
{
  QueInit(&collider_que);
  QueInit(&bullet_que);
  plr.myCollider = NewCollider(320, 0, 12, 12, 1);
  plr.vel.x = 0;
  plr.vel.y = 0;

  keys.up = FALSE;
  keys.down = FALSE;
  keys.left = FALSE;
  keys.right = FALSE;
  InitMapColliders;
}

Init;



