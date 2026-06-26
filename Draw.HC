
U0 DrawSky(CDC *dc)
{
  dc->dither_probability_u16=1;
  dc->color=ROPF_DITHER+LTBLUE<<16+WHITE;
  GrRect3(dc,0,0,0,640,480);
  GrBlot(dc, 500, 50, tex_Sun);
  GrBlot(dc, 100, 100, tex_Cloud);
  GrBlot(dc, 120, 105, tex_Cloud);
 GrBlot(dc, 220, 100, tex_Cloud);
 GrBlot(dc, 300, 90, tex_Cloud);
 GrBlot(dc, 320, 100, tex_Cloud);
  dc->color = BLACK;
}

U0 DrawColliders(CDC *dc)
{
dc->color=ROPF_DITHER+GREEN<<16+TRANSPARENT;
  Collider *temp = collider_que.next;
  while(temp != &collider_que)
  {
    Collider *next = temp->next;
    GrRect(dc, temp->pos.x - camOffset.x, temp->pos.y - camOffset.y, temp->size.x, temp->size.y);
    temp = next; 
  }
  dc->color = BLACK;
}

U0 DrawBullets(CDC *dc)
{
  dc->color = BLACK;
  Bullet *temp = bullet_que.next;
  while(temp != &bullet_que)
  {
    Bullet *next = temp->next;
    GrPrint(dc, temp->myCollider->pos.x - camOffset.x, temp->myCollider->pos.y - camOffset.y, "[%f] [%f]",temp->vel.x,temp->vel.y);
    temp = next;
  }
  dc->color = BLACK;
}

U0 DrawMap(CDC *dc)
{
  dc->color = BLACK;
  I64 x, y;
  for(x=0;x<current_map.width;x++)
  {
    for(y=0;y<current_map.height;y++)
    {
      I64 tile = current_map.mapArray[x + y * current_map.width];
      I64 posX = (x * 24) - camOffset.x;
      I64 posY = (y * 24) - camOffset.y;
      if(posX < -26)
      {
        break;
      }
      switch(tile)
      {

	case 1: GrBlot(dc, posX, posY, tex_Tile); break;
        case 2: GrBlot(dc, posX, posY, tex_Brick); break;
      }
    }
  }
  dc->color = BLACK;
}

U0 DrawPlayer(CDC *dc)
{
  if(plr.immuneFlash)
  {
    return;
  }

  F64 yOffset = 6;

  F64 yPos = plr.myCollider->pos.y - camOffset.y - 1;
  if(plr.powerUp != 0 && !plr.ducking)
  {
    yPos = yPos - yOffset;
  }

  if(plr.myCollider->size.y == PLR_BIG_SIZE_Y && plr.ducking)
  {
    yPos = plr.myCollider->pos.y + 18;
  }

  GrBlot(dc,
  plr.myCollider->pos.x - camOffset.x - 6,
  yPos,
  plr.curSprite);
}

U0 DrawSlugs(CDC *dc)
{
  Slug *temp = slug_que.next;
  while(temp != &slug_que)
  {
    Slug *next = temp->next;
    GrBlot(dc,
    temp->myCol->pos.x - camOffset.x,
    temp->myCol->pos.y - 12 -  camOffset.y,
    temp->curSprite);
    temp = next;
    
  }
  
}

U0 DrawParticles(CDC *dc)
{
  Particle *temp = particle_que.next;
  while(temp != &particle_que)
  {
    Particle *next = temp->next;
    GrBlot(dc,
    temp->pos.x - camOffset.x,
    temp->pos.y - camOffset.y,
    temp->curSprite);
    temp = next;
  }
}


U0 DrawTurtles(CDC *dc)
{
  Turtle *temp = turtle_que.next;
  while(temp != &turtle_que)
  {
    Turtle *next = temp->next;
    GrBlot(dc,
    temp->myCol->pos.x - camOffset.x,
    temp->myCol->pos.y - camOffset.y - 12,
    temp->curSprite);
    temp = next;
  }
}

U0 DrawTShells(CDC *dc)
{
  TShell *temp = tshell_que.next;
  while(temp != &tshell_que)
  {
    TShell *next = temp->next;
    GrBlot(dc,
    temp->myCol->pos.x - camOffset.x - 5,
    temp->myCol->pos.y - camOffset.y - 14,
    temp->curSprite);
    temp = next;
  }
}

U0 DrawShrooms(CDC *dc)
{
  Shroom *temp = shroom_que.next;
  while(temp != &shroom_que)
  {
    Shroom *next = temp->next;
    GrBlot(dc,
    temp->myCol->pos.x - camOffset.x,
    temp->myCol->pos.y - camOffset.y,
    temp->curSprite);
    temp = next;
  }
}

U0 DrawBricks(CDC *dc)
{
  Brick *temp = brick_que.next;
  while(temp != &brick_que)
  {
    Brick *next = temp->next;
    GrBlot(dc,
    temp->myCol->pos.x - camOffset.x,
    temp->myCol->pos.y - camOffset.y - temp->offsetY - 2,
    temp->curSprite);
    temp = next;
  }
}










