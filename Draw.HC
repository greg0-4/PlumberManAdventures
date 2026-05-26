
U0 DrawColliders(CDC *dc)
{
  dc->color = GREEN;
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
    GrPrint(dc, temp->myCollider->pos.x - camOffset.x, temp->myCollider->pos.y - camOffset.y, "[%f] [%f]",temp->vel.x,temp->vel.y);
    temp = next;
  }
  dc->color = BLACK;
}