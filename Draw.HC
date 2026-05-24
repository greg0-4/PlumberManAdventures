
U0 DrawColliders(CDC *dc)
{
  dc->color = GREEN;
  Collider *temp = collider_que.next;
  while(temp != &collider_que)
  {
    Collider *next = temp->next;
    GrRect(dc, temp->pos.x - camOffset.x, temp->pos.y - camOffset.y, temp->size.x, temp->size.y);
    temp = next; 
  }
}