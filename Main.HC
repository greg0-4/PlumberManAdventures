Cd(__DIR__);
#include "Globals.HC";
#include "Actions.HC";
#include "Update.HC";
#include "Draw.HC";

U0 CleanUp()
{
  // Free all the queues and stuff
  QueDel(&collider_que);
  QueDel(&bullet_que);
}

U0 DrawIt(CTask *task, CDC *dc)
{
  // GrPrint(dc, 0,0, "[%d] [%d]", g_MouseX, g_MouseY);  
  UpdatePlrMove;
  UpdateBullets;
  UpdateCam;
  ShootBulletLogic;
  UpdateMousePos;
  DrawBullets(dc);
  DrawColliders(dc);
}

U0 Main()
{
  DocClear;
  WinMax;
  SettingsPush;
  WinBorder;
  DocCursor;
  Fs->draw_it = &DrawIt;
  I64 input1, input2;

  while(g_Gaming)
  {
      
      switch(GetMsg(&input1, &input2, 1<<MSG_KEY_DOWN+1<<MSG_KEY_UP))
      {
	case MSG_KEY_UP:
	  switch(input1)
          {
	    case CH_SHIFT_ESC: g_Gaming = FALSE; break;
	    case CH_SPACE: keys.space = FALSE; break;
            case 'w': keys.up = FALSE; break;
	    case 's': keys.down = FALSE; break;
	    case 'a': keys.left = FALSE; break;
	    case 'd': keys.right = FALSE; break;
	    case 0:

	      switch(input2.u8[0])$IV,0$
	      {
		case '\n':
		  // do nothing
                break;
		case SC_CURSOR_UP: keys.up = FALSE; break;
		case SC_CURSOR_DOWN: keys.down = FALSE; break;
		case SC_CURSOR_LEFT: keys.left = FALSE; break;
		case SC_CURSOR_RIGHT: keys.right = FALSE; break;
	      }

	    break;
	  }
	break;

	case MSG_KEY_DOWN:
	  switch(input1)
          {
	      case CH_SPACE: keys.space = TRUE; break;
	      case 'w': keys.up = TRUE; break;
	      case 's': keys.down = TRUE; break;
	      case 'a': keys.left = TRUE; break;
	      case 'd': keys.right = TRUE; break;
	      case 0:

	      switch(input2.u8[0])
	      {
		case '\n':
		  // do nothing
                break;
		case SC_CURSOR_UP: keys.up = TRUE; break;
		case SC_CURSOR_DOWN: keys.down = TRUE; break;
		case SC_CURSOR_LEFT: keys.left = TRUE; break;
		case SC_CURSOR_RIGHT: keys.right = TRUE; break;
	      }

	    break;
	  }
	break;

      }
  }
  CleanUp;
  SettingsPop;
}

Main;