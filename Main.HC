Cd(__DIR__);
#include "Globals.HC";

U0 CleanUp()
{
  // Free all the queues and stuff
}

U0 DrawIt(CTask *task, CDC *dc)
{
  GrPrint(dc, 0,0, "Hello World!");  
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
	    case 0:

	      switch(input2.u8[0])$IV,0$
	      {
		 case '\n':
		   // do nothing
                 break;
	      }

	    break;
	  }
	break;

	case MSG_KEY_DOWN:
	  switch(input1)
          {
	      case 0:

	      switch(input2.u8[0])
	      {
		 case '\n':
		   // do nothing
                 break;

	      }

	    break;
	  }
	break;

      }
  }

  SettingsPop;
}

Main;