#define PLR_COLLIDER 1
#define WALL_COLLIDER 2
#define BULLET_COLLIDER 3
#define ENEMY_COLLIDER 4
#define ENEMY_D_COLLIDER 5

#define GRAVITY 1
#define FRICTION 1.3

#define MAP_WIDTH 1
#define MAP_HEIGHT 20

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
  Collider *footCol;
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
  I64 walk_frameSpeedReset;
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

class Enemy : CQue
{
  Collider *myCol;
  Vector2 vel;

  Bool grounded;
  Bool isLookingRight;
  I64 speed;
  CDC *curSprite;
};

class Slug : Enemy
{
  I64 Health;
  I64 walk_frameSpeed;
  I64 curFrame;

} slug_que;

class Particle : CQue
{
  Vector2 pos;
  Vector2 vel;
  CDC *curSprite;
} particle_que;

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

Slug *NewSlug(F64 x, F64 y)
{
  Slug *new = CAlloc(sizeof(Slug));
  new->myCol = NewCollider(x, y, 24, 12, ENEMY_COLLIDER);
  new->vel.x = 0;
  new->vel.y = 0;
  new->grounded = FALSE;
  new->isLookingRight = FALSE;
  new->curSprite = tex_Slug_Walk1Left;
  new->walk_frameSpeed = 3;
  new->curFrame = 1;
  new->speed = 2;
  new->Health = 1;
  QueIns(new, slug_que.last);
  return new;
}

U0 DelSlug(Slug *a)
{
  DelCollider(a->myCol);
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

Particle *NewParticle(F64 x, F64 y, CDC *sprite, F64 velX = 0, F64 velY = 0)
{
  Particle *new = CAlloc(sizeof(Particle));
  new->pos.x = x;
  new->pos.y = y;
  new->vel.x = velX;
  new->vel.y = velY;
  new->curSprite = sprite;
  QueIns(new, particle_que.last);
  return new;
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
  {1,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
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
  {1,0,0,0,0,0,0,0,0,0,0,0,0,1,0,3,0,1,0,0},
  {1,1,1,1,1,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1},
  {1,1,1,1,1,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1}
};

Vector2 camOffset;

U0 InitMapEntities()
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
        case 2: 
	  plr.myCollider->pos.x = x * 24 + 6;
	  plr.myCollider->pos.y = y * 24 + 6;
	break;
        case 3: NewSlug(x*24,y*24); break;
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
  QueInit(&particle_que);
  QueInit(&bullet_que);
  QueInit(&slug_que);

  plr.myCollider = NewCollider(0, 0, 12, 22, 1);
  plr.footCol = NewCollider(2, 22, 8, 4, 1); 
  plr.vel.x = 0;
  plr.vel.y = 0;
  plr.acceleration = 1.3;
  plr.gravity = 1;
  plr.curSprite = tex_PMan_IdleRight;
  plr.walk_frameSpeed = 5;
  plr.walk_frameSpeedReset = 5;
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
  InitMapEntities;
}


U0 PlayerDie()
{
  QueDel(&collider_que);
  QueDel(&bullet_que);
  QueDel(&slug_que);
  Init;
}

Init;



