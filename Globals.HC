Bool g_Gaming = TRUE;

class Vector2
{
  I64 x,y;
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
  
} plr;

class Keys
{
  Bool up,down,left,right;
} keys;


Collider *NewCollider(I64 x1, I64 y1, I64 x2, I64 y2, I64 type)
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

U0 Init()
{
  QueInit(&collider_que);
  plr.myCollider = NewCollider(0, 0, 24, 24, 1);

  keys.up = FALSE;
  keys.down = FALSE;
  keys.left = FALSE;
  keys.right = FALSE;
}

Init;
