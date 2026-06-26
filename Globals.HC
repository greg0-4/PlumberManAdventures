#define PLR_COLLIDER 1
#define WALL_COLLIDER 2
#define BULLET_COLLIDER 3
#define ENEMY_COLLIDER 4
#define TSHELL_COLLIDER 5

#define GRAVITY 1
#define FRICTION 1.3

#define MAP_WIDTH 1
#define MAP_HEIGHT 20

#define PLR_BIG_SIZE_Y 40

Bool g_Gaming = TRUE;

Bool g_Paused = FALSE;


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
  Collider *headCol;
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
  I8 powerUp;
  I8 walkFrame;
  I64 walk_frameSpeed;
  I64 walk_frameSpeedReset;

  Bool ducking;

  Bool immune;
  Bool immuneFlash;
  I8 immuneTimer;
  I8 immuneCycles;

  I8 pauseTimer;
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
  I64 *entityArray;
  I64 width;
  I64 height;
} current_map;

class Enemy : CQue
{
  Collider *myCol;
  Vector2 vel;
  I64 Health;
  Bool active;
  Bool grounded;
  Bool isLookingRight;
  F64 speed;
  CDC *curSprite;
};

class Slug : Enemy
{
  I64 walk_frameSpeed;
  I64 curFrame;

} slug_que;

class Turtle : Enemy
{
  I64 walk_frameSpeed;
  I64 curFrame;
} turtle_que;

class TShell : Enemy
{
  
} tshell_que;

class Shroom : Enemy
{

} shroom_que;

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
  new->active = FALSE;
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

Turtle *NewTurtle(F64 x, F64 y)
{
  Turtle *new = CAlloc(sizeof(Turtle));
  new->myCol = NewCollider(x, y, 22, 12, ENEMY_COLLIDER);
  new->vel.x = 0;
  new->active = FALSE;
  new->vel.y = 0;
  new->Health = 1;
  new->grounded = FALSE;
  new->isLookingRight = FALSE;
  new->curSprite = tex_Turtle_Walk1Left;
  new->walk_frameSpeed = 5;
  new->curFrame = 1;
  new->speed = 1.5;
  QueIns(new, turtle_que.last);
  return new;
}

U0 DelTurtle(Turtle *a)
{
  DelCollider(a->myCol);
  QueRem(a);
  Free(a);
}

TShell *NewTShell(F64 x, F64 y, Bool isLookingRight)
{
  TShell *new = CAlloc(sizeof(TShell));
  new->myCol = NewCollider(x, y, 15, 9, TSHELL_COLLIDER);
  new->Health = 1;
  new->curSprite = tex_Turtle_Shell;
  new->vel.x = 0;
  new->active = FALSE;
  new->vel.y = 0;
  new->grounded = FALSE;
  new->isLookingRight = isLookingRight;
  new->speed = 3;
  QueIns(new, tshell_que);
  return new;
}

U0 DelTShell(TShell *a)
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

U0 DelParticle(Particle *a)
{
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
  {1,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
  {1,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0},
  {1,0,0,0,0,0,0,0,0,0,0,1,4,0,0,0,0,4,1,0},
  {1,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,0},
  {1,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0},
  {1,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0},
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
      I64 tile = current_map.entityArray[x + y * current_map.width];
      switch(tile)
      {
	case 1: NewCollider(x*24,y*24,24,24,2); break;
        case 2: 
	  plr.myCollider->pos.x = x * 24 + 6;
	  plr.myCollider->pos.y = y * 24 + 6;
	break;
        case 3: NewSlug(x*24,y*24); break;
	case 4: NewTurtle(x*24,y*24 + 12); break;
      }
    }
  }
}

I64 g_MouseX = ms.pos.x;
I64 g_MouseY = ms.pos.y;

U0 LoadMap(U8 *file)
{
  U8 *buffer = FileRead(file);
  if(buffer == NULL)
  {
    return;
  }
  U8 *ptr = buffer;

  I64 width = Str2I64(ptr, 10 , &ptr);
  ptr++;
  I64 height = Str2I64(ptr, 10, &ptr);


  I64 *mapArray = MAlloc(width * height * sizeof(I64));
  I64 *entityArray = MAlloc(width * height * sizeof(I64));
  I64 x, y;
  for(y=0;y<height;y++)
  {
    for(x=0;x<width;x++)
    {
      while(*ptr == ' ' || *ptr == '\n' || *ptr == '\r')
      {
        ptr++;
      }
      mapArray[x + y * width] = Str2I64(ptr, 10, &ptr);
    }
  }

  for(y=0;y<height;y++)
  {
    for(x=0;x<width;x++)
    {
      while(*ptr == ' ' || *ptr == '\n' || *ptr == '\r') ptr++;
      entityArray[x + y * width] = Str2I64(ptr, 10, &ptr);
    }
  }


  Free(buffer);
  current_map.mapArray = mapArray;
  current_map.entityArray = entityArray;
  current_map.width = width;
  current_map.height = height;
}

U0 PlayerPowerUp()
{
  g_Paused = TRUE;
  plr.immune = TRUE;
  plr.powerUp = 1;
  F64 oldSizeY = plr.myCollider->size.y;
  plr.myCollider->size.y = PLR_BIG_SIZE_Y;
  F64 newSizeY = plr.myCollider->size.y;
  plr.myCollider->pos.y -= newSizeY - oldSizeY;
}


U0 Init()
{

  LoadMap("Maps/Test.TXT");
/*  current_map.mapArray = &gameMap;
  current_map.width = 20;
  current_map.height = MAP_HEIGHT; */
  QueInit(&collider_que);
  QueInit(&particle_que);
  QueInit(&bullet_que);
  QueInit(&slug_que);
  QueInit(&turtle_que);
  QueInit(&tshell_que);

  plr.headCol = NewCollider(0,-4, 12, 4, 1);
  plr.myCollider = NewCollider(0, 0, 12, 22, 1);
  plr.footCol = NewCollider(2, 22, 8, 4, 1); 
  plr.powerUp = 0;
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
  // Flashing sprite, not actual immune timer
  plr.immuneTimer = 0;
  plr.immune = FALSE;

  plr.pauseTimer = 15;

  plrCol.isColBottom = FALSE;
  plrCol.isColTop = FALSE;
  plrCol.isColLeft = FALSE;
  plrCol.isColRight = FALSE;

  keys.up = FALSE;
  keys.down = FALSE;
  keys.left = FALSE;
  keys.right = FALSE;
  keys.space = FALSE;
  LoadMap("/Maps/Test.TXT");
  InitMapEntities;
}


U0 PlayerDie()
{
  if(plr.myCollider->pos.y > 500)
  {
    goto cont;
  }
  if(plr.immune)
  {
    return;
  }
  if(plr.powerUp != 0)
  {
    plr.immune = TRUE;
    g_Paused = TRUE;
    plr.powerUp = 0;
    F64 oldSizeY = plr.myCollider->size.y;
    plr.myCollider->size.y = 22;
    F64 newSizeY = plr.myCollider->size.y;
    plr.myCollider->pos.y -= newSizeY - oldSizeY;
    return;
  }
  cont:
  QueDel(&collider_que);
  QueDel(&bullet_que);
  QueDel(&slug_que);
  Init;
}

Init;



