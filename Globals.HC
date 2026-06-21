#define PLR_COLLIDER 1
#define WALL_COLLIDER 2
#define BULLET_COLLIDER 3
#define ENEMY_COLLIDER 4
#define ENEMY_D_COLLIDER 5

#define GRAVITY 1
#define FRICTION 1.3

#define MAP_WIDTH 1
#define MAP_HEIGHT 20

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
  CDC *curSprite;
  Vector2 vel;
  Bool grounded;
  Bool isWalking;
  Bool isJumping;
  Bool isFalling;
  Bool isLookingRight;
  F64 gravity;
  F64 acceleration;
  I8 walkFrame;
  I64 walk_frameSpeed;
} plr;

class PlayerColStatus
{
  Bool isColBottom;
  Bool isColTop;
  Bool isColLeft;
  Bool isColRight;  
} plrCol;

class Keys
{
  Bool up,down,left,right,space,shift;
} keys;

class Bullet : CQue
{
  Vector2 vel;
  Collider *myCollider;
} bullet_que;

class Map
{
  I64 *mapArray;
  I64 width;
  I64 height;
} current_map;

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

// Basic Functions

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
  if(a->pos.x >= b->pos.x + b->size.x) return FALSE;
  if(a->pos.x + a->size.x <= b->pos.x) return FALSE;
  if(a->pos.y >= b->pos.y + b->size.y) return FALSE;
  if(a->pos.y + a->size.y <= b->pos.y) return FALSE;
  return TRUE;
}

I64 gameMap[MAP_HEIGHT][20] = {
  {1,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0},
  {1,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0},
  {1,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0},
  {1,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0},
  {1,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0},
  {1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
  {1,1,1,1,1,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1},
  {1,1,1,1,1,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1}
};

Vector2 camOffset;

U0 InitMapColliders()
{
  I64 x,y = 0;
  for(x=0;x<current_map.width;x++)
  {
    for(y=0;y<current_map.height;y++)
    {
      I64 tile = current_map.mapArray[x + y * current_map.width];
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
  current_map.mapArray = &gameMap;
  current_map.width = 20;
  current_map.height = MAP_HEIGHT;
  QueInit(&collider_que);
  QueInit(&bullet_que);
  plr.myCollider = NewCollider(0, 0, 12, 24, 1);
  plr.vel.x = 0;
  plr.vel.y = 0;
  plr.acceleration = 1.3;
  plr.gravity = 1;
  plr.curSprite = tex_PMan_IdleRight;
  plr.walk_frameSpeed = 5;
  plr.isLookingRight = TRUE;
  plr.grounded = FALSE;
  plr.isJumping = TRUE;


  plrCol.isColBottom = FALSE;
  plrCol.isColTop = FALSE;
  plrCol.isColLeft = FALSE;
  plrCol.isColRight = FALSE;

  keys.up = FALSE;
  keys.down = FALSE;
  keys.left = FALSE;
  keys.right = FALSE;
  keys.space = FALSE;
  InitMapColliders;
}

Init;



